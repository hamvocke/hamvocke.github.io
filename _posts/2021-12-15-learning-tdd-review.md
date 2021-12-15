---
layout: post
title: “Learning Test-Driven Development” - A Book Review
tags: programming testing
excerpt: A book review for Saleem Siddiqui's “Learning Test-Driven Development”. Spoiler alert -- It's excellent.
summary: “Learning Test-Driven Development” is a fresh take on teaching TDD to curious developers. Go check it out.
image: /assets/img/uploads/learning-tdd-cover.jpg
comments: true
---

Earlier this year I received an email from my friend and former coworker Saleem Siddiqui. Saleem must have thought that spare time was overrated since he told me that he was [writing a book on Test-Driven Development](https://www.oreilly.com/library/view/learning-test-driven-development/9781098106461/) and O'Reilly agreed to publish it. He asked if I wanted to be one of his technical reviewers and read through early versions of the book to make sure that it is logically sound, that code samples are correct and to chime in with other suggestions.

I was thrilled.

Saleem is a person who had a huge impact on who I am as a professional. We worked together on a ThoughtWorks project in Hamburg, building software for a smart home device and its cloud ecosystem. Pair-programming with Saleem was what made <abbr title="Test-Driven Development">TDD</abbr> truly click for me. Saleem is a gifted teacher and an advocate for keeping software simple and maintainable by driving software design with automated tests. I was fortunate enough to have worked with Saleem in person. It's amazing that he decided to take his passion and talent for teaching to a wider audience by writing this book.

[![Learning Test-Driven Development book cover](/assets/img/uploads/learning-tdd-cover.jpg)](https://www.oreilly.com/library/view/learning-test-driven-development/9781098106461/)

> **Full disclosure:** This is my personal review of _Learning Test-Driven Development_. I'm not paid for it, I don't get any affiliate money, and nobody asked me to write this. I don't have any financial stakes in this book. Yet, this is not an unbiased review. It couldn't be, for the reasons I've outlined above. I hope this can still be a helpful review for you.

## _Learning Test-Driven Development_ in a nutshell

The summary is in the title, really. _Learning Test-Driven Development_ teaches software developers how to do Test-Driven Development (_TDD_). Throughout the book, you're building a small application that is able to calculate with and translate between different `Currencies`. After a short setup, you will build this application in a true TDD way. You start with a failing test, get it to pass by writing code, and then clean up and refine. Rinse and repeat until the application is done. The book uses the same `Money` example Kent Beck used in his seminal _"Test-Driven Development by Example"_ and gives it a more modern spin. You can choose between three programming languages -- JavaScript, Python and Go -- and learn hands-on how to iteratively build a currency converter in either (or all) of these languages driven by tests. By the end of the book you will have a good understanding of what TDD feels like and how to apply it. You will use the "red-green-refactor" cycle ad nauseam (which is good) and experience how tests help you keep your code malleable and clutter-free.

## Who should read this book?

This book is great for:

1. Developers who have never used TDD and want to learn it from scratch
2. Developers who have tried TDD in the past and discarded it because it didn't click for them
3. Developers who want to level-up their automated testing skills without necessarily becoming TDD evangelists
4. Developers who are curious to dive into JavaScript, Python or Go (or all three of them) and see how they compare

If you are just starting out in your programming career and learned one popular programming language already, I highly recommend working through this book. Testing is one of the most important skills to master as a software developer and pays compound interest. Make your life as a developer better by learning this crucial skill early on.

If you are a seasoned programmer with doubts about TDD, this book might help you get a new perspective. Maybe you got fed up with TDD after working with someone who _just wouldn't shut up_ about TDD. Or you might have been annoyed by an overbearing manager who demanded you hit 100% test coverage and did not understand that this was a silly goal. You might have tried TDD on a gnarly legacy codebase only to find out that everything is too tedious and taking you twice as long, and that unit tests are rarely helpful anyways. Take this book for a spin and follow the examples hands-on to see if it clicks for you.

If you are an experienced TDD practitioner or someone who has written a fair amount of unit tests in the past and understands their benefits and shortcomings, this book will not teach you many new tricks. If, on the other hand, you consider training others to become more proficient with TDD and test automation, this book might serve as a nice workbook to use for this kind of training.

## What's in the book?

The book is best used as a hands-on workbook. I recommend not just reading it but actually working through the examples on your own as you read the book. Open an editor, write those tests, see them fail, make them pass. You'll only get a fraction out of the book if you're merely reading it back to back. By writing code on your own, you'll make sure to truly _experience_ the TDD cycle and the benefits of guiding your implementation by writing tests first.

### The `Money` problem

The book revolves around a simple exercise: Build an application that allows you to calculate with and convert between different currencies. This program will be able to answer questions like `What's 42 USD + 12 EUR in CHF?`. It is a fairly well-known code kata (popularized by Kent Beck's book on TDD) that stays fairly simple. You are not building a web application. You are not talking to a database. There is no ~~silly~~ <ins>fancy</ins> blockchain. It is a simple program doing simple calculations. This is a good thing because it allows you to keep focused on the essence of learning the TDD cycle. However, if you want to learn about advanced patterns of testing (how do I deal with caching? how do I simulate HTTP requests? how do I test code that talks to a database?), this book won't help much (read on for some recommendations if this is your concern).

### `Python` or `Go` or `JavaScript`? Or all of them?

The subtitle of this book promises that this is  _"A Polyglot Guide to Writing Uncluttered Code"_. And it keeps that promise. The book uses three parallel language tracks to walk you through the `Money` example. You can choose between `JavaScript`, `Python` and `Go` as the language to work with. You can also choose to work with two (or even all three) languages in parallel. Totally up to you. 

If you are mostly looking for a quick introduction (or a refresher) on TDD in a language you know, I recommend picking one language and working your way through the book. You should be done in a handful of hours and leave with a better understanding for TDD in you chosen language.

If you are curious about learning either of these three languages, the simple nature of the code sample is a great way to learn basic syntax, build and test commands.

If you are curious about statically vs. dynamically typed or compiled vs. interpreted languages and want to experience how writing code and tests feels with each of those, I recommend picking two or three languages when working your way through the book.

### Red - Green - Refactor

The mantra of TDD - `Red - Green - Refactor` - describes the small feedback cycle you use to develop software in a test-driven way. You start with a failing (red) test, write code to make it pass (green) and then take your time to clean up and refactor. And back to square one. It's one thing to read about the "RGR" cycle and nod in agreement. It's another thing to apply it. This is where most people start struggling when the rubber hits the road in my experience. They try to get started with TDD but feel like they are going too slow and become frustrated. Or they are taking too big steps at once and lose track of what they're doing.

_"Learning TDD"_ drives this point home. Saleem explains the `Red - Green - Refactor` cycle and demonstrates over and over again how to apply it. He is giving valuable advice how you can use _"RGR"_ to speed up when you're confident and slow down and take baby-steps when the task ahead becomes scary and hard to grasp.

Working through this book will give you a profound understanding for this small feedback cycle. Chances are you will finish the book longing for similarly short and snappy feedback cycles for your day to day work as a software developer. **Fast feedback** is a great boost to productivity in software development. Continuous Delivery and Agile methodologies try to establish this concept on a team-wide level. TDD is your own personal tool to get fast feedback while you fix bugs or work on new features.

### Unit Testing, Design and Maintainability

TDD is not primarily about unit testing. It is a tool to help you design your software - and you get unit tests and long-term maintainability as helpful byproducts. By writing unit tests first you think about the design of your APIs, your classes, methods and functions. You end up with working examples calling your code and asserting correct behavior. You have an automated test suite that allows you and everyone else on your team to change and improve your code in a safe way.

You will take a quick detour into software design. The book briefly explains how loose coupling and high cohesion make your code more maintainable. It touches on _Dependency Injection_, a crucial pattern to help with decoupling and testing. And here sits my main gripe with the book: These aspects fall a little too short to my taste. There is just enough information for beginners to learn the important terms and concepts but experienced developers _will_ feel like they need more details here. I understand that explaining good design and waffling about low coupling and high cohesion is out of scope for this book - but I think it is an important aspect to follow up on.

This book demonstrates the ideas behind TDD rather than endlessly explaining philosophical aspects. You will write tests, write code, clean up, refactor, delete code, and improve iteratively while having a test suite backing you up on each step. If you've ever wanted to refactor an unwieldy, complicated and untested piece of code, you know how daunting that is. Here, you will experience what the alternative feels like - and trust me, once you've experienced this, you don't want to go back.


### A Practical Developer Workflow

Finally, this book puts emphasis on an effective developer workflow. You will use `git` to version control your changes from the very beginning. Every step you take will be wrapped up by creating distinct commits in `git` to conclude you work. On top of that, Saleem dedicates an entire chapter to demonstrate how to set up a [Continuous Integration](https://en.wikipedia.org/wiki/Continuous_integration) (CI) build using [GitHub Actions](https://github.com/features/actions). 

If you are relatively new to the trade, this will be an excellent and no-frills explanation of two immensely useful tools in a developer's toolkit: Version Control and Continuous Integration. If you are a seasoned developer and familiar with `git` already, it's nice to see how you can use TDD's "RGR" cycle to size your commits into helpful and small chunks.


## Should I read this book or Kent Beck's _"TDD by Example"_?

_"Learning Test-Driven Development"_ uses an approach that's very similar to Part I of [Kent Beck's _"Test-Driven Development by Example"_](https://en.wikipedia.org/wiki/Continuous_integration). So why would you read this book instead of the original? And are there any reasons to prefer Kent Beck's book to this one?

_"Learning TDD"_ is a modern take on Kent Beck's 20 year old seminal book on TDD. Instead of using a rather dated flavour of Java, you can choose between JavaScript, Python and Go. _"Learning TDD"_ is using modern workflows that are widely regarded a good idea when developing software today (namely version control and CI). Finally, _"Learning TDD"_ is a beginner-friendly, approachable, no frills, hands-on guide to get you up to speed with Test-Driven Development. Nothing more, nothing less. It's not trying to sell you philosophical aspects of TDD, it's showing you how to practice it. It assumes that you're either willing to learn TDD or looking for a refresher, it does not assume you need to be fundamentally convinced that TDD is a good thing.

Kent Beck's _"TDD by Example"_ goes beyond being a hands-on workshop. On top of the `Money` code kata, Kent Beck's original will cover fundamental thoughts and additional patterns more explicitly. In his last part, Beck goes on to explain patterns that make writing tests and testable code easier. As an example, Beck explains how to use Mock objects to test awkward interactions (like database calls), which is a quite common need web development. _"Learning TDD"_ doesn't come with a dedicated "Patterns" section but rather demonstrates some of those patterns and concepts as part of the journey the reader is going through. If you're the person who prefers reading a pattern catalogue, Beck's book might have what you're looking for.


## Where does this book fall short?

Learning and mastering Test-Driven Development is a long and nuanced journey. I've been using TDD for the majority of my career. I've [written extensively about testing](https://martinfowler.com/articles/practical-test-pyramid.html). I've taught others. Yet there are still things I don't know. I still write tests that are low-value. I still end up with tests that are tied too close to the implementation. And, of course, I still get silly bugs into production that could've been prevented by a certain test. You will discover new patterns and approaches the longer you stick with it but you have to keep an open mind and keep exploring.

If you're looking for a book that helps you get beyond the mechanics of TDD, a book that shows you advanced patterns and helps you navigate tricky situations, this book might not be what you're looking for.

Here are some things that are **not covered** by _"Learning Test-Driven Development"_:

* How to introduce TDD in a legacy codebase. I recommend [Michael Feather's _Working Effectively with Legacy Code_](https://www.goodreads.com/book/show/44919.Working_Effectively_with_Legacy_Code) or the [Understanding Legacy Code Newsletter](https://understandlegacycode.com/) if this is important to you.
* How to deal with databases, caches, network calls? The book briefly introduces the (essential) concept of _Dependency Injection_ but doesn't go into too much detail. You might want to read [Mocks Aren't Stubs](https://martinfowler.com/articles/mocksArentStubs.html) for more details here.
* Advanced and nuanced patterns of test automation. Gerard Meszaros' _[xUnit Test Patterns](http://xunitpatterns.com/index.html)_ is a tried and trusted (but a little dated) pattern book that can help you here. You can also read a lot of the patterns online if you're curious about [Test Smells](http://xunitpatterns.com/Test%20Smells.html), [Organizing Tests](http://xunitpatterns.com/Test%20Organization.html) or how to work with [Test Doubles](http://xunitpatterns.com/Test%20Double%20Patterns.html) (Mocks, Stubs, Spies and Fakes).
* What are the limits of unit testing? When should you reach for different kinds of tests? And how do those fit into your TDD cycle? I tried capturing some of those thoughts in _[The Practical Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html)_ but this is a very nuanced discussion.
* How does TDD help drive more modular, decoupled designs? This is tangentially covered but you might long for a more in-depth discussion about cohesion, coupling, dependency injection and how TDD can be at the root of those. 

All of these topics are omitted on purpose. This book aims to teach new and seasoned developers alike how to get to grips with Test-Driven Development and does not try to go beyond that. It is a start of a very rewarding journey. And the good news is that learning the very basics will equip you with a very powerful mindset that you can immediately use and expand over the coming years to write more maintainable code.

## I heard TDD is dead. Why should I bother learning TDD today?

Yeah... no. Don't fall for [hyperbolic posts](https://dhh.dk/2014/tdd-is-dead-long-live-testing.html) meant to drive clicks and spark controversy. TDD is a tool that helps you think differently about the way you write code. I recommend you give it a try and see if it clicks for you. I'm convinced that TDD helps write you write better and more maintainable code like no other tool in your toolbox but you don't have to take my word as gospel. Learn it, play around with it, try to stick with it and see for yourself.

Initially it will feel unnatural. It will feel tedious. You might think your productivity is tanking and you will be tempted to go back to your tried and trusted way of writing code.

Stick with it. You will be grateful for your past self who has written automated tests when you come back to your code in the future. TDD will make it easier for your future self and your team members to read, reason about, and change your code for a long time. Over time you will learn that TDD is a tool in your toolbox. And as every other tool it has its limitations. If you are building a throwaway prototype, testing _might_ not be helpful. If you are spiking a new framework and have no clue how things fit together, testing _might_ not be helpful. On the other hand, you will be surprised to see how much TDD can help in prototyping and exploratory situations to provide a quick way of testing and asserting unknown behavior. As with every tool its best to get first-hand experience with TDD, learn where it falls short and take that as a chance to either reconsider your approach or reconsider your usage of TDD for this particular situation. Do not give up on TDD as soon as you hit the first obstacle. 


## My recommendation

_Learning Test-Driven Development - A Polyglot Guide to Writing Uncluttered Code_ keeps its promises.

1. It teaches you how to use TDD
2. It demonstrates TDD in three different languages
3. It emphasizes refactoring, cleaning up, and de-cluttering code as you go

It is as hands-on as it gets and you should treat this book as something to _work_ with to get the most out of it. Your mileage may vary if you're reading it back to back before going to sleep.

Saleem Siddiqui has written a modern and to-the-point version of Kent Beck's "Test-Driven Design by Example". Every developer who wants to pick up (or refresh) TDD skills will get a lot out of this book. If you're not willing to give TDD a chance because you already made up your mind that TDD sucks and you write better code without it, this book is not for you. If you allow yourself to tackle this book with an open mind, I promise that you will be rewarded with a new (or refined) tool in your toolbox -- a tool that I personally consider the most valuable one in my own developer toolbox. I was fortunate enough to learn TDD directly from Saleem earlier in my career and I'm excited to see that now everyone can get a similar experience by working through this book.
