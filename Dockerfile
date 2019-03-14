FROM debian:buster

# expose ssh for client connection
EXPOSE 22

# install xpra
ADD xpra_repo_gpg.asc .
RUN apt-get update \
    && apt-get install -y gnupg2 \
    && cat xpra_repo_gpg.asc | apt-key add - \
    && rm xpra_repo_gpg.asc \
    && echo "deb http://winswitch.org/ buster main" > /etc/apt/sources.list.d/winswitch.list \
    && apt-get update \
    && apt-get install -y xpra

# install vscode
RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    --no-install-recommends

# Add the vscode debian repo
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | apt-key add -
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list

RUN apt-get update && apt-get -y install \
    sudo \
    code \
    git \
    libasound2 \
    libatk1.0-0 \
    libcairo2 \
    libcups2 \
    libexpat1 \
    libfontconfig1 \
    libfreetype6 \
    libgtk2.0-0 \
    libpango-1.0-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    openssh-client \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y \
    python-avahi \
    python-uinput \
    xserver-xorg \
    xorg \
    xinit \
    jwm \
    openssh-server

RUN useradd -m -d /home/master/ -s /bin/bash -G sudo master \
    && echo 'master:vscode' | chpasswd \
    && mkdir /run/xpra && chown master /run/xpra \
    && mkdir /run/user && chown master /run/user \
    && mkdir /run/sshd && /usr/sbin/sshd  \
    && service ssh restart \
    && /usr/bin/ssh-keygen -A

USER master

# create a bunch of folders that xpra needs but can't make itself
RUN cd /run/user \
    && mkdir ./1000 \
    && mkdir ./1000/xpra

WORKDIR /home/master/workspace

# start a default xpra server
CMD sudo echo service ssh status && xpra start-desktop :2022 --daemon=no --mdns=no --bind-tcp=0.0.0.0:2022 --start=code
