---
layout: post
title: Testing Microservices
tags: programming java testing
excerpt: If you want to jump aboard the Microservices hype-train, continuous delivery and test automation will be your best friends. Finding out which tests you need and how you can write them can be quite challenging. This post sums up my experience testing Microservices to allow fast development and frequent deployments.
comments: true
---

Microservices are all the rage. If you've attended any tech conference or read software engineering blogs lately, you'll probably either be amazed or fed up with all the success stories that companies love to share about their microservices journey.

Somewhere beneath that hype are some true advantages to adopting a microservice architecture. And of course -- as with every architecture decision -- there will be trade-offs. I won't give you a lecture about the benefits and drawbacks of microservices or whether you should use them. Others have done [a way better job](https://www.martinfowler.com/microservices) at breaking this down for you than I ever could. Chance is, if you're reading this article you somehow ended up with the decision to take a look into what's behind this magic buzzword.

**TODO: teaser image?**

## <abbr title="too long; didn't read">tl;dr</abbr>
Don't know if this article is for you? These are the key takeaways:

  * Automate your tests (surprise!)
  * Remember the [test pyramid](https://martinfowler.com/bliki/TestPyramid.html) _(forget about the original names of the layers though)_
  * Write tests with different granularity
  * Use unit test (_solitary_ and _sociable_) to test the insides of your application
  * Use integration tests to test all places where your application serializes/deserializes data (e.g. public APIs, accessing databases and the filesystem, calling other microservices, reading from/writing to queues)
  * Test collaboration between services with contract tests (CDC).

**TODO update tl;dr?**

## Microservices Need Automated Testing

Microservices go hand in hand with **continuous delivery**, a practice where you automatically ensure that your software can potentially be released to production at any time you like. You use a **build pipeline** to automatically test and deploy your application to all of your testing and production environments. Since you'll be juggling with quite some services once you advance on your microservices adventure, deploying these services in a fast and reproducible way soon becomes a necessity. Deploying dozens or even hundreds of services using tedious manual processes will simply be too overwhelming for your team to be a reasonable approach.

Most -- if not all -- success stories around microservices are told by teams who employed continuous delivery or **continuous deployment** (every change to your software that's proven to be releasable will be deployed to production). These teams make sure that all releasable changes quickly get in the hands of their customers. How do you proof that your latest change still results in releasable software? You test your software including the latest change thoroughly. Traditionally you'd do this manually by deploying your application to a test environment and then performing some black-box style testing e.g. by clicking through your user interface to see if anything's broken. It's obvious that testing all changes manually is time-consuming, repetitive and tedious. Repetitive is boring, boring leads to mistakes and makes you look for a different job quite soon. Luckily there's a remedy for repetitive tasks: **automation**. Ever since test automation became a thing (and it's been a thing for quite a while now) the software development community has come up with lots of concepts, tools and libraries that help you automating your tests. 

Automating your tests is one of the big game changers for your life as a software developer. Automate your tests and you no longer have to mindlessly follow click protocols in order to find out if your latest release is ready for production. Automate your tests and you can change your codebase more easily. If you've ever tried doing a large-scale refactoring without a proper test suite I bet you know what a horrifying experience this can be. How would you know if you accidentally broke stuff along the way? Well, you click through all your manual test cases, that's how. But let's be honest: do you really enjoy that? How about making large-scale changes (or any changes for that matter) and knowing if you broke stuff within seconds while taking a nice sip of coffee? Sounds more enjoyable, if you ask me. 

Test automation is key for a successful microservices architecture. It's essential for continuous delivery and continuous delivery is a good (maybe even essential) foundation for a microservices architecture. Therefore doing microservices without test automation will likely result in a desaster. On top of that you get all the other sweet sweet benefits of continuous delivery: hassle-free deployments, releasing software more frequently to your customers, experimentation and fast feedback, and a lot more. Again, a lot of stuff has been written about this topic and if you want to find out how to get started, I can highly recommend to pick up [the Continuous Delivery book](https://www.amazon.com/gp/product/0321601912) that will teach you almost everything you need to know.

Starting with test automation from zero can be intimidating. There probably will be a lot of questions on your mind. What aspects of your codebase do you need to test? How should you structure and write your tests? What tools and libraries can make your life easier? 

To test microservices there are some concepts, tools and libraries that have proven to be effective and help you come up with a healthy, reliable and fast test suite. This article will explain the most important concepts and approaches that you need to understand in order to test your microservices thoroughly. Picking the right tools and libraries often depends on your choice of programming language and its ecosystem. That's why I'll cover tools, libraries and implementation examples in my follow-up posts that will look at specific language ecosystems.. **TODO link to follow up posts**


## The Test Pyramid
If you want to get serious about automated tests for your software there is one key concept that you should keep in mind: the **test pyramid**. Mike Cohn came up with this concept in his book [Succeeding with Agile](https://www.amazon.com/dp/0321579364/ref=cm_sw_r_cp_dp_T2_bbyqzbMSHAG05). It's a great visual metaphor telling you to think about different layers of testing and how much testing to do on each layer.

![Test Pyramid](/assets/img/uploads/testPyramid.png)

Mike Cohn's original testing pyramid consists of three layers that your test suite should consist of (bottom to top):
  
  1. Unit Tests
  2. Service Tests
  3. User Interface Tests

And while [some will argue](https://watirmelon.blog/2011/06/10/yet-another-software-testing-pyramid/) that either the naming or some conceptual aspects of Mike Cohn's test pyramid are not optimal, its essence can still serve as a good rule of thumb when it comes to establishing your own test suite. It's okay to come up with other names for your test layers. Virtually every team I've worked with came up with different names for _service tests_ and _UI tests_ and that's okay as long as you keep it consistent within your codebase and your entire team uses a shared language.

Indeed, Cohn's pyramid can be misleading. His UI test layer, for example, suggests that UI tests have to be high-level tests. Considering the rise of single page application frameworks like _React_, _Angular_, _ember.js_, _vue.js_ and others it becomes obvious that testing your user interface can also be done on a unit level.

Your best bet is to remember two things from Cohn's original test pyramid:

  1. Write tests with different granularity
  2. The more high-level you get the fewer tests you should have on that level

Stick to the pyramid shape to come up with a healthy, fast and maintainable test suite: Write _lots_ of small and fast _unit tests_. Write _some_ more coarse-grained tests and _very few_ high level tests that test your application from end to end. 

Watch out that you don't end up with a [test ice-cream cone](https://watirmelon.blog/2012/01/31/introducing-the-software-testing-ice-cream-cone/) that will be a nightmare to maintain and takes way too long to run.




## Types of Tests
While the test pyramid suggests that you'll have three different types of tests (_unit tests_, _service tests_ and _UI tests_) I need to disappoint you. Your reality will look a little more diverse. To build an effective test suite you'll need some more buckets to sort your tests into. Lets keep cohn's test pyramid in mind for its good things (use layers with different granularity, make sure they're differently sized, avoid duplication throughout the layers). for the types of tests we need, let's find the categories that better reflect what we really need.

### Unit tests
Your unit tests will run very fast. On a decent machine you can expect to run thousands of unit tests within one minute. Test small pieces of your codebase in isolation and avoid hitting databases, the filesystem or firing HTTP queries. You can achieve this by _mocking_ or _stubbing_ dependencies of your _subject under test_. Once you got a hang of writing unit tests you will become more and more fluent in writing them. Stub out external collaborators, set up some input data, call your subject under test and check that the returned value is what you expected. Look into [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development) and let your unit tests guide your development; if applied correctly it can help you get into a great flow and come up with a good and maintainable design while automatically producing a comprehensive and fully automated test suite. 

A good unit test suite will be immensely helpful during development: You know that all the small units you tested are working correctly in isolation. Your small-scoped unit tests help you narrowing down and reproducing errors in your code. And they give you fast feedback while working with the codebase. Unfortunately unit tests alone won't get you very far. With unit tests alone you don't know whether your application as a whole works as intended. Did you do a proper job plumbing and wiring all those components, classes and modules together? Or is there something funky happening once you all your small units work as a bigger system?

### Integration Tests

Your _integration tests_ will test the integration of larger parts of your system. The term "service tests" can be quite broad and developers often come up with slightly different names and interpretations for these kinds of tests. Essentially it all comes down to test the collaboration between different parts of your system: collaboration between larger components, integration points with the database, filesystem or network, or even the network and your application's API.

As broad and fuzzy as this description might be for now, we'll soon discover what this can look like in the context of a simple Java-based microservice.

These tests are on a higher level than your unit tests. Integrating slow parts like filesystem, databases and network they tend to be much slower than your unit tests. They also tend to be a little bit more difficult to write than small and isolated unit tests. Still, they have the advantage of giving you more confidence that your application works as intended than your unit tests alone.

### UI Tests
**TODO introduce "e2e" test term**
All applications have some sort of user interface. Typically we're talking about a web interface in the context of web applications but if you think about it, a REST API or command line client is as much of a user interface as a React application.

Testing through the user interface is the most end-to-end way you could test your application. You run your tests against the same interface real users would use. It's quite obvious that these tests give you the biggest confidence when you need to decide if your software is working or not. With [Selenium](http://docs.seleniumhq.org/) and the [WebDriver Protocol](https://www.w3.org/TR/webdriver/) there are some tools that allow you to automate your UI tests by automatically driving a (headless) browser, performing clicks, entering data and checking the state of your user interface.

UI tests come with their own kind of problems. They are notoriously flaky and often fail for unexpected and unforseeable reasons. They require a lot of maintenance and run pretty slowly. Yet they give you the highest confidence that your application is working correctly end to end. Due to their high maintenance cost you should aim to reduce the number of UI tests to the bare minimum. Think about the high-value interactions users will have with your application. Try to come up with user journeys that define the core value of your product and try to reflect the most important steps of these user journeys in your automated UI tests. If you're building an e-commerce site your most valuable customer journey could be a user searching for a product, putting it in the shopping basket and doing a checkout. Done. If this journey still works you should be pretty good to go. Everything else can and should be tested in lower levels of the test pyramid.

**TODO: write about UI-checking tests, lineup, csscritic and stuff**

### End to End Tests

### Contract Tests
**TODO**
Test the contract (interface) between two services. Loose coupling, allow services to evolve on their own without breaking dependencies, foster communication between teams, decouple services and allow omitting flaky and hard to setup end to end testing.

## Avoid Test Duplication
Now that you know that you should write different types of tests there's one more pitfall for you to avoid: test duplication. While your gut feeling might say that there's no such thing as too many tests let me assure you, there is. Every single test in your test suite is additional baggage and doesn't come for free. Writing and maintaining tests takes time. Reading and understanding other people's test takes time. And of course, running tests takes time.

As with production code you should strive for simplicity and avoid duplication. If you managed to test all of your code's edge cases on a unit level there's no need to test for these edge cases again in a higher-level test. As a rule of thumb if you've tested something on a lower level, there's no reason to test it again on a higher level. If your high-level test adds additional value (e.g. testing the integration with a real database) than this is something you should have, even though you might have tested the same database access function in a unit test. Just make sure to focus on the integration part in that test and avoid going through all possible edge-cases again.

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

## Further reading

[Testing Microservices](https://martinfowler.com/articles/microservice-testing)
* TDD by example - Kent Beck
* Continuous Delivery - Jez Humble, Dave Farley

**TODO**

  * spell check
  * more literature about testing, unit testing etc. (Meszaros?, Writing OO Software guided by tests)
  * remove filler words (quite)
  * be consistent with AE/BE
  * "high-level" vs "high level"
