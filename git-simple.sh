#!/bin/bash
# Simple git workflow script with SSH support
# Usage: ./git-simple.sh [commit message]

# Color definitions for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
  echo -e "${GREEN}[✓] $1${NC}"
}

# Function to print error messages
print_error() {
  echo -e "${RED}[✗] $1${NC}"
}

# Function to print warning messages
print_warning() {
  echo -e "${YELLOW}[!] $1${NC}"
}

# Function to print info messages
print_info() {
  echo -e "${BLUE}[i] $1${NC}"
}

# Set commit message
if [ $# -eq 1 ]; then
  MSG="${1}"
else
  MSG="update"
  print_warning "No commit message provided. Using default: '${MSG}'"
fi

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  print_error "Not in a git repository. Please run this script from within a git repository."
  exit 1
fi

# Show current branch
BRANCH=$(git branch --show-current)
print_status "Working on branch: ${BRANCH}"

# Check if remote branch exists
REMOTE_EXISTS=$(git ls-remote --heads origin ${BRANCH} 2>/dev/null | wc -l)

if [ ${REMOTE_EXISTS} -eq 1 ]; then
  # Pull latest changes only if remote branch exists
  echo "Pulling latest changes..."
  if git pull origin ${BRANCH}; then
    print_status "Successfully pulled latest changes"
  else
    print_warning "Failed to pull latest changes. Continuing without pulling."
  fi
else
  print_warning "Remote branch '${BRANCH}' doesn't exist yet. Skipping pull."
fi

# Check for changes
if [ -z "$(git status --porcelain)" ]; then
  print_warning "No changes to commit"
  exit 0
fi

# Add all changes
echo "Adding all changes..."
if git add --all; then
  print_status "Successfully added all changes"
else
  print_error "Failed to add changes"
  exit 1
fi

# Commit changes
echo "Committing changes with message: '${MSG}'..."
if git commit -m "${MSG}"; then
  print_status "Successfully committed changes"
else
  print_error "Failed to commit changes"
  exit 1
fi

# Push changes
echo "Pushing changes to remote repository using SSH..."
if git push -u origin ${BRANCH}; then
  print_status "Successfully pushed changes to remote repository"
else
  print_error "Failed to push changes"
  print_info "This could be due to:"
  print_info "1. SSH key issues - Make sure your SSH key is properly set up"
  print_info "2. Remote branch protection rules"
  print_info "3. Network connectivity issues"
  print_info ""
  print_info "Your changes have been committed locally. To push them later, run:"
  print_info "  git push -u origin ${BRANCH}"
  exit 1
fi

print_status "All operations completed successfully!"
