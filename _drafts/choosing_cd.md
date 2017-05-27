---
title: Choosing a CD tool
---

Fork my repo and run it through a CD tool of your choice. Currently works with A, B and C.

**TODO**: 
    * Provide links for hosted instances
    * add instructions to github repo
    * provide basic config for popular CD tools
    * explain pipeline visually.

## Setting things up:

###  Launch a digitalocean droplet
* Pick a docker preinstalled version
* generate a fresh ssh-keypair using ssh-keygen, our pipeline will use this one to deploy software
* provision your new droplet with that ssh-key and your personal one

## The pipeline explained

    Test -> Build Docker -> Push to Docker Hub -> Deploy Staging -> Functional Test -> Deploy Production

*Note*: this setup is not production ready. Running a single docker container on one of your servers probably won't get you very far (unless you're running a toy application or have very basic needs). This is a simplified setup that should make it easy for you to automatically deploy a service from your machine to a remote server. It can be a good starting point but it's likely that you'll want to extend the deployment process to fit to your needs. If you want to stick with docker deployments, _docker swarm_, _kubernetes_ or _mesos_ and _marathon_ might be something you'll want to look into. Otherwise PAAS platforms like _Heroku_ or self-hosted alternatives like _flynn_ or _dokku_ can be something worth looking into.
