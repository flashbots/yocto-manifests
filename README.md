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
$ sudo apt install gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev xterm python3-subunit mesa-common-dev zstd liblz4-tool chrpath diffstat lz4
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
$ mkdir -p yocto/<release_version>
$ cd yocto/<release_version>
```

* Clone the Yocto meta layer source using yocto manifest as show below.
```
$ repo init -u https://github.com/Xilinx/yocto-manifests.git -b <release_version>
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
## TODOs
- [ ] create a TDX branch in the yocto-scripts to update the setup files accordingly
- [ ] create a TDX branch in yocto-manifest that include the confidential VM layers
- [ ] automate the configuration of local.conf and bblayer.conf in a separate script
- [ ] automate the build process that does all the necessary steps based on the provided target (e.g. TDX)
- [ ] add scripts that generate measurements of the built VMs


## Staying Up to Date

To pick up the latest changes for all source repositories, run:
```
$ repo sync
```
