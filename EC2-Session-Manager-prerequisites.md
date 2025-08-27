### If you want to do the Amazon Q CLI installation on Amazon EC2, and log in via 
### EC2 "Session Manager", copy & paste these steps:

```
# change from ssm-user to ec2-user:
sudo su - ec2-user
```
```
# install git:
sudo yum install git -y
# clone the repo:
git clone https://github.com/typex1/Amazon-Q-CLI-Easy-Install.git
cd Amazon-Q-CLI-Easy-Install/
# install Q CLI:
./install_q_cli.sh
```

Now continue with following the README: https://github.com/typex1/Amazon-Q-CLI-Easy-Install/blob/main/README.md
