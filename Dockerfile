FROM ubuntu:16.04

# Install dependencies and start services
RUN apt-get update -y && apt-get install -y openssh-server vim s3cmd
RUN service ssh start
#RUN mkdir /var/run/sshd

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
RUN sed 's@#PasswordAuthentication\s*yes@PasswordAuthentication yes@g' -i /etc/ssh/sshd_config

# Configure Linux for use case
 
RUN mkdir /incoming
RUN mkdir -p /incoming/log
RUN useradd -c "Test User 1" -m -d /incoming/user01 -s /bin/bash user01
RUN echo 'user01:passw0rd' | chpasswd

# Configure Environment
ENV LOG_DIR /incoming/log

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
