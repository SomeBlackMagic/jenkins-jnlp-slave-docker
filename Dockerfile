FROM jenkins/jnlp-slave:3.27-1
USER root
#RUN apt update && apt install sudo
# Install docker client, kubectl and helm
RUN export DEBIAN_FRONTEND=noninteractive && \
    curl -sSL https://get.docker.com/ | sh && \
    curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    rm -f get_helm.sh && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod 755 kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    rm -rf /var/lib/apt/lists/*

RUN set -eux \
    && curl -L https://github.com/rancher/rke/releases/download/v1.1.3/rke_linux-amd64 -o /usr/local/bin/rke \
    && chmod +x /usr/local/bin/rke \
    && curl -L https://github.com/rancher/cli/releases/download/v2.4.5/rancher-linux-amd64-v2.4.5.tar.gz -o /tmp/rancher-linux-amd64-v2.4.5.tar.gz \
    && tar zxvf /tmp/rancher-linux-amd64-v2.4.5.tar.gz --strip-components=2 -C /usr/local/bin ./rancher-v2.4.5/rancher \
    && true


USER jenkins
