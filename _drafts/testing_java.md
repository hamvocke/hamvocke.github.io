---
layout: post
title: Testing Java Microservices
tags: programming java testing
excerpt: If you want to jump aboard the Microservices hype-train, continuous delivery and test automation will be your best friends. Finding out which tests you need and how you can write them can be quite challenging. This post sums up my experience testing Microservices to allow fast development and frequent deployments.
comments: true
---

Microservices are all the rage. If you've attended a tech conference or read software engineering blogs lately, you'll probably either be amazed or fed up with all the success stories that companies love to share about their microservices journey. 

Somewhere beneath that hype are some true advantages to adopting a microservice architecture. And of course -- as with every architecture decision -- there will be trade-offs. I won't give you a lecture about the benefits and drawbacks of microservices or whether you should use them. Others have made [a way better job](https://www.martinfowler.com/microservices) at breaking this down for you than I ever could. Chance is, if you're reading this you somehow ended up with the decision to take a look into what's behind this magic buzzword.

## Key Concepts of Test Automation
Microservices go hand in hand with _continuous delivery_, a practice where you automatically ensure that your software can potentially be released to production at any time you like. Again, a lot of stuff has been written about this topic and if you want to find out how to get started, I can highly recommend to pick up [the Continuous Delivery book](https://www.amazon.com/gp/product/0321601912) that will teach you almost everything you need to know. With continuous delivery all changes (e.g. bugfixes and new features) to your software end up in front of your customers more frequently and more reliably than with traditional deployment approaches. Think about multiple production deployments a day instead of releasing once a quarter.

The key to releasing more frequently is **automation**. Automate all manual efforts diligently and you'll end up with a process that will be more reliable, reproducible and fast. One of the cornerstones of your automation effort is _test automation_. Automate your tests and you no longer have to mindlessly follow click protocols in order to find out if your latest release is ready for production. Automate your tests and you can change your codebase more easily. If you've ever tried doing a large-scale refactoring without a proper test suite I bet you know what a horrifying experience this can be. How would you know if you accidentally broke stuff along the way? Well, you click through all your manual test cases, that's how. But let's be honest: do you really enjoy that? How about making large-scale changes (or any changes for that matter) and knowing if you broke stuff within seconds while taking a nice sip of coffee? Sounds more enjoyable, if you ask me. 

Test automation is not exactly the new kid on the block. Yet I keep seeing teams that struggle implementing proper automated tests or still have to begin their test automation journey. Starting from zero, however, can be an intimidating tasks. What aspects of your codebase do you need to test? How should you structure and write your tests? What tools and libraries can make your life easier? 

Luckily test automation is a quite well-understood and mature topic. The developer community has put in a lot of effort to come up with concepts, tools and approaches that make automated testing more effective. I'll explain some of the key concepts that you should know about to come up with a healthy and effective test suite before diving into some implementation details that should help you getting started.


### The Test Pyramid
If you want to get serious about automated tests for your software there is one key concept that you should stick to: the **test pyramid**. Mike Cohn came up with this concept in his book [Succeeding with Agile](https://www.amazon.com/dp/0321579364/ref=cm_sw_r_cp_dp_T2_bbyqzbMSHAG05). It's a great visual metaphor telling you to think about different layers of testing and how much testing to do on each layer.

![Test Pyramid](/assets/img/uploads/testPyramid.png)

Mike Cohn's original testing pyramid consists of three layers that your test suite should consist of (bottom to top):
  
  1. Unit Tests
  2. Service Tests
  3. User Interface Tests

And while [some will argue](https://watirmelon.blog/2011/06/10/yet-another-software-testing-pyramid/) that either the naming or some conceptual aspects of Mike Cohn's test pyramid are not optimal, its essence can still serve as a good rule of thumb when it comes to establishing your own test suite. It's okay to come up with other names for your test layers. Virtually every team I've worked with came up with different names for _service tests_ and _UI tests_ and that's okay as long as you keep it consistent within your codebase and your entire team uses a consistent language.

Your key takeaway should be to implement layers of different size with different levels of integration in your test suite. Stick to the pyramid shape to come up with a healthy and maintainable test suite: Write _lots_ of small and fast _unit tests_. Write _some_ more coarse-grained _service tests_ that test that your service's business logic as a whole works well. Finally write _very few_ high level _user interface tests_ that automatically navigate your application's UI, enter data, click here and there and check that the outcome in your UI is as expected. Watch out that you don't end up with a [test ice-cream cone](https://watirmelon.blog/2012/01/31/introducing-the-software-testing-ice-cream-cone/) that will be a nightmare to maintain and take way too long to run.


### Unit Tests
Your unit tests will run very fast. On a decent machine you can expect to run thousands of unit tests within one minute. Test small pieces of your codebase in isolation and avoid hitting databases, the filesystem or firing HTTP queries. You can achieve this by _mocking_ or _stubbing_ dependencies of your _subject under test_. Once you got a hang of writing unit tests you will become more and more fluent in writing them. Stub out external collaborators, set up some input data, call your subject under test and check that the returned value is what you expected. Look into [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development) and let your unit tests guide your development; if applied correctly it can help you get into a great flow and come up with a good and maintainable design while automatically producing a comprehensive and fully automated test suite. 

A good unit test suite will be immensely helpful during development: You know that all the small units you tested are working correctly in isolation. Your small-scoped unit tests help you narrowing down and reproducing errors in your code. And they give you fast feedback while working with the codebase. Unfortunately unit tests alone won't get you very far. With unit tests alone you don't know whether your application as a whole works as intended. Did you do a proper job plumbing and wiring all those components, classes and modules together? Or is there something funky happening once you all your small units work as a bigger system?

### Service Tests

Your service tests will test the integration of larger parts of your system. The term "service tests" can be quite broad and virtually every team I've worked with interpreted and named this layer of tests differently. Essentially it all comes down to test the collaboration between different parts of your system: collaboration between larger components, integration points with the database, filesystem or network, or even the network and your application's API.

As broad and fuzzy as this description might be for now, we'll soon discover what this can look like in the context of a simple Java-based microservice.

These tests are on a higher level than your unit tests. Integrating slow parts like filesystem, databases and network they tend to be much slower than your unit tests. They also tend to be a little bit more difficult to write than small and isolated unit tests. Still, they have the advantage of giving you more confidence that your application works as intended than your unit tests alone.

**TODO: don't test what's already been tested on a lower layer**

### UI Tests
All applications have some sort of user interface. Typically we're talking about a web interface in the context of web applications but if you think about it, a REST API or command line client is as much of a user interface as a React application.

Testing through the user interface is the most end-to-end way you could test your application. You run your tests against the same interface real users would use. It's quite obvious that these tests give you the biggest confidence when you need to decide if your software is working or not. With [Selenium](http://docs.seleniumhq.org/) and the [WebDriver Protocol](https://www.w3.org/TR/webdriver/) there are some tools that allow you to automate your UI tests by automatically driving a (headless) browser, performing clicks, entering data and checking the state of your user interface.

UI tests come with their own kind of problems. They are notoriously flaky and often fail for unexpected and unforseeable reasons. They require a lot of maintenance and run pretty slowly. Yet they give you the highest confidence that your application is working correctly end to end. Due to their high maintenance cost you should aim to reduce the number of UI tests to the bare minimum. Think about the high-value interactions users will have with your application. Try to come up with user journeys that define the core value of your product and try to reflect the most important steps of these user journeys in your automated UI tests. If you're building an e-commerce site your most valuable customer journey could be a user searching for a product, putting it in the shopping basket and doing a checkout. Done. If this journey still works you should be pretty good to go. Everything else can and should be tested in lower levels of the test pyramid.


### Contract Tests
**TODO**
Test the contract (interface) between two services. Loose coupling, allow services to evolve on their own without breaking dependencies, foster communication between teams, decouple services and allow omitting flaky and hard to setup end to end testing.

### Avoid Test Duplication
When you write automated tests for your application be aware where you put them within your test pyramid. As a rule of thumb keep in mind that stuff you test on lower levels doesn't need to be tested on higher levels of the pyramid again. If you can check all sorts of edge-cases and invalid input combinations on unit level do so. There's no need to check all these cases again on your service or UI level (though you technically can, of course). Do yourself a favor and avoid duplicating your tests throughout the pyramid and try to put your tests as low as possible within the testing pyramid to come up with a fast, maintainable and reliable test suite.


## Implementing a Test Suite

### The Sample Application

### Unit Tests

### Integration Tests

### CDC Tests

## Further reading

**TODO: more literature about testing, unit testing etc. (Meszaros?, Writing OO Software guided by tests)**
