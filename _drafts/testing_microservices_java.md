---
layout: post
title: Testing Microservices — Java & Spring Boot
tags: programming testing java
excerpt: Based on the previous post about testing microservices, I'll show how to implement different types of tests for a Spring Boot application in Java
comments: true
---

**TODO: link to other post**

In my previous post I gave a round-trip over what it means to test microservices. We discussed the concept of the test pyramid and found out that you should write different types of automated tests to come up with a reliable and effective test suite.

While the previous post was a little more abstract, explaining concepts and high-level approaches, this post will be more hands on. We will explore how we can implement the concepts we discussed before. The technology of choice for this post will be **Java** with **Spring Boot** as the application framework.

This post will show you tools and libraries that help you implement the different types of tests we discussed in the previous post. Some of these can be used independently of Spring Boot. As long as you're using Java you can use these libraries in your codebase -- regardless of the application framework you're using. One of the things I like most about Spring Boot is that it bundles some clever testing mechanisms that support you in writing maintainable and readable tests for your application. So even if you're not using Spring Boot for your application this post might give you some insights.

## Tools and Libraries We'll Look at
  * [**JUnit**](http://junit.org) as our test runner
  * [**Mockito**](http://site.mockito.org/) for mocking dependencies
  * [**Wiremock**](http://wiremock.org/) for stubbing out third-party services
  * [**MockMVC**](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-testing.html#boot-features-testing-spring-boot-applications-testing-autoconfigured-mvc-tests) for writing HTTP integration tests (this one's Spring specific)
  * [**Selenium**](http://docs.seleniumhq.org/) for writing UI-driven end-to-end tests
  * [**Pact**](https://docs.pact.io/) for writing CDC tests

## The Sample Application
I've written a [simple microservice](https://github.com/hamvocke/spring-testing) including. The codebase contains a test suite with tests for the different layers of the test pyramid. There are more tests than necessary for an application of this size. The tests on different levels overlap sometimes. This actively contradicts my hint that you should avoid test duplication throughout your test pyramid. I decided to duplicate tests throughout the test pyramid for demonstration purposes. Please keep in mind that this is not what you want for your real-world application. Duplicated tests are smelly and will be more annoying then helpful in the long run.

The sample application shows traits of a typical microservice. It provides a REST interface, talks to a database and fetches information from a third-party REST service. It's implemented in [Spring Boot ](https://projects.spring.io/spring-boot/) and should be understandable even if you've never worked with Spring Boot before.

Make sure to check out [the code](https://github.com/hamvocke/spring-testing) on github. The readme contains all instructions you need to run the application and all automated tests on your machine.

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

Experienced Spring developers might notice that a frequently used layer is missing here: Inspired by [Domain-Driven Design](https://en.wikipedia.org/wiki/Domain-driven_design) a lot of developers build a **service layer** consisting of _service_ classes (which is its own stereotype in Spring). I decided not to include a service layer in this application. One reason is that our application is simple enough, a service layer would have been an unnecessary level of indirection. The other one is that I think people overdo it with service layers. I often encounter codebases where the entire business logic is captured within service classes. The domain model becomes merely a layer for data, not for behaviour (Martin Fowler calls this an [Aenemic Domain Model](https://en.wikipedia.org/wiki/Anemic_domain_model)). For every non-trivial application this wastes a lot of potential to keep your code well-structured and testable and does not fully utilize the power of object orientation.

Our repositories are straightforward and provide simple <abbr title="Create Read Update Delete">CRUD</abbr> functionality. To keep it simple I used [Spring Data](http://projects.spring.io/spring-data/). Spring Data brings a simple and generic CRUD repository implementation that we can use instead of rolling our own. It also takes care of spinning up a in-memory database for our tests instead of using a real PostgreSQL database as it would in production.

Take a look at the codebase and make yourself familiar with the internal structure. It will be useful for our next step: Testing the application!

## Unit Tests
Unit tests have the smallest scope of all the different tests in your test suite. Depending on the language you're using (and depending on who you ask) unit tests usually test single functions, methods or classes. Since we're working in Java, an object-oriented language, our unit tests will test methods in our Java classes. My rule of thumb is to have one test class per class of production code.

### What to Test?
The good thing about unit tests is that you can write them for all your production code classes, regardless of their functionality or which layer in your internal structure they belong to. You can unit tests controllers just like you can unit test repositories, domain classes or file readers. Simply stick to the **one test class per production class** rule of thumb and you're off to a good start.

A unit test class should at least **test the _public_ interface of the class**. Private methods can't be tested anyways since you simply can't call them from a different test class. _Protected_ or _package-private_ are accessible from a test class (given the package structure of your test class is the same as with the production class) but testing these methods could already go too far.

There's a fine line when it comes to writing unit tests: They should ensure that all your non-trivial code paths are tested (including happy path as well es edge cases). At the same time they shouldn't be tied to your implementation too closely. Why's that? Tests that are too close to the production code quickly become annoying. As soon as you refactor your production code (and remember, refactoring means changing the internal structure of your code without altering the externally visible behavior) your unit tests will break. This way you lose one big benefit of unit tests: acting as a safety net for code changes. So what do you want to do instead? Instead of reflecting your internal code structure within your unit tests it's generally more advisable to simply test for observable behavior instead. Think about "if I enter these values, will those values be returned?" instead of "if I enter these values, will the method call class A first, then call class B and then return the result of class A plus the result of class B?".

Private (and sometimes also protected) methods should generally be considered an implementation detail. In order to avoid tying your tests too closely to the production code, reflecting implementation details in your test code should be avoided.

I often hear opponents of unit testing (or <abbr title="Test-Driven Development">TDD</abbr>) arguing that writing unit tests becomes pointless work where you have to test all your methods in order to come up with a high test coverage. They often cite scenarios where an overly eager team lead forced them to write unit tests for getters and setters and all other sorts of trivial code in order to come up with 100% test coverage. Let me tell you, there's so much wrong with that. Despite my previously cited rule to _"test the public interface"_ take care that there's one huge exception: **Don't test trivial code**. You won't gain anything from testing simple _getters_ or _setters_ or other trivial implementations (e.g. without any conditional logic). Don't worry, [Kent Beck said it's ok](https://stackoverflow.com/questions/153234/how-deep-are-your-unit-tests/).

### But I Really Need to Test This Private Method
If you ever find yourself in a situation where you _really really_ need to test a private method you should take a step back and ask yourself why. I'm pretty sure this is more of a design problem than a scoping problem. Most likely you feel the need to test a private method because it's complex and testing this method through the public interface of the class requires a lot of awkward setup. When I find myself in this situation I usually come to the conclusion that the class I'm testing is already too complex. It's doing too many things -- and thus violates the _single responsibility_ principle, the _S_ of the five [_SOLID_](https://en.wikipedia.org/wiki/SOLID_(object-oriented_design)) principles. The solution that often works for me is to split the original class in two classes. I move the private method (that I urgently want to test on its own) to the new class, make the new class a dependency of the old one and let the old class call the new dependency. Voilà, my awkward-to-test private method is now public and can be tested. On top of that I have improved the structure of my code by adhering to the single responsibility principle.

### Test Structure
Typically your unit tests should follow a simple structure:
  1. Set up the test data
  2. Call your method under test
  3. Assert that the expected results are returned

There's a quite nifty mnemonic to keep in mind. Just thing of the _"three As"_ when writing a test: [_"Arrange, Act, Assert"_](http://wiki.c2.com/?ArrangeActAssert). Another one that you can use takes inspiration from <abbr title="Behavior-Driven Development">BDD</abbr>. It's the _"given"_, _"when"_, _"then"_ triad, where _given_ reflects the setup, _when_ the method call and _then_ the assertion part.

This pattern can be applied to other, more high-level tests as well. In every case they ensure that your tests remain easy and consistent to read. On top of that tests written with this structure in mind tend to be shorter and more expressive.

### An Example
Now that we know what to test and how to structure our unit tests we can finally see a real example.

Let's take the following `Controller` class:

{% highlight java %}
@RestController
public class ExampleController {

    private final PersonRepository personRepo;

    @Autowired
    public ExampleController(final PersonRepository personRepo) {
        this.personRepo = personRepo;
    }

    @GetMapping("/hello/{lastName}")
    public String hello(@PathVariable final String lastName) {
        Optional<Person> foundPerson =
	    personRepo.findByLastName(lastName);

        return foundPerson
                .map(person -> String.format("Hello %s %s!",
		    person.getFirstName(),
		    person.getLastName()))
                .orElse(String.format("Who is this '%s' you're talking about?", lastName));
    }
}
{% endhighlight %}

A corresponding unit test for the `hello(lastname)` method could look like this:

{% highlight java %}
public class ExampleControllerTest {

    private ExampleController subject;

    @Mock
    private PersonRepository personRepo;

    @Before
    public void setUp() throws Exception {
        initMocks(this);
        subject = new ExampleController(personRepo);
    }

    @Test
    public void shouldReturnFullNameOfAPerson() throws Exception {
        Person peter = new Person("Peter", "Pan");
        given(personRepo.findByLastName("Pan"))
	    .willReturn(Optional.of(peter));

        String greeting = subject.hello("Pan");

        assertThat(greeting, is("Hello Peter Pan!"));
    }

    @Test
    public void shouldTellIfPersonIsUnknown() throws Exception {
        given(personRepo.findByLastName(anyString()))
	    .willReturn(Optional.empty());

        String greeting = subject.hello("Pan");

        assertThat(greeting, is("Who is this 'Pan' you're talking about?"));
    }
}
{% endhighlight %}

We're writing the unit tests using [JUnit](http://junit.org) which is the de-facto standard testing framework for Java. We're also using [Mockito](http://site.mockito.org/) to replace the real `PersonRepository` class with a mock for our test. This mock allows us to define canned responses that should be returned in our test context. This makes our test predictable and easy to setup.

Following the _arrange, act, assert_ structure explained above, we can now write two unit tests -- a positive case and a case where the searched person cannot be found. The first, positive test case creates a new person object and tells the mocked repository to return this object when it's called with _"Pan"_ as the value for the `lastName` parameter. The test then goes on to call the method that should be tested and finally asserts that the response is equal to the expected response. The second test works similarly but tests the scenario where the tested method does not find a person for the given parameter.

## Integration Tests
Integration tests are the next level in your test pyramid. They test that your application can integrate with its sorroundings successfully. For your automated tests this means you don't just need to provide your own application but also the component you're integrating with. If you're testing the integration with a database you need to run a database during your tests. For testing that you can read files from a disk you need to save a file to your disk and use it as input for your integration test.

### What to Test?
A good way to think about the places of your microservice where you should have integration tests is to think about all places where data gets serialized or deserialized. Common places are:

  * reading HTTP requests and sending HTTP responses through your REST API
  * reading and writing from/to a database
  * reading and writing from/to a filesystem
  * sending HTTP(S) requests to other services and parsing their responses

In our sample codebase you can find integration tests for `Repository`, `Controller` and `Client` classes. All these classes interface with the sorroundings of the application (databases or the network) and serialize and deserialize data. Having tests in place to test these integrations is something we can't achieve with unit tests.

### Database Integration
The `PersonRepository` is the only repository class in the codebase. It relies on _Spring Data_ and has no actual implementation. It just extends the `CrudRepository` interface and provides a single method header. The rest is Spring magic. Even without the method definition Spring Boot provides a fully functional CRUD repository with `findOne`, `findAll`, `save`, `update` and `delete` methods. Our custom method definition extends this basic functionality and allows us to provide a way to fetch `Person`s by their last name. Spring Data analyses the return type of the method and its method name and checks the method name against a naming convention to figure out what it should do.

{% highlight java %}
public interface PersonRepository extends CrudRepository<Person, String> {
    Optional<Person> findByLastName(String lastName);
}
{% endhighlight %}

Although _Spring Data_ does the heavy lifting of implementing database repositories for us, I still wrote a database integration test. You might argue that this is _testing the framework_ and something that I should avoid as it's not our code we're testing. Still, I believe having at least one integration test here is crucial. First it tests that our custom `findByLastName` method actually behaves correctly. Secondly it proves that our repository in general uses Spring's magic correctly and most of it all can connect to our desired database.

**TODO remove H2 dependency, provide docker container instead?**
To make things even easier our test connects to an in-memory _H2_ database. We've defined H2 as a test dependency in our `build.gradle`. Our `application-test.properties` in our test directory don't define any `spring.datasource` properties that's how Spring Data knows it should use an in-memory database. As it finds H2 on the classpath it simply uses H2 during our tests. When running the real application with the `int` profile it connects to a PostgreSQL database as defined in the `application-int.properties`. To avoid having to run a PostgreSQL database during testing I decided to replace it with an H2 instead. That's an awful lot of Spring magic to know and understand. The resulting code is quite easy on the eye but hard to understand if you don't know the fine details of Spring Data. Go ahead and decide for yourself if you prefer magic and simple code over an explicit yet more verbose implementation.

A simple integration test that saves a Person to the connected database and then tries to find it by its last name looks like this:

{% highlight java %}
@RunWith(SpringRunner.class)
@DataJpaTest
public class PersonRepositoryIntegrationTest {
    @Autowired
    private PersonRepository subject;

    @After
    public void tearDown() throws Exception {
        subject.deleteAll();
    }

    @Test
    public void shouldSaveAndFetchPerson() throws Exception {
        Person peter = new Person("Peter", "Pan");
        subject.save(peter);

        Optional<Person> maybePeter = subject.findByLastName("Pan");

        assertThat(maybePeter, is(Optional.of(peter)));
    }
}
{% endhighlight %}

You can see that our integration test follows the same _arrange, act, assert_ structure as the unit tests.

### REST API Integration
Testing our microservice's REST API is quite simple. First we can of course write simple unit tests for all `Controller` classes and call the controller methods directly. `Controller` classes should generally be quite straightforward and focus request and response handling. Putting business logic into controllers should be avoided. Therefore unit tests will be pretty easy.

As Controllers make heavy use of [Spring MVC's](https://docs.spring.io/spring/docs/current/spring-framework-reference/html/mvc.html) annotations for defining endpoints, query parameters and others we won't get very far with unit tests alone. In order to see if our API works as expected, e.g. by providing the correct endpoints, interpreting input parameters and answering with correct status codes and HTTP endpoints we have to go beyond unit tests. One way to test this would be to start up the entire Spring Boot service and fire real HTTP requests against our API. With this approach we'd be on the very top of our test pyramid. There's another way that's a little less end-to-end. Spring MVC comes with a nice testing utility we can use: [MockMVC](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#boot-features-testing-spring-boot-applications-testing-autoconfigured-mvc-tests) allows us to only spin up a small slice of our spring application and use a nice <abbr title="Domain-Specific Language">DSL</abbr> to fire test requests at our API and check that the returned data is as expected.

Let's take our `ExampleController` and check if the `/hello/<lastname>` endpoint works correctly:

{% highlight java %}
@RestController
public class ExampleController {

    private final PersonRepository personRepository;

    // shortened for clarity

    @GetMapping("/hello/{lastName}")
    public String hello(@PathVariable final String lastName) {
        Optional<Person> foundPerson = personRepository.findByLastName(lastName);

        return foundPerson
             .map(person -> String.format("Hello %s %s!", person.getFirstName(), person.getLastName()))
             .orElse(String.format("Who is this '%s' you're talking about?", lastName));
    }
}
{% endhighlight %}

Our controller calls the `PersonRepository` in the `/hello/<lastname>` endpoint. For our tests we need to replace this repository class with a mock to avoid hitting a real database. The controller integration test looks as follows:

{% highlight java %}
@RunWith(SpringRunner.class)
@WebMvcTest(controllers = ExampleController.class)
public class ExampleControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private PersonRepository personRepository;

    // shortened for clarity

    @Test
    public void shouldReturnFullName() throws Exception {
        Person peter = new Person("Peter", "Pan");
        given(personRepository.findByLastName("Pan")).willReturn(Optional.of(peter));

        mockMvc.perform(get("/hello/Pan"))
                .andExpect(content().string("Hello Peter Pan!"))
                .andExpect(status().is2xxSuccessful());
    }
}
{% endhighlight %}

We annotated the test class with `@WebMvcTest` and tell the annotation which controller we're testing. This mechanism instructs Spring to only start the Rest API slice of our application. We won't hit any repositories so spinning them up and requiring a database to connect to would simply be wasteful. This is why the `@WebMvcTest` annotation is quite handy for us.

Instead of relying on the real `PersonRepository` dependency we replace it with a mock in our Spring context using the `@MockBean` annotation. This annotation replaces the annotated class with a Mockito mock globally. In our test methods we can set the behaviour of these mocks exactly as we would do in a unit test, it's a Mockito mock after all. In our simple case we return a static string so there's no need to set up any mocks.

To use `MockMvc` we can simply `@Autowire` a MockMvc instance. In combination with the `@WebMvcTest` annotation this is all Spring needs to fire test requests against our controller. In the test method you see `MockMvc` in action. You can use its DSL to fire requests (in our case a _GET_ request) againt your controller's endpoints and then expect return values and HTTP status codes. The `MockMVC` DSL is quite powerful and should get you a long way.

### Integration With Third-Party Services

### Parsing and Writing JSON
Writing a REST API these days you often send your data as JSON over the wire. Using Spring there's no need to writing JSON on your own. Instead you define <abbr title="Plain Old Java Object">POJOs</abbr> that represent the JSON structure you want to parse from a request or send with a response.

Spring automatically can automatically parse JSON and convert it into your Java object structure and vice versa. When we talk to the weather API we receive JSON as response. To make this data structure accessible in our Java code I've written the `WeatherResponse` class. This class defines the nested JSON object structure with all fields that are relevant in our case (for us this is `response.currently.summary` only). Spring uses [Jackson](https://github.com/FasterXML/jackson) to convert between Java and JSON per default. This mechanism is usually hidden from you as a developer. If you define a method in a `RestController` that returns a POJO, Spring MVC will automatically use Jackson to convert that POJO to JSON and send the resulting JSON in the resposne body. Using Spring's `RestTemplate` you get the same magic. If you send a request using `RestTemplate` you can provide a POJO class that should be used to parse the response. Again, Jackson is used under the hood per default.

If you want to test-drive your Jackson Mapping, take a look at the `WeatherResponseTest` I've written.  In this test I test the conversion of JSON into a `WeatherResponse` object. Since this deserialization is the only conversion taking place in the application's flow there's no need to test if a `WeatherResponse` can be converted to JSON correctly. Using this approach it's very simple to test the other way, though.

{% highlight java %}
@Test
public void shouldDeserializeJson() throws Exception {
   String jsonResponse = FileLoader.read("classpath:weatherApiResponse.json");
   WeatherResponse expectedResponse = new WeatherResponse("Rain");

   WeatherResponse parsedResponse = new ObjectMapper().readValue(jsonResponse, WeatherResponse.class);

   assertThat(parsedResponse, is(expectedResponse));
}
{% endhighlight %}

In this test case I read a sample JSON response from a file (you could also simply define a `String` in your test case) and let Jackson parse this JSON response using `ObjectMapper.readValue()`. I then compare the result of the conversion with an expected `WeatherResponse` to see if the conversion works as expected.

You can argue that this kind of test is rather a unit than an integration test. Nevertheless, this kind of test can be pretty valuable to make sure that your JSON serialization and deserialization works as expected. Having these tests in place allows you to keep the integration tests around your REST API and your client classes smaller as you don't need to check the entire JSON conversion again.

## CDC Tests

## General Rules
  * Test code is as important as production code. Give it the same level of care and attention
  * one assertion per test


**TODO**
  * provide readme.md for repo
  * link to previous article
