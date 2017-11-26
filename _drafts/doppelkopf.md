---
layout: post
title: A "Doppelkopf" Browser Game
tags: programming doppelkopf
excerpt: I started implementing a browser game version of the German "Doppelkopf" card game and it's great fun. Read why I started doing this and what I've discovered so far.
comments: true
---

I grew up in the countryside of northern Germany. Growing up sorrounded by woods and fields you get to appreciate some rather traditional, maybe even old-fashioned parts of German culture. One of these things is learning to play card games like [_"Skat"_](https://en.wikipedia.org/wiki/Skat_%28card_game%29) or [_"Doppelkopf"_](https://en.wikipedia.org/wiki/Doppelkopf).

I remember my father and my uncles playing Doppelkopf for countless hours every year when we visited my grandmother (also an avid Doppelkopf player) for Christmas. Later at school, people played Skat or Doppelkopf in their breaks. Going to the pub you could sometimes spot people playing these games as well.

![Die Skatpartie by Josef Wagner-Höhenberg](/assets/img/uploads/skat.jpg)
_"Die Skatpartie" by Josef Wagner-Höhenberg_


Luckily, I learned the complex rules of Doppelkopf from my parents when I was a child. We played here and there. I was good enough to internalize the basic rules but never good enough that I could challenge more experienced players. Try playing with your grandparents and you'll learn what losing looks like. After all, these folks have been playing that game all their lives. They've seen it all, have played every hand there is to play and recognize every tiny mistake you do. It's intimidating. 

Earlier this year, some friends asked me if I wanted to join their Doppelkopf group in Hamburg. Knowing the basics of the game I was excited to join. Now we're meeting once a week at a random pub or down at the harbour, have a beer or two and play Doppelkopf. It's great fun and a nice breakout from my otherwise overly digitalised daily life. Every now and then a stranger stops by to [kibitz](https://en.wiktionary.org/wiki/kibitz). They always seem fascinated or even nostalgic by the archaic scenery of people playing traditional card games these days.

Doppelkopf is a complex game. It has a lot of rules, exceptions from these rules and the occasional exception from these exceptions. It's best played with four players who form two different parties in each game (_Re_ and _Kontra_). It's all about taking tricks and getting the beter score for your party. To make it even more difficult, every group of players tends to have their very own set of extra rules. The game is full of jargon. For bystanders a conversation about the game simply sounds like a bunch of gibberish. Despite the steep learning curve it's really rewarding to learn the game. The countless hours of fun and socializing really make up for it.

![Playing Doppelkopf in Hamburg](/assets/img/uploads/doppelkopf.jpg)
_Playing Doppelkopf in a Cafe in Hamburg, not meant to be a shameless plug for Astra_

I have to admit that I kind of suck at Doppelkopf. My friends often kick my ass. I'm not good at memorizing all the special rules that are out there. I don't dare to play a _Solo_ because I know I'll screw up. I'm bad at tactics and I can't remember which cards have already been played in the current game. Fortunately Doppelkopf is a team effort and you rarely play on your own in a game. So my friends often make up for my lack of skills.

At one point I thought that I should have some practice to improve my game. As you might imagine, practising multiplayer game on your own is quite challenging. I looked out for Doppelkopf browser games and Android apps and sure enough there are plenty of them. Unfortunately almost none of them lived up to my expectations. They required you to register with your Facebook account, were full of ads or in-app purchases and required you to be online the entire time. I was rather looking for a no-frills, no-bullshit version. Something I could play as much as I'd like without being bugged with ads or having to fear about my personal activity being tracked with every step I take.

## I'll Build My Own Doppelkopf Game

Being a developer I obviously found the best solution for this problem. _"I'm gonna build this myself!"_ was my proclaimed goal. 

![I'll build my own game](/assets/img/uploads/doppelkopf-bender.jpg)
_Probably not blackjack and hookers though_

Yeah, right, because that always works so well. Having quite a track record for starting side projects that I never finish (who hasn't?) I know I'm probably lying to myself when I say that I'll definitely finish that one. Still, I decided to build my own game, mainly for two reasons:

  1. Implementing your own Doppelkopf game will teach you a lot about the game
  2. I don't get to do too much coding these days so a side project is more than welcome

I also found a niche for my game to live in. Seeing all the ad-infested bells-and-whistles games with social media integration out there, I knew I should build a game that has nothing of that. I thought about the great [2048 game](https://gabrielecirulli.github.io/2048/) and how often I used to play it on my daily commute because it was free, simple, didn't require any installation and allowed me to play even without an internet connection. I knew that my browser game should have similar goals. That's why I decided that the Doppelkopf game I'm building should be

  1. free (as in free beer), forever, no discussion
  2. Open Source, available for everyone to see, modify and learn
  3. without ads or in-app purchases
  4. easy to start, ideally just loading a website
  5. available and playable when you're offline

That's a lot. Especially the offline part is giving me a headache as this means I'd need to build an AI for the other players. I've never done that one before so that's going to be a nice challenge. Still, I'm certain that it's worth it. I want the game to be as open and respectful of the user as possible. No bullshit, no screwing up the users.

## Implementing the Game

Finding a tech stack was quite straightforward. As it should be an offline-first browser game there isn't much technology to choose from. Back in the days I could have chosen Flash. Luckily, these days are over. I don't want the user to install any plugins to play the game. They should just visit a website in their browser and be ready to play. This left JavaScript as the only option. It's understood by every browser out there and has matured significantly over the recent years.

I sensed my chance to refresh on my frontend JavaScript skills for this task. I knew I wanted to use the latest JavaScript features available but had to keep in mind that even modern browsers do not support all of these features yet. So I got my hands dirty and set up [Webpack](https://webpack.js.org/) and [Babel](https://webpack.js.org/) to allow me to write the latest ECMAScript and to transpile it to JavaScript that today's browsers can understand.

Fortunately I had a short-cut to understanding the setup of these tools. Peter Jang has written an excellent [introduction to modern JavaScript](https://medium.com/@peterxjang/modern-javascript-explained-for-dinosaurs-f695e9747b70) that got me up and running in a breeze.

## The Card Game Kata

I quickly noticed that writing a card game as code makes for a fantastic [code kata](https://en.wikipedia.org/wiki/Kata_(programming)). If you think of it as a domain modelling excercise it shapes up quite nicely.

  * A `card` has a `suite` and a `rank`
  * The `rank` of a card defines it's `value`
  * A `deck` consists of 40 `cards` [^1]
  * Each `player` has a `hand` of 10 `cards`
  * A `hand` can be _Re_ or _Kontra_
  * A `trick` goes to the `player` who played the highest `card`

And so on.

So far I've been busy capturing the essence of Doppelkopf in a domain model. With the help of [Jest](https://facebook.github.io/jest/) I worked on this in a strictly test-driven way. Being test-driven (and having set up a CI server) allowed me to work on my Doppelkopf game whenever I had a few minutes to spare. I could split the complex ruleset of Doppelkopf into hundreds of small-scoped bits and pieces that could be implemented within a couple of minutes. Having tests and a continuous integration server in place allows me to come back to where I left at any time.


I'm taking some extra care of massaging my domain model into a shape that's pleasant to use and easy to read. With a domain as tangible as a card game this has worked really well. Take a look at these code snippets to see what I'm talking about:


```javascript
test('a hand without queen of clubs is kontra', () => {
    const cards = [
        queen.of(suites.spades)
    ]
    const hand = new Hand(cards);

    expect(hand.isKontra()).toBeTruthy();
    expect(hand.isRe()).toBeFalsy();
});
```

```javascript
class Hand {
    // [...]
    value() {
        return this.cards
            .map(card => card.value)
            .reduce((acc, value) => acc + value, 0);
    }

    // [...]
}

test('hand has a value', () => {
    const cards = [
        queen.of(suites.spades),
        ten.of(suites.hearts),
        ace.of(suites.diamonds)
    ]
    const hand = new Hand(cards);

    expect(hand.value()).toBe(24);
});
```

These tests are easy to understand, even if you don't know the rules of Doppelkopf. They serve as a good documentation, make it easy for me to reason about small portions of the complex game at a time and the sum of these small portions add up to the wonderful game that is Doppelkopf.

## Moving on
Right now my card browser game is only a bunch of domain classes and tests. There's nothing visible and I'm not even talking about anything that's remotely playable yet. Still, this excercise has been so much fun for me and allowed me to work in a pace that keeps me motivated to move on, one simple rule at a time. The source code is already [available on GitHub](https://github.com/hamvocke/doppelkopf), feel free to check it out and track the progress.

There will be huge challenges further down the road. When I told my friends that I'm building a Doppelkopf game, they first raised the question how I wanted to build an AI for singleplayer mode. Actually, I don't have a clue. I've never done this before and don't know how to approach this. I guess there'll be some research for me to do and a long way until I have build something that is more clever than a bunch if `if-else` statements.

My friends also asked if there will ever be a multiplayer option for this game. This, however, is so far further down the road, that I'm not even thinking about it yet. I guess implementing multiplayer should be possible and is probably even easier than building a good enough AI. Still, for building a multiplayer version I'd first have to build a game that's at least somewhat playable.

I'm really excited about this side project. I'm in here for the challenge and hope that reasoning deeply about the game makes me a better Doppelkopf player after all. Let's see how long I can keep this project alive and let's keep fingers crossed that it doesn't end up at the side project cemetary like all the other things I've successfully abandoned.

Stay tuned!

<hr>
**Footnotes**

[^1]: At least in the version my friends and I play. We don't play with nines.
