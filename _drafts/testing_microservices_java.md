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
The next thing we'll look at is integrating with third-party services. Our microservice talks to [darksky.net](https://darksky.net), a weather REST API. Of course we want to ensure that our service sends requests correctly and parses the responses as we need.

We want to avoid hitting the real _darksky_ servers during our automated tests. Quota limits of our free plan is only part of the reason. The real reason is decoupling. Our tests should run independently of whatever the lovely people at darksky.net are doing. Even when the machine, we're running the tests on, can't access the _darksky_ servers, e.g. when sitting in an airplane without internet connection, when the _darksky_ servers have temporary hiccups or we have a flaky internet connection.

To avoid hitting the real _darksky_ servers, we'll provide our own, fake _darksky_ server while running our integration tests. This might sound like a huge task. Thanks to tools like [Wiremock](http://wiremock.org/) it's easy peasy.

{% highlight java %}
@RunWith(SpringRunner.class)
@SpringBootTest
public class WeatherClientIntegrationTest {

    @Autowired
    private WeatherClient subject;

    @Rule
    public WireMockRule wireMockRule = new WireMockRule(8089);

    @Test
    public void shouldCallWeatherService() throws Exception {
        wireMockRule.stubFor(get(urlPathEqualTo("/some-test-api-key/53.5511,9.9937"))
                .willReturn(aResponse()
                        .withBody(FileLoader.read("classpath:weatherApiResponse.json"))
                        .withHeader(CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                        .withStatus(200)));

        Optional<WeatherResponse> weatherResponse = subject.fetchWeather();

        Optional<WeatherResponse> expectedResponse = Optional.of(new WeatherResponse("Rain"));
        assertThat(weatherResponse, is(expectedResponse));
    }
}
{% endhighlight %}

To use Wiremock we instanciate a `WireMockRule` on a defined port and set up our fake server using Wiremock's DSL. Using the DSL we can define endpoints and corresponding canned responses the Wiremock server should listen and respond to. Next we can call the method we want to test, the one that calls the third-party service and check if the result is parsed correctly. You'll be wondering how this works. How does the test know that it should call the fake Wiremock server instead of the real _darksky_ API. The secret lies in our `application.properties` file contained in `src/test/resources`. This is the properties file Spring loads when running tests. In this file we override configuration like API keys and URLs with values that are suitable for our testing purposes, e.g. calling the the fake Wiremock server instead of the real one:

    weather.url = http://localhost:8089

Note that the port has to be the same we define when instanciating the `WireMockRule` in our test. Exchanging the real weather API URL with a fake one in our tests is made possible by injecting URL in our `WeatherClient` class' constructor:

{% highlight java %}
@Autowired
public WeatherClient(final RestTemplate restTemplate,
                     @Value("${weather.url}") final String weatherServiceUrl,
                     @Value("${weather.api_key}") final String weatherServiceApiKey) {
    this.restTemplate = restTemplate;
    this.weatherServiceUrl = weatherServiceUrl;
    this.weatherServiceApiKey = weatherServiceApiKey;
}
{% endhighlight %}

This way we tell our `WeatherClient` to read the `weatherUrl` parameter's value from the `weather.url` property we define in our application properties.

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
Consumer-Driven Contract (CDC) tests ensure that both parties involved in an interface between two services (the provider and the consumer) stick to the contract defined to keep the integration between these services intact.

Writing CDC tests can be as easy as sending HTTP requests to a deployed version of the service we're integrating against and verifying that the service answers with the expected data and status codes. Rolling our own CDC tests from scratch is straightforward but will soon send us down a rabbit hole. We need to somehow come up with a way to bundle our CDC tests, distribute CDC them between teams and need to find a mechanism for versioning. While this is certainly possible, I want to demonstrate a different way.

In this example I'm using [Pact](https://github.com/DiUS/pact-jvm) to implement the consumer and provider side of our CDC tests. Pact is available for multiple languages and can therefore also be used in a polyglot context. Using Pact we only need to exchange JSON files between consumers and providers. One of the more advanced features even gives us a so called ["pact broker"](https://github.com/pact-foundation/pact_broker/tree/master) that we can use to exchange pacts between teams and show which services integrate with each other.

Contract tests always include both sides of an interface -- the consumer and the provider. Both parties need to write and run automated tests to ensure that their changes don't break the interface contract. Let's take a look at both sides in our example.

### Consumer Test (our end)
Our microservice consumes the weather API. So it's our responsibility to write a **consumer test** that defines our expectations for the contract (the API) between our microservice and the weather service.

First we include a library for writing pact consumer tests in our `build.gradle`:

    testCompile("au.com.dius:pact-jvm-consumer-junit_2.11:3.5.5")

Thanks to this library we can implement a consumer test and use pact's mock services:

{% highlight java %}
@RunWith(SpringRunner.class)
@SpringBootTest
public class WeatherClientConsumerTest {

    @Autowired
    private WeatherClient weatherClient;

    @Rule
    public PactProviderRuleMk2 weatherProvider = new PactProviderRuleMk2("weather_provider", "localhost", 8089, this);

    @Pact( consumer="test_consumer")
    public RequestResponsePact createPact(PactDslWithProvider builder) throws IOException {
        return builder
                .given("weather forecast data")
                .uponReceiving("a request for a weather request for Hamburg")
                    .path("/some-test-api-key/53.5511,9.9937")
                    .method("GET")
                .willRespondWith()
                    .status(200)
                    .body(FileLoader.read("classpath:weatherApiResponse.json"), ContentType.APPLICATION_JSON)
                .toPact();
    }

    @Test
    @PactVerification("weather_provider")
    public void shouldFetchWeatherInformation() throws Exception {
        Optional<WeatherResponse> weatherResponse = weatherClient.fetchWeather();
        assertThat(weatherResponse.isPresent(), is(true));
        assertThat(weatherResponse.get().getSummary(), is("Rain"));
    }
}
{% endhighlight %}

If you look closely, you'll see that the `WeatherClientConsumerTest` is very similar to the `WeatherClientIntegrationTest`. Instead of using Wiremock for the server stub we use Pact this time. In fact the consumer test works exactly as the integration test, we replace the real third-party server with a stub, define the expected response and check that our client can parse the response correctly. The difference this time is that the consumer test will also generate a **pact file** (`target/pacts/<pact-name>.json`) that describes our expectations for the contract.

We can take this pact file file and hand it to the team providing the interface. They in turn can take this pact file and write a provider test using the defined expectations. This way they can test if their API fulfills all our expectations.

In your real-world application you'd don't need both, a _client integration test_ and a _client consumer test_. The sample codebase contains both to show you how to use either one. If you want to write CDC tests using pact I recommend sticking to the latter. The effort writing the tests is the same. Using pact has the benefit that you automatically win a pact file with the expectations to the contract that other teams can use to easily implement their provider tests. Of course this only makes sense if you can convince the other team to use pact as well. If this doesn't work, using the _integration test_ and Wiremock combination is a decent plan b.

### Provider Test (the other team)
The provider test in our example has to be implemented by the people providing the weather API. We're consuming a public API provided by darksky.net. In theory the darksky team would implement the provider test on their end to check that they're not breaking the contract between their application and our service. Obviously they don't care about our little sample application and won't implement a CDC test for us. That's the big difference between a public-facing API and an organisation adopting microservices. Public-facing APIs can't consider every single consumer out there or they'd become unable to move forward. Within your own organisation, you can. Your app will probably serve a handful, maybe a couple dozen of consumers max. You'll be fine writing provider tests for these interfaces in order to keep a stable system.

The **"consumer-driven"** part of CDC makes clear that the consumer of an API drives what the contract between services looks like. Pact makes sure that this happens by generating pact files with every run of consumer tests. The consumer team has to make these pact files available to the providing team. There's multiple ways this can be done. A simple one would be to check them into version control and tell the provider team to always fetch the latest version of the pact file.

This pact file can be fetched by the providing team and then run against their providing service. All the providing team has to do is to implement a provider test that reads the pact file, stubs out some test data and runs the expectations defined in the pact file against their service.

The pact folks have written several libraries for implementing provider tests. Their main [GitHub repo](https://github.com/DiUS/pact-jvm) gives you a nice overview which consumer and which provider libraries are available. Pick the one that matches your tech stack best. For simplicity we assume that the darksky API is implemented in Spring Boot as well. This allows us to use the [Spring pact provider](https://github.com/DiUS/pact-jvm/tree/master/pact-jvm-provider-spring) which hooks nicely into Spring's MockMVC mechanisms. A hypothetical provider test that the darksky.net team would implement could look like this:

{% highlight java %}
@RunWith(RestPactRunner.class)
@Provider("weather_provider") // same as in the "provider_name" part in our clientConsumerTest
@PactFolder("target/pacts") // tells pact where to load the pact files from
public class WeatherProviderTest {
    @InjectMocks
    private ForecastController forecastController = new ForecastController();

    @Mock
    private ForecastService forecastService;

    @TestTarget
    public final MockMvcTarget target = new MockMvcTarget();

    @Before
    public void before() {
        initMocks(this);
        target.setControllers(forecastController);
    }

    @State("weather forecast data") // same as the "given()" part in our clientConsumerTest
    public void weatherForecastData() {
        when(forecastService.fetchForecastFor(any(String.class), any(String.class)))
                .thenReturn(weatherForecast("Rain"));
    }
}
{% endhighlight %}

You see that all the provider test has to do is to load a pact file (using the `@PactFolder` annotation to load previously downloaded pact files or attaching to a pact broker using a different annotation) and then define how test data for pre-defined states should be provided (e.g. using Mockito mocks). There's no custom test to be implemented as these are all derived from the pact file. It's important that the provider test has matching counterparts to the _provider name_ and _state_ declared in the consumer test.

## End-to-End Tests
At last we arrived at top of our test pyramid. Time to write a real end-to-end test that calls our service via the user interface and includes a complete round-trip through the complete system.

For end-to-end tests [Selenium](http://docs.seleniumhq.org/) and the [WebDriver](https://www.w3.org/TR/webdriver/) protocal have proven to be the tool of choice for many developers. Using Selenium you can pick a browser you like and let it automatically call your website, click here and there, enter data and check that stuff changes in the user interface.

Selenium needs a browser that it can start and use for running its tests. There are multiple so-called _'drivers'_ for different browsers that you could use. Running a fully-fledged browser can be challenging when running your test suite. Especially when using continuous delivery the server running your pipeline might not always be able to spin up a browser including its user interface (e.g. because there's no XServer available). There are workarounds for this problem like starting a virtual XServer like [xvfb](https://en.wikipedia.org/wiki/Xvfb). A more recent approach is to use a _headless_ browser (i.e. a browser that doesn't have a user interface) to run your webdriver tests. Until recently [PhantomJS](http://phantomjs.org/) was the leading headless browser used for browser automation. Ever since both [Chromium](https://developers.google.com/web/updates/2017/04/headless-chrome) and [Firefox](https://developer.mozilla.org/en-US/Firefox/Headless_mode) announced that they've implemented a headless mode in their browsers PhantomJS all of a sudden became obsolete. After all it's better to test your website with a browser that your users actually use (like Firefox and Chrome) instead of using an artificial browser just because it's convenient for you as a developer.

Both, headless Firefox and Chrome, are brand new features that might not work in your environment yet. We want to keep things simple. Instead of fiddling around to use the bleeding edge headless modes let's stick to the more simple classic way. A simple end-to-end test that fires up a Firefox browser, navigates to our service and checks the content of the website looks like this:

{% highlight java %}
@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class ExampleE2ETest {

    private WebDriver driver = new FirefoxDriver();

    @LocalServerPort
    private int port;

    @After
    public void tearDown() {
        driver.close();
    }

    @Test
    public void helloPageHasTextHelloWorld() {
        driver.get(String.format("http://127.0.0.1:%s/hello", port));

        assertThat(driver.findElement(By.tagName("body")).getText(), containsString("Hello World!"));
    }
}
{% endhighlight %}

Note that this test will only run on your system if you have Firefox installed on the system you run this test on. That also means that your continuous integration server needs to install Firefox as well to be able to run this test.

## General Rules
  * Test code is as important as production code. Give it the same level of care and attention
  * one assertion per test


**TODO**
  * provide readme.md for repo
  * link to previous article
