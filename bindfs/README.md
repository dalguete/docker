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
why I'm using a solution I've been using for quite a long time, to let containers
use volumes and hosts be happy with that.

my-bindfs-mounts scripts (the solution)
=======================================

The first thing to do is to understand and enable **my-bindfs-mounts**, here 
https://github.com/dalguete/my-bindfs-mounts. That is the base of everything, so 
please ensure you get that.

The **my-bindfs-mounts** service must be executed prior to any service that we want
to affect. For that, you can use a process control service, like supervisor, to
trigger it. Some config files for that are provided here.

Then, in order to config the bindings creation, the file at **/etc/default/my-bindfs-mounts**
(in the container) must be overriden with the custom things we want to define.
You can use the file provided here as a guide. Every entry in that file, is what 
**bindfs** command expects.

Finally, enjoy. You'll see all bindings in place.
