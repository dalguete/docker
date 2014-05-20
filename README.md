My Docker stuff
===============

Here you'll find all docker config, setup and info files that I use in order to create my docker base image. Can be found here https://index.docker.io/u/dalguete/ubuntu-14-04-64/


I created all of this while I was understanding docker and trying to create the best env for my day by day work, as web developer (among others). 


The Base Image
--------------

I'm kind of paranoic about what I get from the internet, so I decided not to use the images provided by Docker as base. Instead I created a brand new from scratch, and these are the steps I followed to achieve that;

* Install debootstrap in host system to create a base image. In case a different architecture is needed, take a look to 'man debootstrap' and/or 'man dpkg' to know what to do there. (for my case, I used 'Ubuntu Server 14.04 64 bits edition').

* Import that image into docker following guidelines set in http://docs.docker.io/articles/baseimages/

* Start the cointainer with that image, and start configuring it.

Configuring Base Image
----------------------

The idea with this base image is to have something the most similar to a fresh installation in a real host, with support packages and configs used commonly (at least for me). Next, detailed all changes made (some functional, other cosmetic but all necessary).

* Modify the .bashrc file in root user, and in /etc/skel, so the prompt displays in color (force_color_prompt), plus some adjustments to make it easily recognizable when connected via ssh, so you don't get confused with other terminals. This is the one I used:

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

* Update the /etc/apt/sources.list, so it haves this (replace *&lt;version name&gt;* with Ubuntu release name as trusty, precise, etc):

```
deb http://archive.ubuntu.com/ubuntu/ <version name> main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ <version name>-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ <version name>-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu/ <version name>-backports main restricted universe multiverse
```

* Performe `apt-get update` so the complete list of packages is available.

* Performe `apt-get dist-upgrade` to update system.

* Reconfigure time zone by running
  `dpkg-reconfigure tzdata`

* Install a bunch of base packages.
```
apt-get install git postfix openssh-server mailutils build-essential zip rar 
unrar software-properties-common python-software-properties supervisor 
telnet unattended-upgrades debconf-utils nano
```
`openssh-server` should be present already, but we list it, just in case.
And to config unattended upgrades run `dpkg-reconfigure unattended-upgrades`.

* It's good to free some space, so we run:
```
apt-get autoremove --purge
apt-get autoclean
```

* Add a new admin user, besides root, as you know, it's not a good practice to use root for anything (use `sudo` instead).
**IMPORTANT** When using this image as base, adjust it so this user is removed. This involves access concerns, so it's very important. You can always follow this steps and make changes that fits your requirement.
  
  * user: dalguete
  * pass: dalguete
  
I'm not a narcisist, I just use my nick everywhere because it's easy for me to remember, that's all :).
Add that new user to some groups:
```
adduser dalguete adm
adduser dalguete sudo
```
An entry in */etc/sudoers.d* was created for user dalguete, to prevent every 'sudo' command throw a password require. The file will contain
this `dalguete ALL=NOPASSWD: ALL`.
  
**IMPORTANT** In case any user here has a ssh-key generated, do NOT use those in public services, like GitHub or others, as you'd be sharing access to resources with other people. In case you want to work in a public env with this image, be sure you've taken all security measures.

* Copy my public key into this container (This is for convenience, so I don't have to type the pass when connecting via ssh).

**IMPORTANT** If you keep this user, remove my public key or I will access your container, sooner or later :D. Just kidding.

* When all is done, export the container to a tar file. Then import that image and use it as the brand new base (it'd be better to remove the previous images/containers used to build this last one).
 

Notes for derived containers
----------------------------
* Change users pass to protect access to your cointainer (use RUN commands in dockerfiles).
Removing the user here created would be a great idea.

* When running the container set 'hostname' to a meaninful value, and docker 'name' too (to easily find it). If necessary, inside container run 'sudo dpkg-reconfigure postfix', so email can be sent sucessfully (NOTE: don't forget to deal with port handling (container and/or host) so the container can send (and maybe receive) emails).

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


