---
layout: post
title: Testing Microservices -- Java Edition
tags: programming testing java
excerpt: If you want to jump aboard the Microservices hype-train, continuous delivery and test automation will be your best friends. Finding out which tests you need and how you can write them can be quite challenging. This post sums up my experience testing Microservices to allow fast development and frequent deployments.
comments: true
---


## Implementing a Test Suite
Let's see how we can implement a test suite with tests for the different layers of the test pyramid. I've created a [sample application](https://github.com/hamvocke/spring-testing) with tests on the different layers of the testing pyramid. The codebase contains more tests than necessary and actively contradicts my hint that you should avoid test duplication. For demonstration purposes I decided to duplicate some tests along the test pyramid but please keep in mind that you wouldn't need to do this in your codebase.

### The Sample Application
The sample application is rather simple but still shows some typical traits of a typical microservice. It provides a REST interface, talks to a database and fetches information from a third-party REST service. It's implemented in [Spring Boot ](https://projects.spring.io/spring-boot/) and should be understandable even if you've never worked with Spring Boot before.

Make sure to check out the [sample application](https://github.com/hamvocke/spring-testing) on github. The readme should contain all instructions you need to run the application and all automated tests on your machine. **TODO: make sure readme is complete**

#### High-level structure
![sample application structure](/assets/img/uploads/testService.png)


#### Internal structure
![sample application architecture](/assets/img/uploads/testArchitecture.png)


### Unit Tests

### Integration Tests

### CDC Tests

**TODO**
* rewrite excerpt
