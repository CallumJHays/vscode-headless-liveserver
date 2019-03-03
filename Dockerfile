FROM debian:buster-slim as exe

EXPOSE 22

# install xpra
ADD xpra_repo_gpg.asc .
RUN cat xpra_repo_gpg.asc | apt-key add - \
    && echo "deb http://winswitch.org/ buster main" > /etc/apt/sources.list.d/winswitch.list \
    && apt-get update
RUN apt-get install xpra

RUN mkdir ~/workspace
WORKDIR /home/user/workspace

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

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

CMD xpra start-desktop --start-child=code
