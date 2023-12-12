---
layout: post
title: "Book Review: “Tidy First?”"
tags: books programming
excerpt: My review of Kent Beck's “Tidy First?”, a short book on the "what", "when", and "why" of tidying code.
summary: My book review of Kent Beck's “Tidy First?”.
image: /assets/img/uploads/tidy-first.jpg
comments: false
---

Hardly any author shaped the way I think about software development more than Kent Beck. It took me a while to put the ideas in ["Test-Driven Development: By Example"](https://www.goodreads.com/book/show/387190.Test_Driven_Development) into proper practice, and once I did it changed the way I wrote code forever. [Extreme Programming](https://www.goodreads.com/book/show/67833.Extreme_Programming_Explained) (XP) and its focus on embracing inevitable change, keeping options open, staying flexible, pair programming and automated testing remains my favorite way to build software in an effective and sustainable way.

Kent Beck publishes ideas about software design on his ["Tidy First?" Newsletter](https://tidyfirst.substack.com). This newsletter is the source for his book *["Tidy First?: A Personal Exercise in Empirical Software Design"](https://www.goodreads.com/book/show/171691901-tidy-first)*. 
I only recently stumbled across "Tidy First?" and finished it last week. This is my review.

!["Tidy First?" book cover](/assets/img/uploads/tidy-first.jpg)

## What's "Tidy First?" all about?

Kent Beck introduces the concept of *tidyings*, tiny changes to the structure (not the behavior) of your code to make your code more manageable, readable, and flexible, one small change at a time.

Beck starts by explaining a number of distinct tidyings you can apply to your code every day. He discusses how tidyings, small *structural* changes, can make it easier to implement your next *behavior* change. And he explains how to avoid falling into the trap of tidying for the sake of tidying, keeping a focus on what's important to your users: a change in your code's behavior, not its structure.

The book comes in three parts.

1. **The "What"**: An introduction to the idea of *tidyings*, small structural code changes to support your next behavior code change
2. **The "When"**: An analysis *when* its best to apply tidyings as part of your workflow: before, during, or after a behavioral code change
3. **The "Why"**: An explanation how tidyings can lead to looser coupling, increased cohesion, and keep more options open for longer so that you can deal with change better

The first part is quick and fun. It explains how small changes like extracting code into helper functions, using guard clauses, or explanatory variables, can help make your code more readable. For the seasoned developer this might sound familiar. For developers new to the trade this will be practical and invaluable and give them a clear set of ideas to improve the code they encounter over their career. The first part reads like a modern, less dogmatic take on [Robert Martin's *"Clean Code"*](https://www.goodreads.com/book/show/3735293-clean-code).

The second part is where things get more spicy. Staying true to <abbr title="Extreme Programming">XP</abbr> principles, Beck highlights how tidying is about solving an immediate need, not thinking too far into the future. Tidying can be fun and make you feel like you're making progress, but the real thing you're after is changing the *behavior* of your code, not its *structure*. Or, to use Kent Beck's words:

> Tidyings are the Pringles of software design

One tidying often leads to another, and then another. You have to know when to stop.

Beck goes on to analyze whether its smarter to tidy *before* , *while* or *after* you change the behavior of your code. This central question explains why the book is called *"Tidy First?"*. The answer, as so often, can be boiled down to an *"it depends"* - and Beck's analysis is inspiring, especially for people who have a tendency to fall into the trap of cleaning up non-stop, or -- even worse -- not at all. 

The third and final part, the *"why"*, was my favorite. It's full of challenging ideas that connect the simple concept of "tidyings" to much larger, more systemic effects. Beck explains the concepts of *optionality*, the time value of money, coupling and cohesion. This analysis ties the seemingly innocent idea of cleaning up messy code to the fundamental idea that being able to deal with uncertainty and change is valuable, in a monetary sense. Systems that are easy to change are worth more. Things that are easy to reverse are preferable to things that aren't. A dollar today is better than a dollar tomorrow. Earning more money, sooner, with greater likelihood is good. Spending less money, later, with less likelihood is good.


## My Takeaway
Kent Beck's "Tidy First?" is a fun read full of insightful advice. If you've developed software for a while it will start out seeming obvious, maybe even too trivial, by explaining simple "tidyings". Don't skip those, let them be a reminder of simple changes you can do to make your code easier to work with. If you have never heard of the tidyings Beck explains in the first part, you're getting valuable advice for your entire career as a software developer. The last few years I hesitated recommending Robert Martin's "Clean Code" to newer developers as I found it too opinionated, too dogmatic, and too dusty from today's perspective. "Tidy First?" will be my go-to recommendation moving forward, not just due to the list of tidyings it explains but due to the insightful analysis around the "when" and "why".

The "when" and "why" parts are where "Tidy First?" goes way beyond a pattern book and starts hitting heavier. Part 2, the "when", helps appreciate when you've tidied enough and keep an eye on the actual goal, and it explains how pushing tidyings too far into the future can backfire. Both of these are traps I've found myself and others fall in over and over again. The grand finale, Beck's explanation of optionality, the time value of money, coupling and cohesion and how all of these work together to build valuable software are fascinating. These ideas aren't completely new to me as they're deeply rooted in XP and have always been key to the goal of *embracing change*. Reading them this clearly helped me better connect the dots and gave me new ways to think about software design.

Go ahead and read it if you haven't. It's a short, enjoyable read full of great ideas. It'll be worth it!

