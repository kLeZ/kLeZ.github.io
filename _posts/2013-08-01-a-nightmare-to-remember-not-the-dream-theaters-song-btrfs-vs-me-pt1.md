---
date: 2013-08-01 17:42:35+00:00
layout: post
slug: a-nightmare-to-remember-not-the-dream-theaters-song-btrfs-vs-me-pt1
title: A nightmare to remember -- not the Dream Theater's song -- [BTRFS vs. me -
  pt1]
categories:
- Issues
tags:
- btrfs
- change root partition
- Linux
- migrate filesystem
- openSuSE
---

Today I want to say a few words about BTRFS. Firstly I want to say that **this filesystem is awesome for functionalities**, I will use it as my filesystem again as soon as it will become stable. But, It is not yet stable, I tried and I fallen in front of his horrible performances.

Actually there are some problems on this filesystem that developers know in fact but, they are much more complicated to solve because most of them are normal behaviors of other functionalities. As an example in order to understand much better and quickly: there is a known issue of (obviously) horrible performances that I experimented by myself, it makes performance decrease whenever you use it because he want to write down all the data in the same time, he want also manage all the metadata at the same time, only because those data are in the same transaction (!!), and you cannot do anything to fix that behavior because it is not customizable AND this is the normal behavior of work for btrfs. Result: you have an awesome filesystem that decreases its performances more quickly than Windows, so it is hardly unusable, especially if you use it for the root partition.

A system cannot be so slow in 2013 so I ended up in a solution: I have to migrate my filesystem. I'm not a fan of passing data from a disk to another, I make a few bckups sometimes but not always, in fact this is a bad attitude, but that's me. SO.

In order to migrate the root filesystem (yes I had BTRFS for the root -- and home -- filesystem, I used to be a bad guy, huh) I used a slooooow but simple universal and powerful solution. The situation was aggravated by the fact that my laptop has secure boot and then the boot partition was very touchy. I used the well known live distro (any live distro could do this work, I used the openSuSE recovery system for that purpose) and so I logged in a shell. The rest are some commands, a cp, some other commands.

Anyway, here is what I typed:

I had to make a new partition of the same size or even better, so I resized the btrfs home partition of -200G in order to keep root filesystem very large.

_btrfs filesystem resize -200G /dev/sda4_

Then I created the new filesystem and after that I mounted old (as read only) and new root filesystems.

So I ran this command: __

_cp -bfrdvx --preserve=all --suffix=~-bak-newfs -t /newfs/ /old/{bin,boot,etc,lib,lib64,media,mnt,opt,root,run,sbin,selinux,srv,tmp,usr,var}_

It took a few to complete but as it finished I had all my old root copied in the new one. I omitted copy the home folder because I have a separate partition for that, but I copied boot because even if I have a partition for that some files needs to be copied in any case.

Explination:

_-b:_ means backup, cp makes a backup if it has to overwrite a file, as described in the man "_it works better with -f [force] and -r [recurse]_"

_-f & -r:_ means recurse and force overwriting if you find the same file on destination

_-d:_ this is the combination of two other switches, it means that cp cannot ever follow any link in the source and it should preserve the link attribute on the new filesystem, it is useful in our case because we want to keep everything even links to system libraries, kernels configurations and so on. We have a user friendly distro, not slackware, so we want to preserve the configurations made by the packagers of our precompiled software.

_-v:_ verbose, no words.

_-x:_ stay on this filesystem but, as described by man "_mount points are not worth_" [read that as if you were David Letterman].

_--preserve=all:_ means preserve all attributes, other than links (remember _-d__ switch?_)

_--suffix=~-bak-newfs:_ I chose only a suffix that I can remember of, later.

_-t /newfs/:_ oh well, I'm explaining cp, but you should know of the -t option, it sets the destination folder.

_/old/{bin,boot,etc,lib,lib64,media,mnt,opt,root,run,sbin,selinux,srv,tmp,usr,var}:_ the filesystem, without volatile folders. This a bash expansion, so it is not fully trusted to use it on a different shell.

Ended now?! No! You should go across other commands in order to recover your poor system. As it i now your new root don't knows how to start itself, it knows only how to start the old root. There are some files you have to edit in order to let the new root know about itself.

**/etc/fstab**

You have to edit the /etc/fstab of the new root because you have to change the mount device for / (root) mount point.

I assume you know how to modify fstab.

Then for the rest of configuration you have to chroot into the new root, so I bounded volatile filesystems (dev sys proc) and chrooted into the new root.

You have to fix two main things that are broken because of their reference to the old filesystem: bootloader and kernel, you mind that if you do not do that part, the system will not boot up.

In order to fix grub2 (I have grub2-efi so I make a guide on that, do not try to ask of lilo grub legacy or other BLs) I had to fire the command below:

_grub2-mkconfig -o /boot/grub2/grub.cfg_

So easy? Yes! Grub2 is composed of a bunch of useful scripts that detect automagically all the systems installed in the mounted partitions, and writes all the data into the grub.cfg. It's handy isn't it?

For kernel you have to pray all goes smooth as it did for me, in othre cases, _I saw errors that you humans will never see in your lives_.

This is the command: _mkinitrd_, if it works, good, anyway pray god it will autofix itself.

Once fstab, init ramdisk, and grub2 are all fixed you can try to exit the chroot and reboot your machine, optionally you can also delete the old root partition.

If it ended up smooth you should see grub2 loading, kernel loading and launching init, and the rest of the system run as normal, but with greater performance.

I hope they will fix those errors and make btrfs ready for the prime time as soon as possible, anyway I have btrfs for the home partition yet, so I have chances to try it out more and more.
