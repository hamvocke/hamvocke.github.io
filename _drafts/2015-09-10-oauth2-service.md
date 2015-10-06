---
layout: post
title: Building an OAuth2 Service to Secure Your REST APIs
tags: java security spring
excerpt: Building services that expose APIs to the public often requires some sort of security. OAuth2 is a standard protocol to deal with authorization that you can use to secure your applications. Read on to find out how to build a standalone service in Java that you can use to protect one or even multiple of your services.
---

Microservices are a big thing these days. 

## Our Sample System
Mobile App | Authorization Server (OAuth2 Service) | Resource Servers (Hello World Service, Cowsay Service)

## OAuth2 Quickly Explained
Before we dive into the details of the implementation it is crucial to understand how OAuth2 works and is supposed to be used. When I first implemented an OAuth2 I lacked this understanding and thus felt quite insecure along the way. "Did I forget something? Is this supposed to work like this?" were questions that accompanied me during the implementation. At the same time I didn't want to invest too much time reading Specifications and [RFCs](https://tools.ietf.org/html/rfc6749) to learn about stuff I didn't need eventually anyways. So, let's start with a basic explanation that's easy to digest.

TODO: Sequence Diagram: Client | Authorization Server | Resource Server

## Implementing our OAuth2 Service (Authorization Server)

## Implementing the Secured Services

## Starting Up

## Testing stuff
curl commands
