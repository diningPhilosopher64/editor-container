
## editor-container 

### What is this ?
Heard of devContainers in vscode ? This is exactly the same idea for editors. I use lunarvim as my editor of choice, you'll need to make appropriate changes for your distribution of neovim.

### Why ?
VSCode has become unusable for me in the recent days. It used to work flawlessly on my 7 year old machine, but now
it just struggles to even paste text and now this electron app has become a memory guzzler. 16 gigs of RAM is not
sufficient for me with VSCode + browser + other dev servers running.

This repo is a recipe. You will have to make changes according to your dev setup.

Getting up and running with your editor should take less than 10 minutes, with majority of it going into building the
container.

#### How to use ?
* This container needs to be built for every machine that you use for development. If you'd like, you can optimize this even further to go around this limitation.
* This is for maintaining common cache for all the plugins for lunarvim. 
    * When you open a python project, python plugins will be installed on the container. If you open another container, for the same project, the plugins will be installed again. This is because the plugins are cached on the container. By smartly bind mounting, we can get around this limitation by installing the plugins once and caching them on the host.



## Getting started

* Build the container:
```bash
$ docker build -t editor:latest \
  --build-arg HOST_UID=$(id -u) \
  --build-arg HOST_GID=$(id -g) \
  --build-arg HOST_USER=$(id -un) \
  --build-arg HOST_GROUP=$(id -gn) .
```

* To launch the container :

* First time setup
    * First launch the container in current folder:
    ```bash
    $ docker run -it --rm -v $(pwd):/workspace --user $(id -u):$(id -g) editor:latest
    ```
    * When you run the container and launch lunarvim for the first time and open a python file,
    it will fetch pyright, nvim-treesitter etc. All these will be cached in the container in the location:
    ~/.local/share/lunvarim , ~/.local/share/lvim , ~/.config/lvim

    * Now, you need to copy over the contents of these folders into a temporary location on the host

    * Then, you need to copy over the contents on to your host system in the same locations.


Reason for this is when we bind mount as there would not be no folders in the above location on the host, host's file system is given priority and the container's files in the same location are ignored. 

* After the initial setup, you need to bind mount config and .local directories so that the plugins are not fetched everytime you launch a container.

* Now, you need to update the config.lua on your host system to run init.lua of your custom config. I have my custom config sitting at `/home/sourabh/dotfiles/lvim`
    * For this, edit the config.lua in this folder accordingly and paste it in `~/.config/lvim/`
    * If you're looking for some inspiration for custom config, you can check out mine [here](https://github.com/diningPhilosopher64/dotfiles)
 


* For subsequent launches, you can use the following run command:
```bash
$ docker run -it --rm -v $(pwd):/workspace \
    -v $HOME/.local/share/lunarvim:/home/$(id -un)/.local/share/lunarvim \
    -v $HOME/.local/share/lvim:/home/$(id -un)/.local/share/lvim  \
    -v $HOME/.config/lvim:/home/$(id -un)/.config/lvim \
    -v $HOME/dotfiles/lvim/:$HOME/dotfiles/lvim \
    --user $(id -u):$(id -g)   editor:latest

```

* This way, as and when we are installing new plugins in the container, they get cached on the host and thereby not requiring lvim to fetch them everytime a container is launched.
