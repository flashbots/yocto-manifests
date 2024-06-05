# yocto-manifests
This repository provides Repo manifests to setup the Yocto build system for reproducible TEE builds.

[The Yocto Project](https://docs.yoctoproject.org/singleindex.html#) allows the creation of custom linux distributions for
embedded systems, including AMD based systems.  It is a collection of git
repositories known as *layers* each of which provides *recipes* to build
software packages as well as configuration information.

[Repo](https://gerrit.googlesource.com/git-repo/+/HEAD/README.md) is a tool that enables the management of many git repositories given a
single *manifest* file.  Tell repo to fetch a manifest from this repository and
it will fetch the git repositories specified in the manifest and, by doing so,
setup a Yocto Project build environment for you!

## Manifest Files

* **default.xml** - External releasable components. Used for release builds.

## Getting Started

1. See the [Preparing Build Host](https://docs.yoctoproject.org/singleindex.html#preparing-the-build-host)
   documentation to install essential host packages on your build host. The
   following command installs the host packages based on an Ubuntu distribution.
```
$ sudo apt install gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev xterm python3-subunit mesa-common-dev zstd liblz4-tool chrpath diffstat lz4 mtools
$ sudo locale-gen en_US.UTF-8
```

2.  Install Repo tool.

If on Debian/Ubuntu, then run:
```
sudo apt-get install repo
```

Otherwise, follow theese steps:    
*  Download the Repo script.
```
$ curl https://storage.googleapis.com/git-repo-downloads/repo > repo
```

* Make it executable.
```
$ chmod a+x repo
```

* Move it on to your system path.
```
$ sudo mv repo /usr/local/bin/
```

If it is correctly installed, you should see a Usage message when invoked
with the help flag.
```
$ repo --help
```
3. Initialize a Repo client.

* Create an empty directory to hold your working files.
```
$ mkdir -p yocto/tdx
$ cd yocto/tdx
```

* Clone the Yocto meta layer source using yocto manifest as show below.
```
$ repo init -u https://github.com/flashbots/yocto-manifests.git -b tdx
```
A successful initialization will end with a message stating that Repo is
initialized in your working directory. Your directory should now contain a
.repo directory where repo control files such as the manifest are stored but
you should not need to touch this directory.

To learn more about repo, look at https://source.android.com/setup/develop/repo

4. Fetch all the repositories.
```
$ repo sync
```

5. Start a branch with for development starting from the revision specified in
   the manifest. This is an optional step.
```
$ repo start <branch_name> --all
```

6. Setup the Yocto OE Init scripts by sourcing `setup` script.
```
$ source setup
```

7. Build the image by using the provided `Makefile`.
```
$ make build
```

8. Generate the measurements values after building the image. They will be located in measurements directory
```
$ make gen-measurements
```
> **Note:** to generate the measurements, you need to make sure that you have `python3`, `libssl-dev` and the `signify` module installed.
>
>$ sudo apt-get install python3 libssl-dev 
>
>$ ln -s /usr/bin/python3 /usr/bin/python 
>
>$ pip install signify

## Staying Up to Date

To pick up the latest changes for all source repositories, run:
```
$ repo sync
```
## Docker build env
There is also [poky-container](https://github.com/crops/poky-container/) as an alternative docker build environment to build your yocto projects with it.