FROM debian:stretch

LABEL maintainer "Benjamin Roziere <benjamin.roziere@clermont.in2p3.fr>"
LABEL maintainer "Fabrice Jammes <fabrice.jammes@clermont.in2p3.fr>"

WORKDIR /root

RUN apt-get -y update && \
    apt-get -y install apt-utils && \
    apt-get -y upgrade && \
    apt-get -y clean

RUN apt-get -y install curl bash-completion git \
    gnupg jq lsb-release mariadb-client \
    openssh-client parallel \
    python3 python3-yaml unzip vim wget && \
    ln -s /usr/bin/python3 /usr/bin/python

# Install Google cloud SDK
RUN export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && \
    echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key add - && \
    apt-get -y update && apt-get -y install google-cloud-sdk

# Install kubectl
ENV KUBECTL_VERSION 1.10.3
RUN wget -O /usr/local/bin/kubectl \
    https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

# Install kubectl aliases
RUN wget -O $HOME/.kubectl_aliases \
    https://rawgit.com/ahmetb/kubectl-alias/master/.kubectl_aliases

# Install kubectl completion
# setup autocomplete in bash, bash-completion package should be installed first.
RUN mkdir ~/.bash && kubectl completion bash > ~/.bash/kubectl.completion

# setup autocomplete in zsh
RUN mkdir ~/.zsh && kubectl completion bash > ~/.zsh/kubectl.completion

# Install terraform
RUN wget -O /tmp/terraform.zip \
    https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip && \
    unzip /tmp/terraform.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/terraform

ENV CLUSTER_CONFIG_DIR /root/.qserv
ENV KUBECONFIG $CLUSTER_CONFIG_DIR/kubeconfig
ENV QSERV_CONTAINER true

COPY ./openstack /root/openstack
COPY ./k8s /root/k8s
COPY ./image /root/image
COPY ./provision-install-test.sh /root/

RUN ln -s /root/k8s/kubectl/admin /root/admin
