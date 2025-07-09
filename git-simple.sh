#!/bin/bash
# Simple git workflow script with clear feedback
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

print_status "Local commit successful!"
print_info "To push these changes to GitHub, you'll need to set up authentication."
print_info "Run the following command to push your changes:"
print_info "  git push -u origin ${BRANCH}"
print_info ""
print_info "If you get authentication errors, you'll need to set up GitHub credentials."
print_info "See: https://docs.github.com/en/authentication"
