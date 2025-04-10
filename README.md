* Build the container:
```bash
$ docker build -t neovim-dev:latest .
```


* To launch the container in the current directory:
```bash
$ docker run -it --rm -v $(pwd):/workspace --user $(id -u):$(id -g) neovim-dev:latest
```