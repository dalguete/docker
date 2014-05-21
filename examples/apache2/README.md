Apache2
=======

Installs Apache, PHP and xdebug. 

You can manage project files in a folder in host, and mount it into the container
as a volume. Recommended when working in a project alone, and don't wanna mess with
passing envs to other places.

In a more complex scenario, all can be stored inside docker, and control files passing
via git with continuous integration or something better.
