---
layout: post
title: Testing Microservices -- Java & Spring Boot
tags: programming testing java
excerpt: Based on the previous post about testing microservices, I'll show how to implement different types of tests for a Spring Boot application in Java
comments: true
---

**TODO: link to other post**
In my previous post I gave a big round-trip over what it means to test microservices. We discussed the concept of the test pyramid and found out that you should write different types of automated tests to come up with a reliable and effective test suite. 

While the previous post was a little more abstract, explaining concepts and high-level approaches, this post will be more hands on. We will explore how we can implement the concepts we discussed before. The technology of choice for this post will be **Java** with **Spring Boot** as the application framework.

Java and Spring Boot is a combination I encounter frequently, especially in enterprise contexts. Java might not be the latest and greatest language. Still, it is a tried and trusted language with the JVM as a rock-solid and well-performing foundation. Yeah, I know, you probably know more than just one joke about how slow Java is. Fact is, we're not in the age of sluggish Java applets anymore. Java and the JVM have matured and are a solid choice for modern and high-performing microservices. With the new features that arrived with Java 8 (like functional interfaces, lambdas and streams) you're able to write modern code that borrows some concepts from functional programming. 

Spring Boot has written its own success story in recent years. By bundling up different parts of the vast Spring ecosystem in an opinionated fashion it made getting started with Spring more accessible. Banging out microservices using the combination of Java and Spring Boot has become increasingly easy which made this stack the stack of choice for experienced Java teams in a lot of companies).

This post will show you tools and libraries that help you implement the different types of tests we discussed in the previous post. Some of these can be used independently of Spring Boot. As long as you're using Java you can use these libraries in your codebase -- regardless of the application framework you're using. One of the things I like most about Spring Boot is that it bundles some clever testing mechanisms that support you in writing maintainable and readable tests for your application. So even if you're not using Spring Boot for your application this post might give you some insights.

## Tools and Libraries We'll Look at

  * **JUnit** as our test runner
  * **Mockito** for mocking dependencies
  * **Wiremock** for stubbing out third-party services
  * **MockMVC** for writing HTTP integration tests (this one's Spring specific)
  * **Pact** for writing CDC tests

## Implementing a Test Suite
I've provided a [sample application](https://github.com/hamvocke/spring-testing) of a rather trivial microservice including a test suite with tests for the different layers of the test pyramid. The codebase contains more tests than I would consider necessary for an application of this size. Some tests on different levels overlap quite extensively. This actively contradicts my hint that you should avoid test duplication throughout your test pyramid. I decided to duplicate tests throughout the test pyramid for demonstration purposes. Please keep in mind that this is not what you want for your real-world application. Duplicated tests are smelly and will be more annoying then helpful in the long run.

## The Sample Application
The sample application is rather simple but still shows some typical traits of a typical microservice. It provides a REST interface, talks to a database and fetches information from a third-party REST service. It's implemented in [Spring Boot ](https://projects.spring.io/spring-boot/) and should be understandable even if you've never worked with Spring Boot before.

Make sure to check out the [sample application](https://github.com/hamvocke/spring-testing) on github. The readme should contain all instructions you need to run the application and all automated tests on your machine. **TODO: make sure readme is complete**

### High-level structure
![sample application structure](/assets/img/uploads/testService.png)


### Internal structure
![sample application architecture](/assets/img/uploads/testArchitecture.png)


## Unit Tests

## Integration Tests

## CDC Tests

**TODO**
