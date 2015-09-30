My Docker stuff (for Ubuntu 15.04 64bits image)
===============================================

Here you'll find all docker config, setup and info files that I use in order to
create my docker base image. Can be found here https://index.docker.io/u/dalguete/ubuntu-15-04-64/

I created all of this while I was understanding docker and trying to create the
best env for my day by day work, as web developer (among others). 

Docker host installation
------------------------

As I'm working from a Ubuntu station, installing **Docker Engine** was pretty simple,
just follow the directions here https://docs.docker.com/installation/ubuntulinux/#installation.
Read next sections too until the bottom, as they have really good information

Also important to install **Docker Machine** following guidelines here https://docs.docker.com/machine/install-machine/#on-linux
and **Docker Compose**, as stated here https://docs.docker.com/compose/install/

**IMPORTANT** to note, Docker Machine can be used to install more Docker hosts, using
several providers. Give it a look, it's really interesting.

Other tools like *Docker Swarm* and *Kitematic* are not crucial in a daily use.
Feel free to understand/install them by checking this: for Swarm https://docs.docker.com/swarm/install-w-machine/
and for Kitematic https://docs.docker.com/kitematic/

The Base Image
--------------

I'm kind of paranoic about what I get from the internet, so I decided not to use the
images provided by Docker as base. Instead I created a brand new from scratch, and
these are the steps I followed to achieve that;

* Install debootstrap in host system to create a base image. In case a different
architecture is needed, take a look to 'man debootstrap' and/or 'man dpkg' to know
what to do there. (for my case, I used 'Ubuntu Server 15.04 64 bits edition').

* Import to create the image and move it into docker following guidelines set in 
http://docs.docker.io/articles/baseimages/

* Start the cointainer with that image, and start configuring it.

Configuring Base Image
----------------------

The idea with this base image is to have something the most similar to a fresh installation
in a real host, with support packages and configs used commonly (at least for me).
Next, detailed all changes made (some functional, other cosmetic but all necessary).

* Modify the .bashrc file in root user and in /etc/skel, so the prompt displays in color
(force_color_prompt), plus some adjustments to make it easily recognizable when connected
via ssh, so you don't get confused with other terminals. This is the one I used:

```
@@ -57,7 +57,7 @@
 fi
 
 if [ "$color_prompt" = yes ]; then
-    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
+    PS1='${debian_chroot:+($debian_chroot)}\[\033[00;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\][\w]\[\033[00m\]\$ '
 else
     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
 fi
``` 

* Update the /etc/apt/sources.list, so it has this (replace *&lt;version name&gt;*
with Ubuntu release name as trusty, precise, etc):

```
deb http://archive.ubuntu.com/ubuntu/ <version name> main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ <version name>-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ <version name>-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ <version name>-backports main restricted universe multiverse
```

* Perform `apt-get update` so the complete list of packages is available.

* Perform `apt-get dist-upgrade` to update system.

* Reconfigure time zone by running
  `dpkg-reconfigure tzdata`

* Install a bunch of base packages.
```
apt-get install -y \
	bash-completion \
	bindfs \
	build-essential \
	bsdmainutils \
	debconf-utils \
	git \
	mailutils \
	man-db \
	nano \
	openssh-server \
	postfix \
	python-software-properties \
	rar \ 
	software-properties-common \
	supervisor \
	telnet \
	unattended-upgrades \
	unrar \
	zip \
	zsh
```

* `openssh-server` should be present already, but we list it, just in case.
And to config unattended upgrades run `dpkg-reconfigure unattended-upgrades`.

* Installed **my-bindfs-mounts** solution, used as a helper for volumes mounted
inside the container, to avoid having to change ownerships or permissions, and stop
messing with owner and perms in host's folders.
Check the repo for this project here: http://github.com/dalguete/my-bindfs-mounts
```
add-apt-repository ppa:dalguete/my-bindfs-mounts
apt-get update
apt-get install my-bindfs-mounts
```

The purpose of this is better explained later in this doc. Check it out in the
 [BindFS in cointainers](#bindfs-motivation) section below.

* Installed **githooks** solution, used as a support in the git hooks handling, make
them transportable, etc.
Check the repo for this project here: https://github.com/dalguete/githooks
```
add-apt-repository ppa:dalguete/githooks
apt-get update
apt-get install githooks
```

* Installed **oh my zsh** tooling. Guidelines here (http://ohmyz.sh/) and here
(https://github.com/robbyrussell/oh-my-zsh/wiki/Installing-ZSH) were followed
for that.

* Files in **supervisor** subfolder have been copied to this image, to start some basic
services as soon as the container starts. Check [supervisor/](supervisor/) subfolder
to understand how it works, what services are started and how you can use it.

* It's not desirable that services start as soon as they got installed
(http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/),
that's why a **policy.rc-d** file needs to be setup. For that, run:
```
echo exit 101 > /usr/sbin/policy-rc.d
chmod +x /usr/sbin/policy-rc.d
```

* As you should know it's always better to not use root as the main user to interact
with services, so a checker script was installed that checks the existance of an
additional regular user for you to interact with the container.
```
add-apt-repository ppa:dalguete/only-root-user-complainer
apt-get update
apt-get install only-root-user-complainer
```

This is usually performed per derived image, via a **Dockerfile**. You can use the
next set of instructions to get this solved once for all.
```
RUN NEW_USER_NAME=<username> \
	&& NEW_USER_PASS=<password> \
	&& adduser $NEW_USER_NAME --disabled-password --gecos '' \
  && echo NEW_USER_NAME:NEW_USER_PASS | chpasswd \
  && echo NEW_USER_NAME:NEW_USER_PASS | chpasswd \
	&& adduser $NEW_USER_NAME adm \
	&& adduser $NEW_USER_NAME sudo \
  && echo "$NEW_USER_NAME ALL=NOPASSWD: ALL" > /etc/sudoers.d/$NEW_USER_NAME \
  && chmod 440 /etc/sudoers.d/$NEW_USER_NAME \
	&& unset NEW_USER_NAME NEW_USER_PASS
```
Where <username> is the new username to create and <password> is the password to set

The groups additions were made with the intention of giving the new user special
powers, so they can perform super user tasks.
The nice addition of the *sudoers* file entry is made just as a convenience, so the
new user won't have to type the password everytime super user tasks needs to be
performed.

To prevent a too rigid structure, these settings haven't been written to the image
itself, so you can have the chance create this user following your preferred approach,
and obviously, choose the username and password of your choice.

**IMPORTANT** In case you want to use ssh keys within your container's users, load
them as volumes from your host.
It's not recommended to move these keys with your image as there can be situations
where sensible information access could be compromised.
Putting private and public key in the image is as risky as using **root** user all
the time.

* When all is done, export the container to a tar file. Then import that image and
use it as the brand new base (it'd be better to remove the previous images/containers
used to build this last one).

* It's always good to free some space, so we run:
```
apt-get autoremove --purge
apt-get autoclean
```


Doc-Kerno
---------
Check this project, in case you want a complete env, for anything you want to deploy/test/dev/etc, using Docker images/containers as its main structural part. Give it a look at https://github.com/dalguete/doc-kerno.

Notes for derived containers
----------------------------
* Change users pass to protect access to your cointainer (use RUN commands in dockerfiles).
Removing the user here created would be a great idea.

* When running the container set 'hostname' to a meaninful value, and docker 'name' too (to easily find it). You can use **Fig** or **makefiles** to make the process easier to handle.

* If necessary, inside container run 'sudo dpkg-reconfigure postfix', so email can be sent sucessfully (NOTE: don't forget to deal with port handling (container and/or host) so the container can send (and maybe receive) emails).

  In case you want to use gmail as relay, do the following:
  
  * Configure postfix to send emails using the google account, following this guide:

    http://rs20.mine.nu/w/2011/07/gmail-as-relay-host-in-postfix/ 
    (seems to be broken, check in webarchive. It has really good info)

    New link to be used:
    https://rtcamp.com/tutorials/linux/ubuntu-postfix-gmail-smtp/

  * Also necessary to check the next link as could be some problems:

    http://databasically.com/2009/12/02/ubuntu-postfix-error-postdrop-warning-unable-to-look-up-publicpickup-no-such-file-or-directory/

  * In you want to add a disclaimer to all emails sent by the server, follow this:

    http://www.howtoforge.com/how-to-automatically-add-a-disclaimer-to-outgoing-emails-with-altermime-postfix-on-debian-squeeze

* Use the **Network** solution in case you want to access your container in an easier way (more here https://github.com/dalguete/docker/tree/master/network). 
  
* Use the **BindFS** solution in case you want to access host files/folders from inside your container and not having to deal with ownerships and permissions (more here https://github.com/dalguete/docker/tree/master/bindfs). 

  **IMPORTANT:** Keep in mind, this solution requires your container to use specific devices and caps. You can overcome all with *--privileged* flag, but you must know its use is discouraged.

<a name="bindfs-motivation"></a>
BindFS in cointainers
=====================

Volumes mounting process is not completely useful yet (in the future this hacks 
won't be necessary, but meanwhile...), because when a volume is mounted in a container,
user and groups ownership from host is mantained in container, and that leads to
some access problems from processes inside containers.

Let's clarify this with an example:
* Host folder to mount: `/home/john/www/`, with a file called `README`
* User: `john`, with uid 1012

**First problem**: When volume `/home/john/www/` is mounted in a container, let's say, 
inside `/mount-here`, file `README` there, will be owned by someone called **1012**, 
not a name, no one familiar for the container env. 

**Second problem**: When container writes to `/mount-here`, files and folders will 
belong to `root`, unless you run the container so it uses another user. But in host
(`/home/john/www/`) you will see files not belonging to you neither accessible by you 
(in the case of `root` owned ones).

All of this, because there's no chance to handle file ownership and perms from Docker
itself when mounting volumes (again, maybe in the future, but meanwhile...), so that's 
why I'm using a solution (I've been using for quite a long time in non containeraized
solutions), to let containers use volumes and hosts be happy with that.

my-bindfs-mounts scripts (the solution)
---------------------------------------

**IMPORTANT:** This solution requires the container to be run with **-privileged=true**
flag set, in order to let the container access fuse device and other stuff that is
done in back (https://github.com/dotcloud/docker/issues/929). As you (I guess),
I'm not fan of wide-open-doors-like solutions, as this seems to be, but I couldn't
find another way. 
I tried running containers with the lxc driver and setting `--lxc-conf="lxc.cgroup.devices.allow = c 10:229 rwm"`
set, but didn't work. It seems there's something else left to activate, so if you
know how to enable fuse access with no *-privileged* flag set, and you share that
with me, the beers are on me!!!

So, what to do
--------------

The first thing to do is to understand and enable **my-bindfs-mounts**, here https://github.com/dalguete/my-bindfs-mounts.
That is the base of everything, so please ensure you get that.

The **my-bindfs-mounts** service is executed at a very early stage (see supervisor file),
to ensure bindings are in place before going any further.

Then, in order to config the bindings creation, the file at **/etc/default/my-bindfs-mounts**
(in container) must be overriden with the custom things we want to define. You can
use the file provided here as guide. Every entry in that file, is what **bindfs**
command expects.
If nothing to mount has been specified, no error is thrown.

**IMPORTANT:** Take a close look to comments in file https://github.com/dalguete/docker/blob/master/bindfs/etc/default/my-bindfs-mounts
so you understand how to use it correctly. This is critical for you to have a clean
files/folders access experience.

Finally, enjoy. You'll see all bindings in place.

