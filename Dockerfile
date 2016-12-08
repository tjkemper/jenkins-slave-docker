FROM jenkinsci/jnlp-slave:2.62

### elevate permissions
USER root

### install sudo and curl
RUN apt-get update \
      && apt-get install -y sudo curl\
      && rm -rf /var/lib/apt/lists/*

# Install docker-engine
# According to Petazzoni's article:
# ---------------------------------
# "Former versions of this post advised to bind-mount the docker binary from
# the host to the container. This is not reliable anymore, because the Docker
# Engine is no longer distributed as (almost) static libraries."

# correct server version
ARG docker_version=1.11.2
RUN curl -sSL https://get.docker.com/ | sh && \
    apt-get purge -y docker-engine && \
    apt-get install docker-engine=${docker_version}-0~jessie

# Install kubectl
RUN curl -O https://storage.googleapis.com/kubernetes-release/release/v1.4.3/bin/linux/amd64/kubectl \
    && chmod +x kubectl \
    && sudo cp kubectl /usr/local/bin/kubectl

# Give the jenkins user sudo privileges in order to be able to run Docker commands inside the container.
# see: http://container-solutions.com/running-docker-in-jenkins-in-docker/
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

### drop back to the regular jenkins user - good practice
# USER jenkins

