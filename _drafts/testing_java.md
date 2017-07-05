---
layout: post
title: Testing Microservices
tags: programming testing
excerpt: If you want to jump aboard the Microservices hype-train, continuous delivery and test automation will be your best friends. Finding out which tests you need and how you can write them can be quite challenging. This post sums up my experience testing Microservices to allow fast development and frequent deployments.
comments: true
---

Microservices have been all the rage for quite some time now. If you've attended any tech conference or read software engineering blogs lately, you'll probably either be amazed or fed up with all the success stories that companies love to share about their microservices journey.

Somewhere beneath that hype are some true advantages to adopting a microservice architecture. And of course -- as with every architecture decision -- there will be trade-offs. I won't give you a lecture about the benefits and drawbacks of microservices or whether you should use them. Others have done [a way better job](https://www.martinfowler.com/microservices) at breaking this down for you than I ever could. Chance is, if you're reading this article you somehow ended up with the decision to take a look into what's behind this magic buzzword.

The idea for this post has been sitting with me for a long time now. And even during writing this article I was wondering whether I wasn't too late to the party and everything there is to say had already been said. Yet, I still encounter a lot of teams that are heading out on their adventure to build microservices who are still puzzled about this whole testing thing. And I observed that I tell the same stories to all of them. So I decided to write down the essence of these stories for everyone to read. Have fun. **TODO rework intro**

**TODO: teaser image?**

## <abbr title="too long; didn't read">tl;dr</abbr>
What you'll take away from this post:

  * Automate your tests (surprise!)
  * Remember the [test pyramid](https://martinfowler.com/bliki/TestPyramid.html) _(forget about the original names of the layers though)_
  * Write tests with different granularity/levels of integration
  * Use unit test (_solitary_ and _sociable_) to test the insides of your application
  * Use integration tests to test all places where your application serializes/deserializes data (e.g. public APIs, accessing databases and the filesystem, calling other microservices, reading from/writing to queues)
  * Test collaboration between services with contract tests (CDC)
  * Favor CDC tests over end to end tests

**TODO update tl;dr?**

## Microservices Need (Test) Automation

Microservices go hand in hand with **continuous delivery**, a practice where you automatically ensure that your software can be released to production at any time. You use a **build pipeline** to automatically test and deploy your application to all of your testing and production environments. Once you advance on your microservices quest, you'll be juggling with dozens, maybe even hundreds of microservices. At this point building, testing and deploying these services becomes impossible -- at least if you want to deliver working software instead of spending all your time deploying stuff. Automating everything (build, tests, deployment, infrastructure) diligently is your only way forward. 

![build pipeline](/assets/img/uploads/buildPipeline.png)
*use build pipelines to automatically and reliably get your software into production*

Most -- if not all -- success stories around microservices are told by teams who employed continuous delivery or **continuous deployment** (every change to your software that's proven to be releasable will be deployed to production). These teams make sure that all releasable changes quickly get in the hands of their customers. How do you proof that your latest change still results in releasable software? You test your software including the latest change thoroughly. Traditionally you'd do this manually by deploying your application to a test environment and then performing some black-box style testing e.g. by clicking through your user interface to see if anything's broken. It's obvious that testing all changes manually is time-consuming, repetitive and tedious. Repetitive is boring, boring leads to mistakes and makes you look for a different job quite soon. Luckily there's a remedy for repetitive tasks: **automation**. 

Automating your tests can be one of the big game changers for your life as a software developer. Automate your tests and you (or even worse, a separate quality assurance team) no longer have to mindlessly follow click protocols in order to find out if your latest release is ready for production. Automate your tests and you can change your codebase without batting an eye. If you've ever tried doing a large-scale refactoring without a proper test suite I bet you know what a terrifying experience this can be. How would you know if you accidentally broke stuff along the way? Well, you click through all your manual test cases, that's how. But let's be honest: do you really enjoy that? How about making even large-scale changes and knowing whether you broke stuff within seconds while taking a nice sip of coffee? Sounds more enjoyable if you ask me. 

Automation in general and test automation specifically are essential to build a successful microservices architecture. Do yourself a favor and take a look into the concepts behind continuous delivery ([the Continuous Delivery book](https://www.amazon.com/gp/product/0321601912) is my go to resource). You will see that diligent automation allows you to deliver software faster and more reliable. Continuous delivery paves the way into a new world full of fast feedback and experimentation. At the very least it makes your life as a developer more peaceful.

If all this stuff is new to you and you know that you have to start from scratch it can look quite intimidating. There probably are a lot of questions on your mind. What aspects of your codebase do you need to test? How should you structure and write your tests? What tools and libraries can make your life easier? 

To test microservices some concepts, tools and libraries have proven to be effective. Sticking to these can help you come up with a healthy, reliable and fast test suite. I will explain the most important concepts and approaches that you need to understand in order to test your microservices thoroughly. Picking the right tools and libraries often depends on your choice of programming language and its ecosystem. That's why I'll cover tools, libraries and implementation examples in my follow-up posts that will look at specific language ecosystems. **TODO link to follow up posts**


## The Test Pyramid
If you want to get serious about automated tests for your software there is one key concept that you should know about: the **test pyramid**. Mike Cohn came up with this concept in his book [Succeeding with Agile](https://www.amazon.com/dp/0321579364/ref=cm_sw_r_cp_dp_T2_bbyqzbMSHAG05). It's a great visual metaphor telling you to think about different layers of testing and how much testing to do on each layer.

![Test Pyramid](/assets/img/uploads/testPyramid.png)

Mike Cohn's original testing pyramid consists of three layers that your test suite should consist of (bottom to top):
  
  1. Unit Tests
  2. Service Tests
  3. User Interface Tests

Unfortunately the concept of the test pyramid falls a little short if you take a closer look. [Some will argue](https://watirmelon.blog/2011/06/10/yet-another-software-testing-pyramid/) that either the naming or some conceptual aspects of Mike Cohn's test pyramid are not optimal, and I have to agree. From a modern point of view the test pyramid seems overly simplistic and can therefore be a bit misleading. Still, due to it's simplicity the essence of the test pyramid still is a good rule of thumb when it comes to establishing your own test suite/ Your best bet is to remember two things from Cohn's original test pyramid:

  1. Write tests with different granularity
  2. The more high-level you get the fewer tests you should have on that level

Stick to the pyramid shape to come up with a healthy, fast and maintainable test suite: Write _lots_ of small and fast _unit tests_. Write _some_ more coarse-grained tests and _very few_ high level tests that test your application from end to end. Watch out that you don't end up with a [test ice-cream cone](https://watirmelon.blog/2012/01/31/introducing-the-software-testing-ice-cream-cone/) that will be a nightmare to maintain and takes way too long to run.

Don't become too attached to the names of the individual layers in Cohn's test pyramid. In fact they can be quite misleading: _service test_ is a term that is hard to capture (Cohn himself talks about the observation that [a lot of developers completely ignore this layer](https://www.mountaingoatsoftware.com/blog/the-forgotten-layer-of-the-test-automation-pyramid)). In the advent of modern single page application frameworks like react, angular, vue and the legions of others it becomes apparent that _UI tests_ don't have to be on the highest level of your pyramid -- you're perfectly able to unit test your UI in all of these frameworks.

Given the shortcomings of the original names it's totally okay to come up with other names for your test layers. Virtually every team I've worked with came up with different names for _service tests_ and _UI tests_ and that's fine as long as you keep it consistent within your codebase and your team's discussions. To make this more clear, I'll suggest names and give examples of the test types I discovered to be helpful when testing microservices.

## Types of Tests
While the test pyramid suggests that you'll have three different types of tests (_unit tests_, _service tests_ and _UI tests_) I need to disappoint you. Your reality will look a little more diverse. Lets keep Cohn's test pyramid in mind for its good things (use test layers with different granularity, make sure they're differently sized) and find out what types of tests we need for an effective test suite.

### Unit tests
The foundation of your test suite will be made up of unit tests. Your unit tests make sure that a certain unit (your _subject under test_) of your codebase works as intended. 

![unit tests](/assets/img/uploads/unitTest.png)

#### What's a Unit?
If you ask three different people what _"unit"_ means in the context of unit tests, you'll probably receive four different, slightly nuanced answers. To a certain extend it's a matter of your own definition and once again, this is alright. 

If you're working in a functional language a _unit_ will probably be a single function within your codebase. Your unit tests will call your function with different parameters and ensure that the function returns the expected values. In an object-oriented language a unit can range from a single method to an entire class. 

#### Sociable and Solitary
Some argue that all other collaborators (e.g. other classes that are called by your class under test) of your subject under test should be substituted with _mocks_ or _stubs_ to come up with perfect isolation and to avoid side-effects and complicated test setup. Others argue that only collaborators that are slow or have bigger side effects (e.g. classes that access databases or make network calls) should be stubbed or mocked. [Occasionally](https://www.martinfowler.com/bliki/UnitTest.html) people label these two sorts of tests as **solitary unit tests** for tests that stub all collaborators and **sociable unit tests** for tests that allow talking to real collaborators (Jay Fields [Working Effectively with Unit Tests](https://leanpub.com/wewut) coined these terms). If you have some spare time you can go down the rabbit hole and [read more about the pros and cons](https://martinfowler.com/articles/mocksArentStubs.html) of the different schools of thought.

At the end of the day it's not important to decide if you go for solitary or sociable unit tests and if you consider yourself to be a classicist or a mockist kind of tester. Writing automated tests is what's important. Personally, I find myself using both approaches all the time. If it becomes awkward to use real collaborators I will use mocks and stubs generously. If I feel like involving the real collaborator gives me more confidence in a test I'll only stub the outermost parts of my service.

#### Mocking and Stubbing
**Mocking** and **stubbing** ([they are not the same](https://martinfowler.com/articles/mocksArentStubs.html) if you want to be precise)  should be heavily used instruments in your unit tests. In plain words it means that you replace a real thing (e.g. a class, module or function) with a fake version of that thing. The fake version looks and acts like the real thing (answers to the same method calls) but answers with canned responses that you define yourself at the beginning of your unit test. Regardless of your technology choice, there's a good chance that either your language's standard library or some third-party library will provide you with elegang ways to set up mocks. And even writing your own mocks from scratch is only a matter of writing a fake class/module/function with the same signature as the real one and setting up the fake in your test.

Your unit tests will run very fast. On a decent machine you can expect to run thousands of unit tests within a few minutes. Test small pieces of your codebase in isolation and avoid hitting databases, the filesystem or firing HTTP queries (by using mocks and stubs for these parts) to keep your tests fast. Once you got a hang of writing unit tests you will become more and more fluent in writing them. Stub out external collaborators, set up some input data, call your subject under test and check that the returned value is what you expected. Look into [Test-Driven Development](https://en.wikipedia.org/wiki/Test-driven_development) and let your unit tests guide your development; if applied correctly it can help you get into a great flow and come up with a good and maintainable design while automatically producing a comprehensive and fully automated test suite. 


#### Unit Testing is Not Enough
A good unit test suite will be immensely helpful during development: You know that all the small units you tested are working correctly in isolation. Your small-scoped unit tests help you narrowing down and reproducing errors in your code. And they give you fast feedback while working with the codebase and will tell you whether you broke something (unintendedly). Consider them as a tool _for developers_ as they are written from the developer's point of view and make their job easier. 

Unfortunately writing only unit alone won't get you very far. With unit tests alone you don't know whether your application as a whole works as intended. You don't know whether the features your customers love actually work. Being focused on the tiny pieces from the inside point of view you can't put yourself in the customer's shoes and see if everything works for them. You won't know if you did a proper job plumbing and wiring all those components, classes and modules together. Maybe there's something funky happening once all your small units join forces and work as a bigger system? And maybe you wrote perfectly elegant and well-crafted code that totally fails to solve your users problem. Seems like we need more.

### Integration Tests
**TODO: continue**

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
* [Working Effectively with Unit Tests](https://leanpub.com/wewut)

**TODO**

  * spell check
  * more literature about testing, unit testing etc. (Meszaros?, Writing OO Software guided by tests)
  * remove filler words (quite)
  * be consistent with AE/BE
  * "high-level" vs "high level"
  * commata