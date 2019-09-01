FROM alpine:3.10.2

# Add and install required software packages
RUN apk add --no-cache bash grep curl coreutils sudo git openjdk8 maven

# Create a user group 'dockeradm'
RUN addgroup dockeradm

# Create a user 'dockeradm' under 'dockeradm'
RUN adduser --disabled-password --gecos 'dockeradm' -s /bin/bash -G dockeradm dockeradm sudo
RUN echo 'dockeradm ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/users

# Set JAVA_HOME and prepend to PATH environment variables.
ENV JAVA_HOME /usr/lib/jvm/default-jvm
ENV PATH="$JAVA_HOME/bin:${PATH}"

# Change ownership of /opt directory to dockeradm
RUN chown dockeradm:dockeradm /opt

# Switch to 'dockeradm'
USER dockeradm

# Pull, build, and setup gigaspaces
WORKDIR "/home/dockeradm"
RUN git clone -b 14.5.0-patch-d-1 --depth 1 https://github.com/xap/xap.git
RUN /home/dockeradm/xap/build.sh
RUN cp -pi /home/dockeradm/xap/xap-dist/target/gigaspaces-xap-14.5.0-patch-d-1-m1-ci-0.zip /opt

WORKDIR "/opt"
RUN unzip /opt/gigaspaces-xap-14.5.0-patch-d-1-m1-ci-0.zip
RUN ln -s gigaspaces-xap-14.5.0-patch-d-1-m1-ci-0 gigaspaces
RUN rm /opt/gigaspaces-xap-14.5.0-patch-d-1-m1-ci-0.zip
