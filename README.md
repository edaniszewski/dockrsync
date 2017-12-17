# dockrsync
dockrsync provides rsync with basic sleep-based scheduling within a docker container.
This makes it easy to sync local files remotely without having to set up `rsync`/`cron`
locally.

## Getting
dockrsync can either be build locally by cloning this repo and running `make build` or
can be pulled from DockerHub
```
docker pull edaniszewski/dockrsync
```

## Example Usage
An example scenario for how dockrsync could be used: you are developing an application for
the Raspberry Pi. Instead of developing directly on the Pi, you want to develop on your
machine. dockrsync can be used to sync the local project files to the Raspberry Pi. Assuming
SSH is already set up on the Pi, you will need to enable password-less SSH by using SSH keys.
 
There are plenty of tutorials how to do this elsewhere in more detail, but briefly this would
be generating a key on your dev machine via `ssh-keygen`, then copying the public key over to
the Pi at `~/.ssh/authorized_keys`. Once that is done you should be able to manually SSH into
the Pi without a password.

At this point, you can use dockrsync to start syncing files:

```
docker run \
    -v `pwd`:/sync \
    -v $HOME/.ssh:/root/.ssh \
    -e SYNC_USER=pi \
    -e SYNC_HOST=192.168.1.10 \
    -e SYNC_DIR="~/dev/pi-project" \
    -e RESYNC=10 \
    edaniszewski/dockrsync
```

Breaking down what each of the options above does:

<dl>
    <dt>-v `pwd`:/sync</dt>
    <dd>
        Mounts the current directory onto /sync of the container. This
        assumes that the data you want to sync between local and remote
        exists in the current directory. Anything found in /sync in the
        container will be synced to remote.
    </dd>
    <dt>-v $HOME/.ssh:/root/.ssh</dt>
    <dd>
        Mounts the contents of .ssh into the container's .ssh directory.
        This assumes that the key you are using resides in your ~/.ssh
        directory. 
    </dd>
    <dt>-e SYNC_USER=pi</dt>
    <dd>
        Set the SSH login user. In this example, that username is "pi".
    </dd>
    <dt>-e SYNC_HOST=192.168.1.10</dt>
    <dd>
        Set the remote host address for SSH.
    </dd>
    <dt>-e SYNC_DIR="~/dev/pi-project"</dt>
    <dd>
        Set the directory for which the data in /sync will be synced to
        on the remote machine. In this case, we are syncing the data to
        ~/dev/pi-project on the Raspberry Pi.
    </dd>
    <dt>-e RESYNC=10</dt>
    <dd>
        Set the sleep interval (in seconds) between rsync runs.
    </dd>
</dl>


To simplify the run command, you can also use an env file to specify the
environment parameters, e.g. if you had a file, `env`, 
```
SYNC_USER=pi
SYNC_HOST=192.168.1.10
SYNC_DIR=~/dev/pi-project
RESYNC=10
```

then dockrsync can be run with
```
docker run \
    -v `pwd`:/sync \
    -v $HOME/.ssh:/root/.ssh \
    --env-file env  \
    edaniszewski/dockrsync
```


## Troubleshooting / Issues
If you run into issues or have suggestions for dockrsync, feel free to open an issue. 
If you are reporting a bug, please provide as much context as possible.

## License
dockrsync is licensed under the MIT license - see the LICENCE file.
