FROM ubuntu:trusty
MAINTAINER Pharserror <sunboxnet@gmail.com>
ENV REFRESHED_AT 2015-09-03

# Setup environment
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV RUBY_VERSION 2.2.0
ENV BITBUCKET_USER=buttfart
ENV BITBUCKET_PASS=password
ENV BITBUCKET_PROJECT=eve-init

USER root

# Setup User
RUN useradd --home /home/worker -M worker -K UID_MIN=10000 -K GID_MIN=10000 -s /bin/bash
RUN mkdir /home/worker
RUN chown worker:worker /home/worker
RUN adduser worker sudo
RUN echo 'worker ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER worker

# Update apt packages
RUN sudo apt-get update

# Install packages
RUN sudo apt-get install -y git htop ncdu build-essential libssl-dev libffi-dev curl python-dev python-pip python-virtualenv 

# Install python-eve
RUN sudo pip install redis eve flask-sentinel

COPY ./mongo-setup.js /
COPY ./init.sh /
RUN sudo chown worker:worker /init.sh
RUN sudo chmod +x /init.sh
ENTRYPOINT ["/init.sh"]
