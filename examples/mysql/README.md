MySQL
=======

Installs MySQL client and server, and phpmyadmin.

In mysql, a new user **admin** is created (root can be used too, but you know, root
user use is totally discouraged).

You can store all db data inside the container itself, and config it to replicate
to a slave server (in host maybe), so you can have data in a harder to delete place.
(I know it's relative, but removing a docker image is thousand times easier).
