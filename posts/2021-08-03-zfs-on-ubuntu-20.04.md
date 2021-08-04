---
title: Deploy ZFS on Ubuntu 20.04
date: 2021-08-03
tags: ubuntu, zfs, zraid, harddisk, file system
---

Several weeks ago, my 10 years old [2TB WD Black](https://www.amazon.com/Western-Digital-Caviar-Internal-Desktop/dp/B004CSIG1G) disk decided to gave up. It is a single drive and not was not running on RAID configuration. Some files are still salvageable, but some are not. I still can salvage some of my graduate school writing but my undergraduate thesis file was lost forever. Luckily i still have the printed version.

Well, its time to buy new storage devices. I decided to buy another new harddisk in pair for RAID 1 configuration. My budget is still not enought to obtain large capacity SSD. I obtained a pair of [4TB Toshiba X300](https://www.toshiba-storage.com/products/toshiba-internal-hard-drives-x300/) disks at my local e-commerce site at 110USD each. By the way, you have to be very careful when selecting new harddisk drive right now. This disk luckily still using PMR method for writing. Currently, most of cheap and high capacity disks write method are using SMR (Shingled Magnetic Recording) and not PMR (Perpendicular Magnetic Recording). SMR increase the disk capacity by overlapping new tracks with previously written tracks, In order to read those tracks, you need correction. The effect is reduced writing  speed, you have to do a bit of checksum and rewritten on the overlapping track. This practice are common before consumer got raged enough and issuing a protest to disk manufacturer. In the end, Seagate and Western Digital announce a list of their SMR and PMR product on their site. You can read a little bit about SMR and PMR disk on this [Arstechnica article](https://arstechnica.com/gadgets/2020/06/western-digitals-smr-disks-arent-great-but-theyre-not-garbage/). The SMR is not quite ideal for ZFS, which become my target for this new pair of disk.

## zfsonlinux : installing zfs modules and toolkit into Ubuntu 20.04

This new pair of Toshiba X300 will become my target for ZFS RAIDZ1. Well, why not using the traditional `mdadm` for Linux RAID ? First, i want to try ZFS because its a different animal. ZFS is a logical volume manager, a RAID system and a filesystem wrapped into one. In short, it will simplify your life. With correct tuning of ZFS recordsize, RAIDZ will also outperform traditional Linux RAID. Arstechnica has good article on [ZFS 101](https://arstechnica.com/information-technology/2020/05/zfs-101-understanding-zfs-storage-and-performance/), also [RAIDZ and traditional Linux RAID comparison](https://arstechnica.com/gadgets/2020/05/zfs-versus-raid-eight-ironwolf-disks-two-filesystems-one-winner/)

I used compile from source code method for this installation, because i want to try latest ZFS also to lazy to create debian package. I also used custom kernel from (Xanmod)[https://xanmod.org/]. Currently also to lazy to self compile kernel for my rig. My current kernel is `linux-5.13.7-xanmod1` 

Here are the steps you need to deploy zfs into your Ubuntu 20.04

+ install build dependencies
  - `sudo apt update`
  - `sudo apt install linux-headers-5.13-7-xanmod1 build-essential libblkid-dev zlib1g-dev`
+ get latest zfs source code from zfsonlinux github. its on v2.1.0 when i wrote this post
  - `mkdir zfsonlinux && cd zfsonlinux && wget https://github.com/openzfs/zfs/releases/download/zfs-2.1.0/zfs-2.1.0.tar.gz`
  - `tar zxf zfs-2.1.0.tar.gz`
+ compile zfs source code and install 
  - `cd zfs-2.1.0 && ./configure --prefix=/`
  - `make && sudo make install`
+ add zfs module to `/etc/modules-load.d/modules.conf`, so it can be loaded automatically during boot
  - `sudo su -c "echo zfs >> /etc/modules-load.d/modules.conf` 
+ done. zfs capability has been added into your kernel

## zfsonlinux : deploying raidz

+ Adding RAIDZ1 into your zfs pool can be done like this
  - `sudo zpool create [pool_name] mirror [pool_devices]`
  - `sudo zpool create fenrir-pool mirror /dev/sda /dev/sdb`
+ Import your newly create raidz. It will be automatically mount into a directory according your pool name
  - `sudo zpool import fenrir-pool`
+ Checking your pool status
    
    $ zpool status
      pool: fenrir-pool
      state: ONLINE
      config:
    	NAME         STATE     READ WRITE CKSUM
	    fenrir-pool  ONLINE       0     0     0
	    raidz1-0   ONLINE       0     0     0
	      sda      ONLINE       0     0     0
	      sdb      ONLINE       0     0     0
+ enjoy your raidz. one thing i have not succeeded is to automatically mount zfs pool during boot. i already set zfs cache, but its not help at all.
