* Build the container:
```bash
$ docker build -t neovim-dev:latest .
$ docker build -t neovim-dev:latest --build-arg HOST_UID=$(id -u) --build-arg HOST_GID=$(id -g) .
```

* To launch the container :

* First time setup
    * First launch the container in current folder:
    ```bash
    $ docker run -it --rm -v $(pwd):/workspace --user $(id -u):$(id -g) neovim-dev:latest
    ```
    * When you run the container and launch lunarvim for the first time and open a, say python file,
    it will fetch pyright, nvim-treesitter etc. All these will be cached in the container in the location:
    ~/.local/share/lunvarim , ~/.local/share/lvim , ~/.config/lvim

    * Now, you need to copy over the contents of these folders into a temporary location on the host

    * Then, you need to copy over the contents on to your host system in the same locations.


Reason for this is when we bind mount as there would not be no folders in the above location on the host, host's file system is given priority and the container's files in the same location are ignored. 

* After the initial setup, you need to bind mount config and .local directories so that the plugins are not fetched everytime you launch a container.

* Now, you need to update the config.lua on your host system to run init.lua of your custom config. I have my custom config sitting at `/home/sourabh/dotfiles/lvim`
    * For this, edit the config.lua in this folder accordingly and paste it in `~/.config/lvim/`
    * 
 


* For subsequent launches, you can use the following run command:
```bash
$ docker run -it --rm -v $(pwd):/workspace \
    -v $HOME/.local/share/lunarvim:/home/$(id -un)/.local/share/lunarvim \
    -v $HOME/.local/share/lvim:/home/$(id -un)/.local/share/lvim  \
    -v $HOME/.config/lvim:/home/$(id -un)/.config/lvim \
    -v $HOME/dotfiles/lvim/:$HOME/dotfiles/lvim \
    --user $(id -u):$(id -g)   neovim-dev:latest

```

* This way, as and when we are installing new plugins in the container, they get cached on the host and thereby not requiring lvim to fetch them everytime a container is launched.
