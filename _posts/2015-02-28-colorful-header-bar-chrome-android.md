---
layout: post
title: Add Color to Chrome's Header Bar on Android Lollipop
tags: programming web
excerpt: Chrome on Android Lollipop offers a nice way for your website to set the color of the header bar. Let me show you how!
comments: true
---

If you're a Chrome user on Android Lollipop you might already have noticed. As someone who just
recently updated to Android Lollipop I discovered this this week: Chrome on Lollipop (from Chrome 39 onwards) allows your website to
change the color of Chrome's title bar.

The first time I noticed this was when I was browsing the [XDA Developers
Forums](http://forum.xda-developers.com/):

![XDA Developers using a colored titlebar in Chrome for
Lollipop](/assets/img/uploads/xda-colored-titlebar.jpg)

A couple of days later I saw Ars Technica using it for their dark theme (which really adds to the
whole reading experience on mobile in my opinion):

![Ars Technica showing off a colored titlebar to match their website's
theme](/assets/img/uploads/ars-colored-titlebar.jpg)

I wanted to add this effect to a little website I wrote this week, too. After short research I
figured out that this could easily be achieved by using the `theme-color` meta
tag on your website. Just define the meta tag in your header section, define the desired color and Chrome will take care to colorize the header.
The tag will take any hexadecimal or named color as its value:

    <meta name="theme-color" content="#663399">

or

    <meta name="theme-color" content="RebeccaPurple">

If you use this tag on your website, Android also uses the color in the app overview:
![Titlebar Colors in the App Overview](/assets/img/uploads/app-overview-titlebar-colors.jpg)

This is a very simple way to make your website stand out on Android devices and even increase the
whole User Experience of your website. So this little trick might come in handy for you in the
future.
