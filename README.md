# vscode-headless-liveserver

Extendable development environment host with fantastic remote operability via VSCode

- backed by vscode live sharing (multiple parties can work on the same codebase)
- debug/compile/intellisense live in the host environment
- reproducable dev environments - export your dev environment at any time as an image and share with your friends
- persistent development sessions
- keep your laptop cool and keep your code cool B)

# Dependencies

- docker
- xpra (auto-installs on debian or mac-osx)
- ssh

# Instructions (follow carefully)

Fetch, build and run the docker container in `tmux` on the headless liveserver (must have `docker-engine` installed)

```bash
git clone https://github.com/CallumJHays/vscode-headless-liveserver-docker
cd vscode-headless-liveserver-docker
docker build -t vscode .
```

Then run the image:

A) In the console

```
docker run -p 2020:22 vscode
```

Or B) in the background:

```
docker run -d -p 2022:22 vscode
```

`xpra` running `vscode` in the docker container should now be waiting for X11-forwarding ssh connections. Make note of the IP of the host to which you can connect from the client.

Note, the following works for macOSX and will probably work on most linux, more supported clients may be added.

We will set up an ssh config to make typing commands easier later.
Edit/Create the file `~/.ssh/config and append this section anywhere

```
# utilise port forwarding into a docker container on 'home'
Host vscode
	HostName 127.0.0.1
	User vscode
    Port 2022
```

Now SSH in, share identity credentials with and set a password for the master user:

```bash
ssh-copy-id vscode
ssh vscode
# once logged in
passwd
exit
```

If you use 2-Factor Authentication with the default `id_rsa` file, you should be able to access all of your git repos
within the container dev environment as you already copied your id over with `ssh-copy-id` earlier.

Now run the provided connection script which will start the default xpra X11 session if it doesn't exist,

```
./connect.sh
```
