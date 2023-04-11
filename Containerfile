###Linux

FROM ubi8/ubi@sha256:b41ed65a624ee013c4c7107ec3ced8ac4e957dc58bff8906b885dd396f130094

USER root

ENV TEMP_DIR='/tmp'

ENV ARCH="linux-amd64"

 

### Utils Linux

RUN dnf install -y iputils wget gcc man rsync openssh-clients vim sudo

 

### git

RUN dnf install -y git

 

### Helm

ENV HELM_TGZ="helm-v3.7.0-linux-amd64.tar.gz"

COPY $HELM_TGZ $TEMP_DIR

WORKDIR $TEMP_DIR

RUN tar xzf $HELM_TGZ

RUN mv ${ARCH}/helm /usr/local/bin

RUN chmod +x /usr/local/bin/helm

#ENTRYPOINT ["/usr/local/bin/helm"]

#CMD ["--help"]

 

### Kubectl && OC

ENV KUBE_TGZ="openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz"

COPY $KUBE_TGZ $TEMP_DIR

WORKDIR $TEMP_DIR

RUN tar xzf $KUBE_TGZ 2> /dev/null \

    && mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/kubectl openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin \

    && chmod +x /usr/local/bin/kubectl \

    && chmod +x /usr/local/bin/oc

 

### Terraform cli

ENV TF_ZIP="terraform_1.0.7_linux_amd64.zip"

COPY $TF_ZIP $TEMP_DIR

WORKDIR $TEMP_DIR

RUN yum install -y unzip \

    && unzip $TF_ZIP \

    && mv terraform /usr/local/bin \

   && chmod +x /usr/local/bin/terraform

 

### Java 11

RUN dnf install -y java-11-openjdk-devel

 

### Add user 'user1'

RUN useradd -ms /bin/bash user1

RUN echo "user1:user1" | chpasswd

RUN echo 'user1 ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER user1

WORKDIR /home/user1

CMD /bin/bash