Builds the image using procs/poky image.
There are still some issues with reth and rbuilder builds, causing artifacts and host c compiler to be used. So long as we haven't resolved them, let's create common ground using this docker build setup.

```
sudo docker build . -t tdx-poky
sudo docker run --rm -it -v ~/build:/build -v $(readlink -f $SSH_AUTH_SOCK):/ssh-agent -e SSH_AUTH_SOCK=/ssh-agent tdx-poky build
```
