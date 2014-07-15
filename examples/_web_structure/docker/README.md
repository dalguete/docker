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
next command can be applied.

And here is the command used:

```
sudo docker run -d \
--name='<container-name>' \
--hostname='<hostname>' \
[-v </path/to/host/folder>:</path/to/container/folder>] \
<image-name> \
[optional-command]
```

Having:

* `docker run -d` starts container daemonized.
* `--name='<container-name>'` set the container docker's name to something meaningful.
* `--hostname='<hostname>'` set the container's hostname to something meaningful.
* `[-v </path/to/host/folder>:</path/to/container/folder>]` mount a host folder into the container. Not all containers would need this, that's why that's optional.
* `<image-name>` as it name states, that's the image name to use
* `[optional-command]` command to execute. Set as optional, because images are supposed to execute something by default (check **ONBUILD** option set in dockerfiles in *examples* folder apps).

Again, all of these were simple suggestions, you can start containers in other ways, and if you better options, I'll be more than happy to know them.
