---
layout: post
title: Remote Pair Programming Made Easy with SSH and tmux
tags: terminal programming
excerpt: For many developers pair programming is the way to go. But pairing often becomes challenging as soon as people working remotely come into the mix. With this simple SSH and tmux setup you can have a very simple but effective remote pair programming setup.
comments: true
---

[Pair Programming](https://en.wikipedia.org/wiki/Pair_programming) has found wide adoption in software development ever since it became popular with the rise of Extreme Programming and other agile development approaches. This practice where two developers are working on the same machine and the same task has some really neat advantages over working all by yourself. Working in pairs results in higher quality, spreads knowledge between your team members and ultimatively leads to a higher satisfaction. Sounds cool? Well, it is![^1]

However, pair programming often becomes difficult as soon as the development team is spread accross different locations. People might be working from home. Parts of your team might be located at a different office, maybe even in an entirely different country. 

It's 2015, the idea of pair programming has been around for more than a decade by now. This should be a solved problem. And luckily it is. There are different solutions for different needs. From fully fledged screen sharing solutions with integrated voice chat (like [Screenhero](https://screenhero.com/)) over shared [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing) to IDE and editor plugins like [Floobits](https://floobits.com/), there seems to be a nearly endless amount of solutions to this remote pair programming problem. 

Wow, that's a lot of stuff to sift through. I can't even tell you if those services are worth trying (I'll give them the benefit of the doubt, probably they are great for their respective case). Personally, I like to keep it simple. I like to keep control over what I'm doing. And, like many other developers, I like to work in my terminal and hack away in vim/emacs/nano (I'm not gonna start an editor war here!). Luckily, I have everything I need at my disposal. And most likely so do you!

A simple combination of **SSH** and **tmux** is everything we need to setup a really effective and lightweight remote pair programming environment. We can use all of our beloved command line tools with finely tuned dotfiles and pat ourselves on the back for working on our hacker credibility. I'm speechless!

If you don't feel familiar with tmux or need a quick refresh take a look at my [introductory guide to tmux](/blog/a-quick-and-easy-guide-to-tmux/).

## What are we going to do?
Lets imagine we have two protagonists, _Alice_ and _Bob_. They are two developers working together on a Clojure project. Alice is sitting in Hamburg while Bob is working in Chicago. They want to collaborate on a task and since they both love using emacs for their work in Clojure they decide to set up a lightweight shared terminal environment while talking to each other over [Mumble](http://wiki.mumble.info/wiki/Main_Page).

Alice and Bob connect to the same machine using SSH. They could use a dedicated pairing server that both of them `ssh` into. Setting up a server with SSH access on [DigitalOcean](https://www.digitalocean.com/) or [AWS](https://aws.amazon.com/) is a no-brainer nowadays. They simply add their _public keys_ to the `~/.ssh/authorized_keys` file and then can connect securely without needing a password.

Alternatively they can also designate Alice's or Bob's machine as the pairing host. In this case the respective other person has to `ssh` into the other dev's machine and they're ready.

Once they are connected to the same machine, they can make use of tmux's client-server architecture. tmux allows multiple clients to connect to the same sessions on a server (we've got all that session handling stuff covered in the [intro guide](/blog/a-quick-and-easy-guide-to-tmux/)). That's perfect for our plans. We can have one session that holds all the windows and panes and can connect one client for each developer. Easy!

## Simple Setup - Completely Synchronized
The simplest setup is using the exact same session with multiple tmux client instances. The following steps will get us there:

1. Alice and Bob `ssh` into the same server
2. Alice creates a new tmux sesssion: `tmux new -s shared`
3. Bob connects to that session: `tmux attach -t shared`

Please note that _"shared"_ will be the name of the session, feel free to give it any name you like. 

From here Alice and Bob can happily hack away on their terminal and make use of all the fancy features offered by tmux. They can create panes and windows, launch different command line applications and pair happily on their tasks. They can even detach from that session and return at any later point. Both will see the exact same output in their respective terminal window. 

![synchronized session sharing with tmux](/assets/img/uploads/ssh_tmux_simple.png)

But somehow Alice and Bob feel that this is not quite perfect. There are situations where they want to work on different stuff while still being in that session. But as soon as Alice switches to a different window to work on her tasks, Bob's terminal will also switch along.  

## Independent Window Switching
Instead of sharing the exact same session between multiple tmux clients, we can also create multiple session within the same window group. The result is similar to what we've seen above with one difference: Each developer can switch tmux windows indepentently. 

All contents of the windows will be synchronized between all clients. But each client can decide individually which window's content should be shown at the moment. This allows Alice and Bob to work independently on different tasks if they feel the need to do so. Whenever they want to go back to normal pairing they can switch back to the same tmux window and will see the same content again. 

The steps for this setup are a little different:

1. Again, Alice and Bob `ssh` into the same server
2. Alice, as usual, creates a new tmux session: `tmux new -s alice`. tmux will implicitly create a new **window group**
3. Bob does not join that same session. Instead he starts a **new session** and connects that session to the same **window group** as Alice's _"shared"_ session: `tmux new -s bob -t alice`

That's it. Now both can move between tmux windows independently. The content (including panes) within those windows will be synchronized between all clients.

![independent shared sessions with tmux](/assets/img/uploads/ssh_tmux_advanced.png)

If you want to get a feeling for what's happening behind the scenes you can simply look up what sessions and window groups have been created after Alice has created her session. A simple `tmux ls` will reveal what's happening:

    bob: 2 windows (created Mon Nov  2 22:51:24 2015) [80x23] (group 0) (attached)
    alice: 2 windows (created Mon Nov  2 22:50:36 2015) [80x23] (group 0) (attached)

As you can see, there are two sessions with their respective name. Both sessions are in the same group `(group 0)` and therefore share the same windows.

## Where do all the dots come from?

![dot pattern on window size mismatch](/assets/img/uploads/ssh_tmux_mismatch.png)

You might notice that occasionally you'll see a weird dot pattern in one of your terminals. Don't worry, nothing's broken. This dot pattern occurs if not all of you have the same terminal window size. Those with a bigger terminal window will see the dot pattern for that area where the bigger windows exceed the smallest window in that session. 

## Conclusion
To me this is a really nice and lightweight solution if you want to collaborate remotely. You can use it for pair programming, to troubleshoot issues on your servers together and much more. Surely there are restrictions for this solution. You are bound to the command line, there's no way around it. You also need to have a separate channel to talk to each other (which fits quite well in the "do one thing and do it well" philosophy if you ask me; there are multiple VoIP services or old school telephones out there). 

If you are looking for a one-stop solution, one of the previously mentioned tools and services might be better suited for you. 

One last honorable mention goes out to [tmate.io](http://tmate.io/). A couple of weeks ago [@kaeff](https://twitter.com/kaeff), one of my colleagues pointed out to me that this service does exactly what I've just described in this article. If you want to avoid the (quite small) hassle of connecting into one of your machines over ssh, tmate can give you a set up in an ad-hoc fashion easily.

If you have any further experience or opinions feel free to share them with us in the comments section!

# TODO
Proofread
compress images
check links
prevent linebreak in code snippets

<hr>
**Footnotes**

[^1]: just in case it's not obvious by now: I strongly believe in the benefits of pair programming. Ever since I joined ThoughtWorks I see the advantages on a daily basis. Your mileage may vary, though. There are tasks that greatly benefit from pairing while others (especially simple ones) could be better tackled by an individual developer.
