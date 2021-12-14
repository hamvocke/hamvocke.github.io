---
layout: now
title: What I'm doing now | Ham Vocke
latest_update: 2021-12-13 08:46:00 +0100
---

# Now
_Last update: {{ page.latest_update | date_to_string }}_

Here's what keeps me busy at the moment. [what?](https://nownownow.com/about)

## 👨‍💻 Side Projects

### [Doppelkopf](https://doppelkopf.party)

My browser-based Doppelkopf card game is still under [active development](https://github.com/hamvocke/doppelkopf). Earlier this year [I hit a massive wall](https://github.com/hamvocke/doppelkopf/issues/62) when trying to shoehorn a multiplayer mode into the codebase that deliberately started out as a pure single-player game. I should've known better and resisted the temptation to half-ass a multiplayer mode that architecturally wouldn't fit too well to the core concept of the codebase.

After weeks and months of designing user flows and connection protocols, endless experiments with websockets, handling connections, building resilient reconnection behavior, and coming up with logic to establish a multiplayer game session I realized that all of this is just too damn tedious to do as a side project with the occasional hour to spare.

![game server sequence diagram](/assets/img/uploads/gameserver-sequence-diagram.jpg)

I learned a great deal about websockets and managing persistent connections with flaky wifi conditions and server restarts but ultimately gave up on those efforts. I grew quite frustrated about the project a while after and didn't feel like putting a lot of energy into it but that energy is slowly coming back. I've got a few new ideas to experiment with and there are still some features missing to make the current Doppelkopf game feature complete.

### Electronics

I started fiddling around with electronics and microcontrollers this year. Inspired by [this Adafruit project](https://learn.adafruit.com/flora-neopixel-led-skateboard-upgrade/overview) my daughter and I started designing and building a circuit to add LED lights to her longboard. I'm not much of an electronics person so I had to read up on a lot of basics, learn about circuit design, find the right components, prototype and experiment and do a lot of soldering. Progress has been slow but that's okay. My daughter and I worked on this together and I'm happy that I got her excited about this project and that we could spend some time together experimenting and coming up with new ideas.

![circuit diagram for the longboard illumination project](/assets/img/uploads/circuit.png)

This project helped me grow more confident about understanding basic electronics, soldering, circuit design, and reading datasheets. Currently, the microcontroller (a Raspberry Pico) and LEDs are all wired up, soldered in place and ready to be attached to my daughter's longboard. The next step is to figure out how to get everything water-proof and properly attached to the longboard.


## 📚 Reading
The last 3 books I've read, most recent at the top.

### _The Manager's Path_ by Camille Fournier 

Over the years I often found myself at the intersection of building software and making teams run smoothly. _The Manager's Path_ has been on my to-read list for a while and I'm happy I picked it up. It's both, a great way to look at what could be ahead when taking over more management duties, as well as a great guide on how to be good in your current technical leadership role. [more info](https://www.oreilly.com/library/view/the-managers-path/9781491973882/)

### _Fundamentals of Software Architecture_ by Mark Richards & Neal Ford

Stack Overflow is growing. As we hire more engineers, grow existing teams and establish new ones, it becomes more and more pressing to make sure that changing our codebase remains a smooth process. Organizational growth needs an architecture that allows multiple teams to do their work without stepping on each other's toes. It needs guiding principles that makes it easy for us developers to make the right decisions. I'm diving into a lot of architecture-related literature lately, revisiting classics like _Domain-driven design_ but also the relatively recent _Fundamentals of Software Architecture_ to gather ideas and balance trade-offs about how we might shift our architecture to allow for more sustainable development and growth in the future. [more info](https://www.oreilly.com/library/view/fundamentals-of-software/9781492043447/)

### _If It Bleeds_ by Stephen King

I try to be mindful about my reading. I often find myself reading lots of technical books outside of work. This is a double-edged sword: It's fun to learn something new. It's amazing to re-learn something I've known before and apply it to my current context. Yet, it usually keeps me thinking about work much longer than I should; and it often keeps my mind spinning while I'm trying to sleep.

I can't say that I'm a big fan of Stephen King but his books tend to be a kind of default choice whenever I need some fiction in my reading diet. _If it bleeds_ is a collection of short stories. I enjoyed the suspense and mystery in _"Mr. Harrigan's Phone"_ and _"Rat"_. The title story, on the other hand, felt like a drag to me. [more info](https://en.wikipedia.org/wiki/If_It_Bleeds)

