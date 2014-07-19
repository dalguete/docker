Network Scripts
===============

These scripts let us handle the process of registering a container name with its ip, so host and any other container running, will know it and be able to access the new container using a human friendly name.

Usage
-----

This requires you to install and config RabbitMQ in host. Also, some file settings in every container must be added so the container can talk to host.

### In Host

* First of all, the RabbitMQ server must be installed. For that, please follow guidelines set here http://www.rabbitmq.com/download.html

* Config RabbitMQ doing the following:

  * `sudo rabbitmqctl add_vhost <vhost_name>`, add a new vhost to the server. This is to isolate all my-docker-network stuff. `<vhost_name>` can be any string that makes sense to you.

  * `sudo rabbitmqctl add_user <username> <password>`, create a new user with a given password.

  * `sudo rabbitmqctl set_user_tags <username> administrator`, turns the user into and administrator.

  * `sudo rabbitmqctl set_permissions -p <vhost_name> <username> ".*" ".*" ".*"`, gives the new user total perms over recently created vhost.

* Install **pika** by running `sudo pip install pika==0.9.8`

* Install **dnsmasq** service in host with `sudo apt-get install dnsmasq`

* Some changes around *Docker* service must be done, so containers use our host a DNS server. For that:

  * Stop docker service

  * Set the next option to **DOCKER_OPTS** entry

    ```
    --dns `ifconfig docker0 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`
    ```

    Initially other option was used (as stated here http://pavel.karoukin.us/node/11), but it didn't work well in wireless connections, so it was changed for the line above.

    We are assuming **docker0** will be the name of the bridge interface. In case you are using something else,
change accordingly.

    That way, docker will use a host's ip address as default DNS server

  * Start docker service

* Copy the following files in corresponding places, and then do the some changes:

  * Files to copy are:
    
    - /etc/my-docker-network-hosts
    - /etc/default/my-docker-network
    - /etc/dnsmasq.d/my-docker-network
    - /etc/init.d/my-docker-network
    - /usr/local/bin/*

  * Set perms and ownerships in files as follows
    ```
    sudo chown root.root /usr/local/bin/my-docker-network*
    sudo chown root.root /etc/my-docker-network-hosts
    sudo chown root.root /etc/default/my-docker-network
    sudo chown root.root /etc/dnsmasq.d/my-docker-network
    sudo chown root.root /etc/init.d/my-docker-network
    sudo chmod u+rwx,go+r-wx /usr/local/bin/my-docker-network*
    sudo service dnsmasq restart
    ```

  * Adjust **/etc/default/my-docker-network** values so it uses RabbitMQ settings, as set above.

  * Create an upstart process with *my-docker-network* by running `sudo update-rc.d my-docker-network defaults`.

  * Start the service

### In Containers

Some files need to be copied to container's images. This files are:

- /etc/default/my-docker-network
- /etc/supervisor/conf.d/my-docker-network.conf
- /usr/local/bin/my-docker-network
- /usr/local/bin/my-docker-network-emit

By default they are set to do nothing, so when you build the image, you have to override a config file (**/etc/default/my-docker-network**)  with settings to make the magic happen.

In the container **pika** must be installed too. For that, run inside it: `sudo pip install pika==0.9.8`

When running the container, use the flag `--hostname`, to set a human friendly name in the container. Otherwise, your containers will be accesible at random names Docker generates, and that's not useful as you may notice.

Next an example

```
sudo docker run -it --hostname='my-cool-host' dalguete/ubuntu-14-04-64 bash
```

You'll see that your host will be reachable at **my-cool-host.docker**. Just try `ping my-cool-host.docker`, from host or any container that has this solution set.
