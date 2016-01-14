# taurus-test

[Docker](http://www.docker.com) image configuration for testing [Taurus](http://www.taurus-scada.org).

It is based on a [Debian](http://www.debian.org) stable and it provides the following infrastructure for installing and testing Taurus:

- xvfb, for headless GUI testing
- taurus dependencies and recommended packages (PyTango, PyQt, Qwt, guiqwt, spyder, ...)
- A Tango DB and TangoTest DS configured and running for testing taurus-tango
- A basic Epics system and a running SoftIoc for testing taurus-epics
 
The primary use of this Docker image is to use it in our [Continuous Integration workflow](https://travis-ci.org/cpascual/taurus). To run it in your own machine, do:

~~~~
docker pull cpascual/taurus-test
docker run -d --name=taurus-test -e HOSTNAME=taurus-test
~~~~

Then you can, e.g., log into it:

~~~~
docker exec -it taurus-test bash
~~~~

Note: this image does not contain taurus (since we want to test different versions of it). 
Either install it in your container following the [usual instructions](http://www.taurus-scada.org/en/stable/users/getting_started.html) or mount a volume from your host where it is already installed.

Thanks to [reszelaz](https://github.com/reszelaz) for providing the first version of this docker image
