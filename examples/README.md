Some examples
=============

Here are some example containers I use in my work. Some sensitive information has been
removed, so you can not accidentally access my containers :D.
However if you build/run a container with given values, it will work with defaults.

Folder **_web_structure** holds the generic folders structure I use to maintain files
for a given project.

**IMPORTANT** As I said, some files store passwords and other sentitive information,
so it's **highly important** that you check them and make the required changes.

Dockerfiles here defined are not used as TrustedBuilds for Docker, as these are
examples only.

All images here defined use a similar scheme. A **Dockerfile** where all info to 
create the image is defined, and a **conf** folder that contains config files and 
scripts used in the image build and later container run processes.

When the container is run, supervisor will be in charge of starting all required
processes (defined in *conf/supervisord.conf*). Remember all defined programs there
must run in non-daemon mode, so supervisor can be on charge of them.


How I use them
--------------

Since Docker is in my life (so romantic!), now every aspect in my web developments
uses several docker instances, for example one container for Apache, other for MySQL
other for Varnish, other for Memcache, and so on, as many containers as the structure
supports (divide and conquer, you know).

For that, I migrated from my oldish style of virtual sites, bindfs mounts and this
and that, to this containers solution.

So what I do is the next:

* Create a folder structure like this
```
root
 |
 |--- db (all db related files, like backups, init scripts, etc, not handled in the web system)
 |
 |--- docs (all project docs, like requirements, agreements, specifications, you name it)
 |
 |--- htdocs (all site related files like Drupal, Symfony, etc)
 |
 |--- patches (all patches needed for the project to run, like Drupal core patches, etc)
 |
 |--- docker (all necessary files to start a container, like Dockerfile, conf file, init scripts, etc)
       |
       |--- Apache2 (all files needed to start this Apache2 container)
       |
       |--- MySQL (all files needed to start this MySQL container)
       |
       .
       .
       .
       |--- <insert app name> (all files needed to start <insert app name> container)
```

Config files for the different **docker** instances may vary, depending on requirements.

