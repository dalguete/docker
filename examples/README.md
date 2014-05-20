Some examples
=============

Here are some example containers I use in my work. Some sensitive information has been
removed, so you can not accidentally access my containers :D
However if you build/run a container with given values, it will work with defaults

**IMPORTANT** As I said, some files store passwords and other sentitive information,
so it's **highly important** that you check them and make the required changes

Dockerfiles here defined are not used as TrustedBuilds for Docker, as these are
examples only

All images here defined use a similar scheme. A **Dockerfile** where all info to 
create the image is defined, and a **conf** folder that contains config files and 
scripts used in the image build and later container run processes.

When the container is run, supervisor will be in charge of starting all required
processes (defined in *conf/supervisord.conf*). Remember all defined programs there
must run in non-daemon mode, so supervisor can be on charge of them.

