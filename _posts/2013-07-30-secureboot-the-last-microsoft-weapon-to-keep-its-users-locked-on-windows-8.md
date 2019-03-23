---
date: 2013-07-30 02:05:47+01:00
layout: post
slug: secureboot-the-last-microsoft-weapon-to-keep-its-users-locked-on-windows-8
title: SecureBoot [The last Microsoft weapon to keep its users locked on Windows... 8]
categories:
- Issues
tags:
- Linux
- openSuSE
- Repair
- SecureBoot
---

Tonight let's talk a little about SecureBoot.

{% include more.html %}

Secure Boot is IMHO the worst thing that Microsoft did in the last 15 years, and we're talking about an era of Windows 98 [Epic Crash!], Windows Millennium [BUUgs] and Windows Vista [SLOOwness], and the first Service Pack of Windows XP, that introduced more bugs than that ones it has corrected. So it is IMHO a horrible thing that will never protect them against malware: done the law, found the trick. BUT! As Microsoft does every time a new component is introduced, every hardware producer install a copy of it in its UEFI firmwares, this leads to problems for most of the users in the dreamland of linux.

Thanks to Red Hat, Novell and Canonical (Fedora, OpenSuSE and Ubuntu), we stolen (making noise with money) a key from Microsoft and we can now successfully install in a GPLv3 way our preferred OS: GNU/Linux [I'm sorry RMS, I was going to write only Linux, don't flash me with a lightning].

I installed successfully openSuSE 12.3 on my Asus K55V with UEFI and SecureBoot, but tonight it stopped working after a reboot (!!). As I'm actually writing this blog post, you can deduce that I have solved my issue. Yes. I solved my issue. I'm fine thanks, my granny is greeting you.

What happened was that SecureBoot has forgotten all the non Microsoft keys [I always thought Microsoft could put a naughty joke in one of its core components, Bad Microsoft BAD] and the only way I found to repair was to enter in the repair system of the openSuSE DVD and to use efibootmgr to solve the things.

Before to do that I have to clear [it is not like a charm, some times, it won't clear anything, even after reboot] all the keys in the key store of the UEFI settings. I'm lucky to have this menu, others could be not-so-lucky as I was.

Then entering the repair mode I had to fire this command: _efibootmgr -c -L openSuSE -d /dev/sda -p 1 -l \\EFI\\opensuse\\shim.efi_.

Explain:
-c : means that efibootmgr has to create a new boot entry
-L : it is the name of the boot entry in the UEFI menu
-d : takes the block device in which the efi things and the OS resides
-p : could mean partition to someone, that are my guys!
-l : it keeps the loader with all the path, DOS-like [because this shit was written by Microsoft], starting from the root of the partition containing the efi code, in my case efi has its own partition, the first

Now if it happens to you, and you are not a Microsoft lover, you can repair (almost) easily the (UN)SecureBoot.

Oh well, I was going to forget, to see if you have SecureBoot enabled, on a running Linux system, run this command below, 1 as enabled, 0 otherwise:

_od -An -t u1 /sys/firmware/efi/vars/SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c/data._

I hope you will never need this page.
