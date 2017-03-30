---
layout: post
title: Getting Started with Continuous Delivery
tags: programming
excerpt: Continuous Delivery is an effective practice to deliver software reliably and hassle-free. Getting started is now easier than ever and I'll show you how using a simple Python application. 
comments: true
---

DRAFT

title idea: Kickstart to Continuous Delivery

Diving into continuous delivery: hassle free deployments, no more getting up at 3am, no more manual clicking and intervention, all that stuff

Tools
  * snap-ci
  * travis-ci
  * gitlab
  * concourse
  * drone
  * GoCD
  * jenkins
  * circle ci
  * ...

Hosted vs cloud-based

Host own instances to showcase what they look like

Jenkins: gets a lot of hate (and is not my favourite either) but still you have to value it for what it is: an open source tool that's quite easy to set up. And it's way better than nothing at all.

Circle: inferring information from your project structure, tries to find out on its own what to do (install dependencies, build, run tests) but that doesn't always work reliably. In any case you can provide a circle.yml to precisely configure what to do

Concourse: self hosted, all jobs (tasks?) run in their own container. Nice way to debug by attaching to the container after the pipeline run. 

Why having a "go" script is beneficial ([link to blog](https://www.thoughtworks.com/insights/blog/praise-go-script-part-i))

Deploying vs Releasing / Feature toggles
