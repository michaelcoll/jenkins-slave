# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM debian:latest

# Standard SSH port
EXPOSE 22

# Install and configure a basic SSH server, JRE 7 and Git
RUN apt-get update &&\
    apt-get install -y openssh-server git openjdk-7-jre-headless &&\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd &&\
    sed -i 's|PermitRootLogin .*$|PermitRootLogin yes|' /etc/ssh/sshd_config &&\
    apt-get autoremove -y && apt-get autoclean -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get update &&\
    apt-get install -y git openjdk-7-jre-headless &&\
    apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Set user jenkins to the image
RUN echo "root:jenkins" | chpasswd

CMD ["/usr/sbin/sshd", "-D"]