---
layout: post
title: Doppelkopf — 3 Years Later
tags: doppelkopf programming
excerpt: 3 years ago I started building a browser-based Doppelkopf card game as a pet project. Things have been quiet. Did I give up? Hit a roadblock? Nuke the git repo?
summary: Is this thing on? 3 Years ago I started building a browser game as a side project. Here's what happened.
image: /assets/img/uploads/doppelkopfSocialMediaPreview.jpg
comments: true
---

Almost exactly three years ago, I wrote [an announcement]({% link _posts/2017-11-26-doppelkopf.md %}) about a new side project I started working on: **Doppelkopf**, a browser-based version of the popular German card game with the same name.

I've been quiet about its progress ever since. It's not like I've written lots of other stuff either, but I've also been quiet about _that_ project in particular. You might be wondering about the project's fate. Did I give up? Hit a roadblock? Nuke the entire Git repository by accident?

Nope, none of it! Almost 3 years and over _1024 commits_ later [the project](https://github.com/hamvocke/doppelkopf) is still alive and kicking and, just like when I started out, it continues to be a lot of fun to build.

_Hey you&hellip; If you're just here looking for the **Play the Game** button: Here it is. But you've gotta come back and read on, you hear?_

<a href="https://doppelkopf.ham.codes" target="_blank">
<img src="{% link assets/img/uploads/doppelkopfTeaser.png %}" alt="game teaser" />
<em>Go ahead, play the game right here</em>
</a>

Contributions haven't always been steady. Life happens. I [changed jobs]({% link _posts/2019-04-05-moving-on.md %}), moved to the countryside, got married, bought a house, got [a fluffy coworker](https://twitter.com/hamvocke/status/1294311723520983041), baked at least a dozen really decent pizzas, wrestled a dinosaur, a lot of grown-up stuff. I'm trying to get my priorities straight and a browser-based card game surely doesn't take the pole position in my life (sad, I know). 

When daily life gets more calm, it's my own meandering that gets in the way of steady progress. I like it that way since I'm partially this project to get my hands dirty with technology I'm curious about and to escape from the everyday chaos.

Sometimes I feel bad for not getting something usable out there sooner but then I remember that no one out there gives a damn because it's not on anyone's radar anyways.

I've meant to write an official update, an announcement of sorts, for at least 2 years now. Never wrote it. Mostly because I felt that the game just wasn't ready yet. _"Just these three more features, then we'll write the announcement"_ I'd keep telling myself. 

Yes, I know the _The Lean Startup_ says that I should get stuff out while I'm still embarrassed or I've waited too long. My job at ThoughtWorks consisted of reminding people that releasing frequently and getting user feedback early is super-duper important. I've used lofty words like [_"MVP"_](https://en.wikipedia.org/wiki/Minimum_viable_product) unironically. All that only to ignore what I'd know better.

And you know what? It doesn't matter. We're not trying to be the _Uber for niche card games_ or the _Tinder for people who can hold 10 cards in their hand while drinking a beer with the other_. There's no rush, no deadlines, no pressure. Just a blissful journey towards creating an Open Source card game; and maybe one day someone has fun playing it.

Now that I've explained that slacking is cool when **I** do it, let's move on and look at the things that have changed since I wrote the first few lines of code 3 years ago, shall we?

## Basic gameplay

When I wrote the first blog post about this project, I didn't have much more than a bunch of unit tests and primitive game logic in place. You could create cards, sort them, find out if one card beats another card. Low-level building blocks, only held together by unit tests.

Fast forward to today and we've got a playable single-player game in place, presented with a decent user interface. You can start a game, play multiple rounds, win a game, lose a game (the computer players are crap - you better win this, my friend!), get extra points for _catching a Fox_ or _winning a Doppelkopf_ and get correct scores after each round.

![Doppelkopf gameplay]({% link assets/img/uploads/doppelkopfGameplay.png %})

Yes, the experienced Doppelkopf aficionado will immediately notice that some things are still missing: You can't play a solo. You can't make any announcements. The computer players (think I should start calling them **AI** and score millions in venture capital?) make questionable moves. And yet it's fun to play already.

## User interface
The game's got an interactive user interface powered by plain old HTML, CSS and Vue.js. When you build a browser game, one of the fundamental decisions to make is how you want to render your user interface. You get a few choices:

* use the good old [DOM](https://en.wikipedia.org/wiki/Document_Object_Model) and reap the benefits that decades of web development have brought us, including CSS and all its clever layout technologies (`flex` and `grid` are heaven-sent)
* render everything in [Canvas](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/canvas) if you favor low-level control and don't want the comforts of CSS or need extra performance
* use [WebGL](https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API) if you want to get _really_ fancy
* write everything in Flash and publish your game on newgrounds.com (just kidding, this isn't 2003. Seriously, don't do this!)

Doppelkopf is not a fast-paced 3D action shooter. We're not rendering a lot of flashy animations nor do we care about high performance to let 4 players play one card turn by turn. On the contrary, we're mostly dealing with rectangular shapes (cards), some icons and text that need to be moved around the virtual table neat and orderly. And this is where CSS and HTML are a great combo.

With Vue.js we can add a good amount of interactivity to handle simple interactions like "clicking on a card" or "pressing a button". On top of that, its reactive programming model makes it really pleasant to represent the inner state of the game in the user interface without having to do any DOM manipulation by hand.

I decoupled the game logic from the user interface logic as strict as I could. The game is running entirely client-side, so both the game logic as well as the user interface are written in JavaScript. This makes it easy for the game logic's and user interface's boundaries to bleed into each other, making things harder to reason about in the long run. 

Using a strict test-driven approach to developing the game logic helped keep these boundaries in place as it allowed designing APIs that are usable from tests only without any user interface in place. This way the game logic becomes its own, very expressive and isolated layer in the code that can represent the entire game's state and behavior in plain old JavaScript. Vue.js is taking care of the user interface representation only and builds the components that allow us to display information and react on user input. I'm really happy about this strict separation as it makes testing painless and allows us to steer away from tedious state-management libraries like Vuex. 

## Design
My Kryptonite! The game doesn't look like ass, and that's the most positive thing you'll catch me say out loud. Somewhere deep down I know that the game's visual design is _okay_ - the color scheme is decent and doesn't look like [Hot Dog Stand](https://blog.codinghorror.com/a-tribute-to-the-windows-31-hot-dog-stand-color-scheme/), I've used some rather smooth CSS animations, and I've made sure to check some accessibility aspects that I know of. This isn't meant to be fishing for compliments but when it comes to visual design, I'm incredibly picky yet unable to produce something great by myself.

This is why improving the visual design of the game is a massive time sink for me. I've spent days finding and tweaking colors on [coolors.co](https://coolors.co/) and [Color Hunt](https://colorhunt.co/). I've searched, sketched, scribbled logos more than I can count, only to come up with... two overlapping cards? Well, at least it's all CSS and has got a slick hover animation!

![the animated Doppelkopf logo]({% link assets/img/uploads/doppelkopfLogo.gif %})
_Whoop whoop! It moves!_

I'm okay with where we're at right now but I know that there's so much room for improvement. I want to break out of the bleak and ordinary look of the game and make it a little more fun, a notch more quirky. I'd love to use illustrations, print stickers and card decks and send them out to players, contributors, or project sponsors - but I think I'll need some help there.

## Infrastructure
This is a simple system. We're not building a cloud-native, webscale, serverless event-driven microservice architecture (I really tried with the buzzwords here).

We're talking about a backend process in Python that we need to run on a server, and we're talking about a bunch of HTML, CSS and JavaScript that we need to get to our users' browsers. And strictly speaking, right now it doesn't even matter if the backend wasn't available 24/7 (and it'd be cool if it stays that way in the future).

As much as anybody else I'm a big fan of keeping things simple. At the same time, I want to take this project as an opportunity to learn a bunch of new things. So we've gotta balance things to avoid falling off a cliff.

I've set up enough build pipelines and server infrastructure to know what it takes to get software out to production in an automated and repeatable way. At the same time, building servers, dealing with networking, watching build pipelines and provisioning scripts to finish and working on all the plumbing and duct tape required to combine these aspects is something that makes me consider quitting my developer life and moving to a farm at least three times a year.

For Doppelkopf's infrastructure I wanted to find a pragmatic middle-ground. Something more modern than a hand-crafted snowflake server running in my mom's basement. And certainly something less ridiculous than a full-fledged Kubernetes cluster running in a multi availability-zone setup with a global CDN in place. Let's get some users first before we drown ourselves in infrastructure debt, shall we?

With all the noise and hype in our industry I found it incredibly hard to find the sweet spot and not fall for the siren sounds of cloud vendors and tool builders out there. Ultimately, I've ended up with this setup:

* [Terraform](https://www.terraform.io/) is automatically spinning up the infrastructure - servers, domains, networking and very basic provisioning
* The Terraform configuration comes as an extra Git repository. Whenever I push changes there, a [CircleCI](https://circleci.com/) pipeline will automatically build a new environment and deploy the application
* Everything's running on a single instance of the cheapest server you can get on [DigitalOcean](https://www.terraform.io/)
* The backend and frontend applications are built as [Docker](https://www.docker.com/) images and pushed to a Docker registry with every change (again, a CircleCI build pipeline kicking in)
* For deployment I `ssh` into the target servers, pull both images from the Docker registry and start them with a simple `docker-compose up`
* [Caddy](https://caddyserver.com/v2) takes care of setting up HTTPS using [Let's Encrypt](https://caddyserver.com/) and serving the applications

This setup is simple and effective. And most importantly: It's fully automated. This way, I can work on infrastructure after not touching it for months without having to curse my past self for what they've done. 

Yes, there are obvious shortcomings: no load balancing, no redundancy, no sophisticated content delivery networks involved. And you know what? At this point in time I couldn't care less. All of these are the kind of problems to solve once you've got enough users playing your damn game. Before that happens, I'm not going to lose any sleep over my lack of redundancy for serving something's that's basically a silly static website.

## A <del>boring</del> <ins>mature</ins> tech stack
Remember how we all made the same lame joke about the JavaScript ecosystem? The one where the popular JavaScript frameworks change every other week? Yeah, I do remember and I'm totally guilty of that.

When I started this project, I placed a few technology bets and - believe it or not - they've held up nicely: Modern JavaScript, Vue.js, Jest, Python and Flask, Terraform, Docker are the main drivers.

None of these were risky bets when I made them. And that's precisely the point: I chose mature and [boring technology](http://boringtechnology.club/) and I'm certain that this is why I still keep pushing 3 years later. Vue.js had been around for a good while. With [vue-cli](https://cli.vuejs.org/) you get scaffolding with sane defaults to get started easily with an ecosystem that can quickly be overwhelming. JavaScript has matured significantly since its early days and with Babel and Webpack set up you don't have to worry about compatibility all that much. Needless to say that Flask and Python have been a sane choice for the backend as well. The backend doesn't do much more than provide a simple REST API and a few admin screens so pretty much every web framework out there would've done the job, but Python and Flask have been practical and pleasant to use, so there's that.

That's not to say that all of these technologies were rainbows and unicorns at all times. JavaScript - of course - continues to have its quirks and larger-scale refactorings are beginning to become tedious. Wrestling Webpack configuration has made me swear like a sailor more than once. And sometimes I wish I'd just bite the bullet and use a simple PaaS solution like Heroku to deal with all my infrastructure worries. But all of those are concerns that future Ham can deal with.

## The road ahead
A lot has happened and the project has seen slow but steady progress. There's still a lot of work to be done and I try to be transparent about the road ahead. I maintain a [Product roadmap](https://github.com/hamvocke/doppelkopf/projects/1) on GitHub for everyone to see. I'm excited about contributions of any kind (issue reports, documentation, design, feature ideas, code, you name it!) and I'm trying to make the project as welcoming as I can. If you want to join, be my guest. I'd be glad to have you!

[![the product roadmap]({% link assets/img/uploads/doppelkopfRoadmap.png %})](https://github.com/hamvocke/doppelkopf/projects/1)

Now that I finally got this heartbeat out in the open, I plan to write more regular updates with more detailed topics on specific aspects of the project in the upcoming weeks. Watch this space, [check out the game](https://doppelkopf.ham.codes) and if you feel adventurous, come join me over [on GitHub](https://github.com/hamvocke/doppelkopf)!


