---
title: Choosing a CD tool
---

Fork my repo and run it through a CD tool of your choice. Currently works with A, B and C.

**TODO**: 
    * Provide links for hosted instances
    * add instructions to github repo
    * provide basic config for popular CD tools
    * explain pipeline visually.

## The pipeline explained

    Test -> Build Docker -> Push to Docker Hub -> Deploy Staging -> Functional Test -> Deploy Production

*Note*: this setup is not production ready. Running a single docker container on one of your servers probably won't get you very far (unless you're running a toy application or have very basic needs). This is a simplified setup that should make it easy for you to automatically deploy a service from your machine to a remote server. It can be a good starting point but it's likely that you'll want to extend the deployment process to fit to your needs. If you want to stick with docker deployments, _docker swarm_, _kubernetes_ or _mesos_ and _marathon_ might be something you'll want to look into. Otherwise PAAS platforms like _Heroku_ or self-hosted alternatives like _flynn_ or _dokku_ can be something worth looking into.

## Setting things up:

###  Launch a digitalocean droplet
* Pick a docker preinstalled version
* generate a fresh ssh-keypair using ssh-keygen, our pipeline will use this one to deploy software
* provision your new droplet with that ssh-key and your personal one


## Running locally
### Configuration
Using the `go` script you can test-drive the entire pipeline locally. Using `go help` will tell you what the script can do. The `go` script will read configuration from the `go.yml` file in the project root. This file is supposed to be checked into version control. In the YAML file you can see some placeholders in the format `${SOME_VALUE}`. These placeholders exist to avoid storing secrets in your `go.yml` file. Instead, the `go` script tries to read these placeholder values from your system's environment variables. If no environment variable with the corresponding name is set, the script will fail.  

You don't want to store secrets in version control. Even if it's a private repository, avoid the temptation. This way you make sure that you never start with bad habits and avoid the possibility to screw it up from the beginning. Checking in secrets happens way faster than you think and it happens to the best of us. Avoiding the possibility all together by prohibiting secrets in your config files will sooner or later cover your ass. The best approach is to treat all your repositories like they're open sourced on Github/Gitlab/Bitbucket or whatever flavor of VCS hosting provider you prefer. You wouldn't want the bad guys out there to know your secret API keys or passwords so it's best to separate them from the configuration you check in. The [12 Factor App](https://12factor.net/config) guidelines will give you similar advice.

**TODO**: describe how to add environment variables (using `.env` files, mention autoenv)

Of course its up to you to store all your configuration, including secrets, in your `go.yml` file. If that's really what you want to do, I can't stop you. But remember my words when you accidentally publish your AWS credentials to the open world and people start spinning up instances to mine bitcoins on your bill.

Once you've configured your repository by changing the values in you `go.yml` file and providing corresponding environment variables, you're ready to go:

1. `go setup`: Setup your environment, install dependencies and make sure you're able to run subsequent steps
2. `go test`: Run Unit and Integration Tests
3. `go build`: Build a Docker container
4. `go push`: Push the Docker container to the Docker registry
4. `go deploy staging`: Deploy the application to the _staging_ environment
5. `go functionalTest staging`: Run Functional Tests against the staging environment
6. `go deploy production`: Deploy the application to the _production_ environment

