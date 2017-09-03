---
layout: post
title: Testing Microservices — Java & Spring Boot
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
  * [**JUnit**](http://junit.org) as our test runner
  * [**Mockito**](http://site.mockito.org/) for mocking dependencies
  * [**Wiremock**](http://wiremock.org/) for stubbing out third-party services
  * [**MockMVC**](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-testing.html#boot-features-testing-spring-boot-applications-testing-autoconfigured-mvc-tests) for writing HTTP integration tests (this one's Spring specific)
  * [**Selenium**](http://docs.seleniumhq.org/) for writing UI-driven end-to-end tests
  * [**Pact**](https://docs.pact.io/) for writing CDC tests

## Implementing a Test Suite
I've provided a [sample application](https://github.com/hamvocke/spring-testing) of a rather trivial microservice including a test suite with tests for the different layers of the test pyramid. The codebase contains more tests than I would consider necessary for an application of this size. Some tests on different levels overlap quite extensively. This actively contradicts my hint that you should avoid test duplication throughout your test pyramid. I decided to duplicate tests throughout the test pyramid for demonstration purposes. Please keep in mind that this is not what you want for your real-world application. Duplicated tests are smelly and will be more annoying then helpful in the long run.

## The Sample Application
The sample application is rather simple but still shows some typical traits of a typical microservice. It provides a REST interface to the outside world, talks to a database and fetches information from a third-party REST service. It's implemented in [Spring Boot ](https://projects.spring.io/spring-boot/) and should be understandable even if you've never worked with Spring Boot before.

Make sure to check out the [sample application](https://github.com/hamvocke/spring-testing) on github. The readme should contain all instructions you need to run the application and all automated tests on your machine.

### Functionality
The application's functionality is simple. It provides a REST interface with three endpoints:

  1. `GET /hello`: Returns _"Hello World"_. Always.
  2. `GET /hello/{lastname}`: Looks up the person with the provided last name. If the person is known, returns _"Hello {Firstname} {Lastname}"_.
  3. `GET /weather`: Returns the current weather conditions for _Hamburg, Germany_.

### High-level Structure
On a high-level the system has the following structure:

![sample application structure](/assets/img/uploads/testService.png)
_the high level structure of our microservice system_

Our Spring microservice provides a REST interface that can be called via HTTP. In some cases the service will fetch information from a database. In other cases the service will call an external [weather API](https://darksky.net) via HTTP to fetch current weather conditions.

### Internal Architecture
Internally, the Spring Service has a pretty typical architecture:

![sample application architecture](/assets/img/uploads/testArchitecture.png)
_the internal structure of our microservice_

  * `Controller` classes provide _REST_ endpoints and deal with _HTTP_ requests and responses
  * `Repository` classes interface with the _database_ and take care of writing and reading data to/from persistent storage
  * `Client` classes talk to other APIs, in our case it fetches _JSON_ via _HTTPS_ from the darksky.net weather API
  * `Domain` classes capture our [domain model](https://en.wikipedia.org/wiki/Domain_model) including the domain logic (which, to be fair, is quite trivial in our case). 

Experienced Spring developers might notice that a frequently used layer is missing here: Inspired by [Domain-Driven Design](https://en.wikipedia.org/wiki/Domain-driven_design) a lot of devs build a _service_ layer consisting of _service_ classes (which is its own stereotype in Spring). I decided not to include a service layer in this application. One reason is that our application is simple enough, a service layer would have been an unnecessary level of indirection. The other one is that I think people overdo it with service layers. I often encounter codebases where the entire business logic is captured within service classes. The domain model becomes merely a layer for data, not for behaviour (Martin Fowler calls this an [Aenemic Domain Model](https://en.wikipedia.org/wiki/Anemic_domain_model). For every non-trivial application this wastes a lot of potential to keep your code well-structured and testable and does not fully utilize the power of object orientation.

Our repositories are straightforward and provide simple <abbr title="Create Read Update Delete">CRUD</abbr> functionality. To keep it simple I used [Spring Data](http://projects.spring.io/spring-data/). Spring Data brings a simple and generic CRUD repository implementation that we can use instead of rolling our own. It also takes care of spinning up a in-memory database for our tests instead of using a real PostgreSQL database as it would in production.

Take a look at the codebase and make yourself familiar with the internal structure. It will be useful for our next stop: Testing the application!

## Unit Tests

## Integration Tests

## CDC Tests

**TODO**
  * provide readme.md for repo
  * link to previous article
