FROM registry.access.redhat.com/ubi9/ubi:9.3-1476

#Red Hat Credencials
ARG USERNAME = default_username && \
    PASSWORD = default_password 

ENV USERNAME=${USERNAME} \
    PASSWORD=${PASSWORD} \
    HOME=/opt/scripts

#UPDATE SECURITY PATCHES
RUN subscription-manager register --username ${USERNAME} --password ${PASSWORD} && \
    subscription-manager repos --enable rhocp-4.13-for-rhel-9-x86_64-rpms && \
    dnf update -y --security --sec-severity=Important --sec-severity=Critical && \
    dnf install -y ansible-core.x86_64 && \
    dnf install -y openshift-clients.x86_64 && \
    dnf clean all && \
    mkdir -pv ${HOME} && \
    mkdir -pv ${HOME}/.ansible/tmp && \
    mkdir -pv ${HOME}/.kube/ && \
    mkdir -pv ${HOME}/playbooks && \
    chown -R 1001:root ${HOME} &&  \
    chgrp -R 0 ${HOME} && \
    chmod -R g+rw ${HOME} 

WORKDIR ${HOME}   

VOLUME ${HOME}/playbooks 

USER 1001

ADD example.yml ${HOME}/example.yml
ADD ansible.cfg /etc/ansible/ansible.cfg
