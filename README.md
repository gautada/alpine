# alpine-container
A very simple container that uses Alpine Linux.  This is the default base for most containers in this library.  Also this is used as the default test for the pod man-container. 

## Setup and Configuration

This is the core/default starting point for all of my containers.  As such there are several configurations that are used to get everything just the way I like it.

### Timezone

Set the timezone to US-EASTERN

### Aliases

In general there needs to be a consistent set of aliases across all containers.  An 'aliases,sh file is used to make the process easier and is placed in the ```/etc/profile.d``` folder.

#### Version

This alias provides the active version number for the container.  By default this is the alpine version running.  But this should be overloaded by downstream containers to be the active version of whatever the software is that we are running.


https://linuxhandbook.com/linux-alias-command/
