# How to create a container to run a job in OpenShift using oc and ansible
"This tutorial guides you through the process of creating a versatile image for running jobs on OpenShift, utilizing OpenShift-CLI and Ansible. The jobs can execute generic Ansible scripts specified in a ConfigMap.

## Requeriments

* Podman version 4.8.2
* OpenShift 4.14
* Red Hat OpenShift Subscription


## Summary

* [Building a Custom UBI Image](#Building-a-Custom-UBI-Image)
    *[Create a Containerfile](#Create-a-Containerfile)
* [Pushing the Image to quay.io](#Pushing-the-Image-to-quay.io)
* [Creating a Ansible Script in a ConfigMap](#Creating-a-Ansible-Script-in-a-ConfigMap)
* [Deploying a cronjob](#Deploying-a-cronjob)



## Building a Custom UBI Image
This sesstion will learn how to create a personalized Universal Base Image (UBI) tailored to your requirements. First step is to create a Containerfile to install OpenShift-Cli and Ansible, you need a Red Hat Subscription to download the packages.

### Create a Containerfile

```Dockefile
#Base Image (1)
FROM registry.access.redhat.com/ubi9/ubi:9.3-1476 

#Red Hat Credencials  (2)
ARG USERNAME = default_username && \
    PASSWORD = default_password 

#Environment Variables (3)
ENV USERNAME=${USERNAME} \
    PASSWORD=${PASSWORD} \
    HOME=/opt/scripts

#Update and Install Packages (4)
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

#System Volume to store the playbooks (5)
VOLUME ${HOME}/playbooks 

USER 1001

#Default Example Command (6)
ADD example.yml ${HOME}/example.yml

#Default Ansible Configuration (7)
ADD ansible.cfg /etc/ansible/ansible.cfg
```

(1) The base image is the UBI 9.3, you can use any other base image, but you need to change the package manager and the commands to install the packages.

(2) The Red Hat Credencials are used to download the packages.

(3) The environment variables are used to store the credencials and the home directory.

(4) The packages are installed using the package manager dnf, you can use yum, but you need to change the commands.

(5) The system volume is used to store the playbooks, you can use any other directory, but you need to change Containerfile.

(6) The default command is used to run the example.yml playbook, you can change the command to run any other playbook.

(7) The default ansible.cfg file is used to configure the ansible, you can change the file to configure the ansible.


## Pushing the Image to quay.io
Explore the process of pushing your customized image to quay.io for seamless accessibility and distribution.

## Configuring an Ansible Script within a ConfigMap
Understand the steps involved in setting up an Ansible script within a ConfigMap, ensuring efficient configuration management.

## Deploying a CronJob
Discover how to deploy a scheduled job using cron, enabling automated and periodic execution of your configured tasks.





