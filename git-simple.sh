#!/bin/bash
# Improved git-simple.sh script with better error handling and authentication
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

# Ensure git user is configured
if [ -z "$(git config --get user.name)" ] || [ -z "$(git config --get user.email)" ]; then
  print_info "Setting up git user configuration..."
  git config --global user.name "EC2 User"
  git config --global user.email "ec2-user@example.com"
  print_status "Git user configured"
fi

# Configure credential helper to cache credentials
git config --global credential.helper cache
print_status "Credential helper configured to cache credentials"

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

# Check if the remote repository exists
if ! git ls-remote origin -h HEAD &> /dev/null; then
  print_warning "Remote repository may not exist or is not accessible"
  print_info "Attempting to create remote branch..."
  
  # Try to initialize the remote repository by force pushing
  if git push -u origin ${BRANCH} --force; then
    print_status "Successfully initialized remote repository and pushed changes"
  else
    print_error "Failed to initialize remote repository"
    print_info "Please ensure the remote repository exists and you have proper access"
    print_info "Your changes have been committed locally. To push them later, run:"
    print_info "  git push -u origin ${BRANCH}"
    exit 1
  fi
else
  # Remote exists, try to push
  echo "Pushing changes to remote repository..."
  if git push -u origin ${BRANCH}; then
    print_status "Successfully pushed changes to remote repository"
  else
    print_error "Failed to push changes"
    print_info "This could be due to:"
    print_info "1. Authentication issues - Make sure you have the right credentials set up"
    print_info "2. Remote branch protection rules"
    print_info "3. Network connectivity issues"
    
    # Try force push as a last resort
    print_info "Attempting force push as a last resort..."
    if git push -u origin ${BRANCH} --force; then
      print_status "Successfully force pushed changes to remote repository"
    else
      print_error "Force push also failed"
      print_info "Your changes have been committed locally. To push them later, run:"
      print_info "  git push -u origin ${BRANCH}"
      exit 1
    fi
  fi
fi

print_status "All operations completed successfully!"
