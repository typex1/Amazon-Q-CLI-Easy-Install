# Q-CLI-Easy-Install

Easy installation script for Amazon Q CLI on Linux systems

Source: https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-installing-ssh-setup-autocomplete.html

## Overview

This repository provides a simple script to automate the installation of Amazon Q CLI.

## Installation

To install Amazon Q CLI, simply run:

```bash
./install_q_cli.sh
```

This will automatically install the latest version of Amazon Q CLI on your system.

The script will automatically:
- Detect your system architecture (x86_64 or aarch64)
- Check your glibc version
- Download the appropriate Amazon Q CLI version
- Install it on your system

## Requirements

- Linux (x86_64 or aarch64)
- curl
- unzip

The script has been tested on Amazon Linux 2, Ubuntu, and Debian.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

If you encounter any issues with the installation script, please open an issue on GitHub.
