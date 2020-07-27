FROM jenkins/inbound-agent:4.3-7
USER root
#RUN apt update && apt install sudo
# Install docker client, kubectl and helm

RUN set -eux \
    && export DEBIAN_FRONTEND=noninteractive \
    && curl -sSL https://get.docker.com/ | sh \
    && apt install -y aufs-tools \
    && rm -rf /var/lib/apt/lists/* \
    && true

RUN set -eux \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod 755 kubectl \
    && mv kubectl /usr/local/bin/kubectl \
    && true

RUN set -eux \
    && cd /tmp \
    && curl https://get.helm.sh/helm-v3.2.4-linux-amd64.tar.gz > helm-v3.2.4-linux-amd64.tar.gz \
    && tar -zxvf helm-v3.2.4-linux-amd64.tar.gz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && true


RUN set -eux \
    && curl -L https://github.com/rancher/rke/releases/download/v1.1.3/rke_linux-amd64 -o /usr/local/bin/rke \
    && chmod +x /usr/local/bin/rke \
    && true

RUN set -eux \
    && curl -L https://github.com/rancher/cli/releases/download/v2.4.5/rancher-linux-amd64-v2.4.5.tar.gz -o /tmp/rancher-linux-amd64-v2.4.5.tar.gz \
    && tar zxvf /tmp/rancher-linux-amd64-v2.4.5.tar.gz --strip-components=2 -C /usr/local/bin ./rancher-v2.4.5/rancher \
    && true

COPY daemon.json /etc/docker/daemon.json
RUN usermod -aG docker jenkins

COPY jenkins-slave.sh /usr/local/bin/jenkins-slave
ADD daemon.json /etc/docker/daemon.json

USER jenkins
ENTRYPOINT ["/usr/local/bin/jenkins-slave"]
