# Introduction

This is a very basic install of Infinispan (not technically JBoss Data Grid).  The goal is to update this to be the full JDG installation and parameterize this.  This is very much a work in progress, but should suit needs for initial testing.

# Hardware Requirements

## Memory

TBD

# How to get the image

You can either download the image from a docker registry or build it yourself.

## Building the Image
* run `build.sh`

These builds are not performed by the **Docker Trusted Build** service because it contains JBoss proprietary code, but this method can be used if using a [Private Docker Registry](https://docs.docker.com/registry/deploying/).

```bash
docker pull jlgrock/jboss.data-grid:$VERSION
```

# Examples of Running a Container

Starting a Standalone EAP instance
```bash
docker run -it --rm -P jlgrock/data-grid:6.4.0
```

