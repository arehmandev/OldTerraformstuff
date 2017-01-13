#cloud-config
repo_update: true
repo_upgrade: all

runcmd:
- sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
- sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
- sudo yum update -y
- sudo yum install -y git java-1.8.0
- sudo pip install ansible
- sudo service jenkins start
- sudo chkconfig jenkins on
- sudo echo Browse to $(curl http://169.254.169.254/latest/meta-data/public-ipv4):8080 for Jenkins
- sudo echo The Jenkins passphrase is $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword
