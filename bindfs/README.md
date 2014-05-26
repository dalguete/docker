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
why I extended a solution I've been used for quite a long time, to let containers
use volumes and hosts be happy with that.

my-bindfs-mounts scripts (the solution)
=======================================
