docker folder
-------------

All necessary files to start a container, like Dockerfile, conf files, init scripts, etc.

These must be grouped under subfolders, named by the app name used, for example Apache2,
MySQL, Varnish, etc.

Running a Docker container
==========================

It's up to you start and stop containers, but I use a common way, so I can set some stuff
there correctly. 

First of all, execute the command inside the app docker folder, so all contexts shown in the
next command can be applied. This assumes the folder **network**, specified at top of this repo
has been replicated in this container's folder app.

And here is the command used:

```
sudo docker run -d \
--name='<container-name>' \
--hostname='<hostname>' \
--lxc-conf="lxc.network.script.up='`pwd`/conf/network/up.sh'" \
--lxc-conf="lxc.network.script.down='`pwd`/conf/network/down.sh'" \
<image-name> \
[optional-command]
```

Having:

* `docker run -d` starts container daemonized.
* `--name='<container-name>'` set the container docker's name to something meaningful.
* `--hostname='<hostname>'` set the container's hostname to something meaningful.
* ``--lxc-conf="lxc.network.script.up='`pwd`/conf/network/up.sh'"`` set the network *up* script to execute, so the host can reach container by name.

  See `` `pwd` ``: that helps to create the correct path to the script.
* ``--lxc-conf="lxc.network.script.down='`pwd`/conf/network/down.sh'"`` set the network *down* script to execute, so the previous container hostname register in host, can be removed.

  See `` `pwd` ``: that helps to create the correct path to the script.

* `<image-name>` as it name states, that's the image name to use
* `[optional-command]` command to execute. Set as optional, because images are supposed to execute something by default (check **ONBUILD** option set in dockerfiles in *examples* folder apps).

Again, all of these were simple suggestions, you can start containers in other ways, and if you better options, I'll be more than happy to know them.
