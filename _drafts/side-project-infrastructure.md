---
layout: post
title: Infrastructure for Your Side Projects - A Guide for Cheapskates with High Standards
tags: draft
excerpt: If you fiddle around with some side projects for fun and fame the most exciting part is getting your stuff out there. This article shows you how I setup the infrastructure for my side projects.
comments: true
---

I have a love/hate relationship with running my own servers. Somewhere deep down I love being in charge, knowing that I have all the freedom to create something amazing - or destroy everything within seconds. SSH'ing into remote machines to experiment, troubleshoot, analyse, install and configure whatever I want while only using my terminal and an internet connection is as close as I'll ever get to impress the 12 year old me, or at least that's what I like to imagine. At the same time I often think I'd be much better off just using any off the shelf PaaS hosting solution and focus on what I really want to accomplish. But where's the fun?

In the past, I've gone back and forth between running my own cheap servers to host side projects (including this website) and using services like GitHub Pages, Heroku or Netlify and move on with my life. Most recently, my thoughts wandered again and I thought it would be reasonable to spend an unhealthy amount of time to setup my own infrastructure again. Why, you ask?

  1. Why not?
  2. Learning about building and running your own infrastructure can be fun
  2. I'm too cheap to pay for Heroku's paid plans (even though I like their platform)
  3. GitHub Pages and Netlify are great for hosting static websites but that's about it
  4. Hosting my own infrastructure gives me more flexibility
  5. Self-hosting allows me to be more privacy-conscious by not leaking my users' data to third parties

Driven by these reasons I built a basic infrastructure that I could use to host my side projects. In this post I'll show you how you can do the same.

## Cheap and Maintainable
Building and running my own infrastructure comes with two requirements. 

1. It should be **cheap**. _"Don't-even-argue"_-cheap. _"Less-than-my-Spotify-subscription"_-cheap, that's for sure. Anything more expensive and I could just as well go back to some PaaS provider's cheapest plan and be done with it.
2. It should be **easy to maintain**. If shit hits the fan, I want to be able to destroy and rebuild the whole shebang within minutes. Even at 3 a.m. (as if I didn't have anything better to do). 

The solution to requirement #1 is to cram as much stuff into one box as I can. [Clown Computing](https://www.urbandictionary.com/define.php?term=clown%20computing) is where it's at! If your servers are bored, you're wasting your money. Getting a small VPS (Virtual Private Server) at a hosting company you trust is all you need. Cloud providers offer cheap options that you can use to get started for around $5/month. That's the price point we're looking for. 

Picking a cloud provider (Google, Azure, AWS, DigitalOcean, you name it) helps us with requirement #2 as they allow us to set up and destroy our infrastructure as we like. If we want to be able to rebuild things within minutes without batting an eye, automation becomes crucial. We need an automated way to setup our servers and to install and configure the software we need. I certainly don't want to memorize arcane Unix commands that I need to invoke over an SSH connection in the correct order when all I want is to get my application up again.

Remember, we don't want to deploy an enterprise-level, highly resilient, multi-team microservices architecture. Forget about [phoenix servers](https://martinfowler.com/bliki/PhoenixServer.html), forget the hype around Kubernetes, forget horizontal scalability. This is not Netflix. This is our shitty little web application that we want to get out there. We're in the fortunate position to cut some corners. Let's roll!

## Tools We Use
We're going to use these tools to automate as much as we can:

  * [Terraform](https://www.terraform.io/) to set up servers, domains and deal with DNS
  * [Ansible](https://www.ansible.com/) to install software and configure our servers
  * [Vagrant](https://www.vagrantup.com/) so that we can run our Ansible scripts locally
  * [Serverspec](https://serverspec.org/) to test that our Ansible scripts set things up correctly

The setup I explain uses [DigitalOcean](https://www.digitalocean.com/) as our cloud provider. If you'd rather like to use another one, you'll need to rewrite the terraform configuration accordingly. The rest should work regardless of your choice of a provider.

## What We Build
* Staging and Prod Environment
* Staging will be deleted after run (is cheaper)
* Nginx, Let's Encrypt for static website hosting
* Dokku
* Monitoring with goaccess

## Source Code
I've setup a repository at GitHub where you can find examples for our terraform configuration and ansible scripts as well as the testing infrastructure. You can easily get started by forking that repo and modifying everything according to what you need.

**TODO** - create and link repo

## Steps to Production
I like to automate things as good as I can and use Continuous Delivery to to get the software I write into production in a reliable and repeatable way. As we're going to automate everything anyways, we can make use of Continuous Delivery to take over as soon as changes to our infrastructure leave our computer with a `git push`.

Here's what our deployment pipeline looks like:

```
vagrant test -> git push -> terraform staging -> ansible staging -> terraform prod -> ansible prod -> terraform destroy staging

```

## File Structure
```
.
├── group_vars
│   └── local
│       └── vars.yml
├── infrastructure
│   ├── ham-codes
│   │   ├── prod
│   │   │   ├── main.tf
│   │   │   ├── terraform.tfstate
│   │   │   └── terraform.tfstate.backup
│   │   ├── stack
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── staging
│   │       ├── main.tf
│   │       ├── terraform.tfstate
│   │       └── terraform.tfstate.backup
│   └── hamvocke-com
│       ├── main.tf
│       └── terraform.tfstate
├── roles
│   ├── blog
│   │   ├── files
│   │   │   ├── hamvocke
│   │   │   └── post-update
│   │   └── tasks
│   │       └── main.yml
│   ├── common
│   │   ├── files
│   │   │   ├── public_keys
│   │   │   │   ├── ham
│   │   │   │   ├── work
│   │   │   │   └── yubikey
│   │   │   └── ssh
│   │   │       ├── id_rsa
│   │   │       └── id_rsa.pub
│   │   └── tasks
│   │       └── main.yml
│   ├── dokku
│   │   └── tasks
│   │       └── main.yml
│   ├── goaccess
│   │   ├── files
│   │   │   └── goaccess
│   │   └── tasks
│   │       └── main.yml
│   ├── letsencrypt
│   │   └── tasks
│   │       └── main.yml
│   ├── monitoring
│   │   ├── files
│   │   │   ├── generate_certificate.sh
│   │   │   ├── influxdb.conf
│   │   │   └── monitoring
│   │   ├── tasks
│   │   │   └── main.yml
│   │   ├── templates
│   │   │   ├── chronograf.j2
│   │   │   └── telegraf.conf.j2
│   │   └── vars
│   │       └── main.yml
│   └── nginx
│       ├── files
│       │   └── nginx.conf
│       └── tasks
│           └── main.yml
├── test
│   ├── blog_spec.rb
│   ├── common_spec.rb
│   ├── docker_spec.rb
│   ├── dokku_spec.rb
│   ├── monitoring_spec.rb
│   └── spec_helper.rb
├── Gemfile
├── Gemfile.lock
├── Makefile
├── README.md
├── Vagrantfile
├── blog.yml
├── devbox.yml
├── go
├── go.py
├── hosts
├── local.yml
├── provision.sh
└── servers.sh
```

## Testing Our Infrastructure
We're professionals. Before we get stuff into production, we want to make sure that it works. Testing our provisioning scripts locally allows us to have fast feedback and experiment without causing any harm. We want that.

Unfortunately, we can't test our terraform setup locally. Looking at the output `terraform plan` gives us is not going to cut it. So instead of applying changes to our terraform configuration to production directly, we give it a trial run to see if it works. If it does, we're good to apply it to production.

### Running Ansible Locally
To run our Ansible scripts locally, we spin up a local virtual machine with the help of Vagrant.

{% highlight ruby %}
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "forwarded_port", guest: 80,   host: 10080 # nginx
  config.vm.network "forwarded_port", guest: 8080, host: 18080
  config.vm.network "forwarded_port", guest: 8086, host: 18086 # influxDB HTTP
  config.vm.network "forwarded_port", guest: 8088, host: 18088 # influxDB RPC
  config.vm.network "forwarded_port", guest: 8888, host: 18888 # chronograf

  config.vm.provision "ansible_local" do |ansible|
    ansible.limit = 'all'
    ansible.inventory_path = 'hosts'
    ansible.playbook = 'local.yml'
    ansible.vault_password_file = ".vault-pass"
  end

  config.vm.provision :serverspec do |spec|
    # pattern for specfiles to search
{% endhighlight %}
