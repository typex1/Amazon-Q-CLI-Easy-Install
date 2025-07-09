#!/bin/bash
# Improved git-simple.sh script with better error handling and feedback
# Usage: ./git-simple.sh [commit message]

# Color definitions for better output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Function to print status messages
print_status() {
  echo -e "${GREEN}[✓] $1${NC}"
}

# Function to print error messages
print_error() {
  echo -e "${RED}[✗] $1${NC}"
  exit 1
}

# Function to print warning messages
print_warning() {
  echo -e "${YELLOW}[!] $1${NC}"
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
fi

# Show current branch
BRANCH=$(git branch --show-current)
print_status "Working on branch: ${BRANCH}"

# Check if remote branch exists
REMOTE_EXISTS=$(git ls-remote --heads origin ${BRANCH} | wc -l)

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
fi

# Commit changes
echo "Committing changes with message: '${MSG}'..."
if git commit -m "${MSG}"; then
  print_status "Successfully committed changes"
else
  print_error "Failed to commit changes"
fi

# Push changes
echo "Pushing changes to remote repository..."
if git push -u origin ${BRANCH}; then
  print_status "Successfully pushed changes to remote repository"
else
  print_error "Failed to push changes. Check your remote repository configuration and permissions."
fi

print_status "All operations completed successfully!"
