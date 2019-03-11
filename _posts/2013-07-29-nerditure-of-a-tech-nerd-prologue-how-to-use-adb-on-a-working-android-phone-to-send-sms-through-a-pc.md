---
date: 2013-07-29 17:38:37+00:00
layout: post
slug: nerditure-of-a-tech-nerd-prologue-how-to-use-adb-on-a-working-android-phone-to-send-sms-through-a-pc
title: 'Nerditure of a tech-nerd: Prologue [How to use ADB on a working Android phone
  to send sms through a PC]'
categories:
- Android
tags:
- adb
- android
- bash
- sms
---

Hey all, this is the very first post of my blog and I want to thank myself for having decided, finally.

Today I needed to send a text message (S[mall]M[essage]S[ervice]) to my girlfriend, in order to instruct her on how to go somewhere in Rome (Italy) and grab a little thing for me.
There were a lot of informations to aggregate and I used EMACS, as I usually do, to keep them together. Grepped all the data from the Internet, placed on an EMACS new buffer, and cleaned some bytes here and there and the file is ready to be sent to her.

Now I have to copy all the text by hand on the phone and send the text... No wait! I'm a smart tech-nerd so I have to find a better way to do so. Well, Unix fan, a bash under my fingers, an android phone connected to my laptop.... "Can I send an SMS through an Android Intent by hitting some adb shell commands?" I thought and I replied instantly "YES!".

Long story short: At the bottom of this page you can find a link to my github.com repo where I put the code I used to send the text message. Note that this could not work for you, and that will not be my fault, even if it brokes up your device. It worked for me, not guaranteed it can work for you.

SO.

I searched the Internet, thanks Holy Google, and found out that I can launch an Intent via shell on android with _am start <something>_, a useful answer is on this stackoverflow question: [http://stackoverflow.com/questions/6613889/how-to-start-an-android-application-from-the-command-line](http://stackoverflow.com/questions/6613889/how-to-start-an-android-application-from-the-command-line). Hm, interesting. Then I searched the sendto intent in the Android documentation: here's a link [http://developer.android.com/training/basics/intents/filters.html](http://developer.android.com/training/basics/intents/filters.html).
Guessed other details [here](http://stackoverflow.com/questions/4043490/how-do-i-send-an-sms-from-a-shell) and [there](http://stackoverflow.com/questions/6980090/bash-read-from-file-or-stdin). The final script can be found in my git repo, below.

Here's the link for you: [https://github.com/kLeZ/lin-utils/blob/master/adb-sms-send.sh](https://github.com/kLeZ/lin-utils/blob/master/adb-sms-send.sh)

Enjoy!
