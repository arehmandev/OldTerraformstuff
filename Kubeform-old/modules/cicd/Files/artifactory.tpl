#cloud-config
repo_update: true
repo_upgrade: all

runcmd:
- sudo wget https://bintray.com/jfrog/artifactory-rpms/rpm -O /etc/yum.repos.d/bintray-jfrog-artifactory-rpms.repo
- sudo yum update -y
- sudo yum install -y git java-1.8.0 jfrog-artifactory-oss
- sudo update-alternatives --set java /usr/lib/jvm/jre-1.8.0-openjdk.x86_64/bin/java
- sudo service artifactory start
- sudo echo Browse to $(curl http://169.254.169.254/latest/meta-data/public-ipv4):8081 for Artifactory
