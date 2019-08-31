FROM alpine:3.10.2

RUN apk add --no-cache bash grep curl coreutils sudo git openjdk11 

# Create a user group 'dockeradm'
RUN addgroup dockeradm

# Create a user 'dockeradm' under 'dockeradm'
RUN adduser --disabled-password --gecos 'dockeradm' -s /bin/bash -G dockeradm dockeradm sudo
RUN echo 'dockeradm ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/users
	
# Switch to 'dockeradm'
USER dockeradm

ENV JAVA_HOME /usr/lib/jvm/default-jvm/jre
ENV PATH="$JAVA_HOME/bin:${PATH}"  
