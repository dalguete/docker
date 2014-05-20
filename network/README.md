Network Scripts
===============

These scripts let us handle the process of registering a container name with its
ip via dnsmasq. That way, the host can reach container via its name, not only via
ip, that in turn is more human friendly.

Usage
-----

For the container to use the scripts, docker daemon must be set to use lxc as
exec driver (libcontainer doesn't handle lxc options, neither has a way to add
hooks into the lauching container process).

You can change that settings in command line (`docker --help` for more info) or
changing *DOCKER_OPTS* in docker config file.

Below an example:

```
sudo docker run -it --hostname='my-cool-host' \
--lxc-conf="lxc.network.script.up=/path/to/scripts/folder/up.sh" \
--lxc-conf="lxc.network.script.down=/path/to/scripts/folder/down.sh" \
dalguete/ubuntu-14-04-64 bash
```

You'll see that your host will be reachable at **my-cool-host.docker**. Just try
`ping my-cool-host.docker`.
