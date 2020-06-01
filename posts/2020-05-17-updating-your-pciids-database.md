---
title: Updating Your pciids Database on Ubuntu 18.04
date: 2020-05-17
tags: ubuntu, amd, rx5600xt, pciids, usbids. gnu/linux
---

Well... during this work from home time, i need to upgrade my rig to support my work and also for some gaming. Upgrade the processor into more better one, with additional 16GB memory. I upgraded my processor into [AMD Ryzen 5 3600X](https://www.amd.com/en/products/cpu/amd-ryzen-5-3600x) from Ryzen 5 2400G. Additionaly, i also added RX 5600 XT from [Sapphire](https://www.sapphiretech.com/en/consumer/pulse-radeon-rx-5600-xt-6g-gddr6) as my GPU.

This buying was also become more interesting because [AMD Indonesia promotion](https://www.amd-id.com/2020/02/beli-produk-kartu-grafis-amd-radeon-dapatkan-bonus-game-kekinian/). If you buy Radeon RX 5500 XT / RX 5600 XT / RX 5700 XT, you will get two A+ games as a bonus. My RX 5600 XT supposed to be come with Monster Hunter World and Resident Evil 3. You can claim this bonus by sending AMD mail with proof of purchase. Too bad, the redemption processes weren't so good.

Well, if you go to [AMD Rewards site](https://www.amdrewards.com/), you'll be redirected into a download page for AMD Hardware Detection script. This script will probe your installation for registered AMD hardware. It is a proprietary shell script with some part encoded in binary. Plus, it has an age, after you download it, you must run the script within two hours or you have to redownload it again. Short story, after i finished download and executed,  it can not detect my RX 5600 XT installation. Why ? I don't know, some proprietary stuff failed to list my PCI tree perhaps. I already try to update my linux firmware installation from latest git kernel repository, because my running kernel 5.6 was complaining could not found several navi 10 radeon firmware. I also replaced my open source with proprietary driver from AMD site. Both with no result, the script still complaining that it can not detect any RX 5600 XT installation.

So, i decided to mail AMD support with my  lspci hardware list output. When i tried to run lspci to get my hardware detail, it can not correctly interpret my pci id.

`08:00.0 VGA compatible controller [0300]: [1002:731f] (rev ca) (prog-if 00 [VGA controller])`

It looks like i still used an old pciids database and need to update it.

A simple way to update your pciids database ( also usbids) are by executing _update-pciids_ ( or _update-usbids_ for usb database)

    tonny@fenrir:[~]: sudo update-pciids
    [sudo] password for tonny:
    Downloaded daily snapshot dated 2020-05-17 03:15:02
    tonny@fenrir:[~]: sudo update-usbids
    [sudo] password for tonny:
    --2020-05-17 17:18:33--  http://www.linux-usb.org/usb.ids

    Resolving www.linux-usb.org (www.linux-usb.org)... 216.105.38.10
    Menghubungi www.linux-usb.org (www.linux-usb.org)|216.105.38.10|:80... tersambung.
    Permintaan HTTP dikirimkan, menunggu jawaban... 200 OK
    Panjang: 617921 (603K) [text/plain]
    Simpan ke: `/var/lib/usbutils/usb.ids.new'

    /var/lib/usbutils/usb.ids.new 100%[=====>] 603,44K   344KB/s    in 1,8s

    ...

    Done.

Now _lspci_ can display my RX 5600 XT id correctly
![lspci](/media/lspci.png)

Now, i'm crossing my finger when sending AMD email on my lspci output. Hopefully they can process my request immediately.

Updated : I already claimed my free games from AMD on May 20th, 2020. Thank you AMD.
