### If you want to do the Amazon Q CLI installation on Amazon EC2, and log in via 
### EC2 "Session Manager", copy & paste these steps:

```
# make sure you are in the home dir which is writeable:
cd ~

# Check if git is available, install if not
if ! command -v git &> /dev/null; then
    echo "Git not found. Installing git..."
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y git
    elif command -v yum &> /dev/null; then
        sudo yum install -y git
    else
        echo "Error: Neither apt nor yum package manager found. Please install git manually."
        exit 1
    fi
    echo "Git installed successfully."
else
    echo "Git is already available."
fi

# clone the repo:
git clone https://github.com/typex1/Amazon-Q-CLI-Easy-Install.git
cd Amazon-Q-CLI-Easy-Install/

# install Q CLI:
./install_q_cli.sh
```

Now continue with following the README: https://github.com/typex1/Amazon-Q-CLI-Easy-Install/blob/main/README.md
