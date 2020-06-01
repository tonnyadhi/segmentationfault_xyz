---
title: Pulseaudio Setting for Echo Cancellation
date: 2020-06-01
tags: ubuntu, pulseaudio, wfh, work from home, echo cancel, video conference
---

During this pandemic situation, we engineers also doing their job from home. Also, with the help with good internet bandwidth (**damn you Telkom Indihome**), we are doing video call often. At last my 7 years old C130 Logitech Webcam can be put to use again. Yep, its not HD camera. Using it with one of Indonesia's largest (and sometimes slowest) broadband provider, seemed enough for now.

The problem came when i got complained for echo that happened during video call. I though this was because of the internal mic on my webcam. So, i grab a new [USB mic](https://www.tokopedia.com/invokerlist2/portable-microphone-mic-mikrofon-smule-usb-with-stand-sf-960b-4) at about 12 USD on local marketplace. Well, the problem still exist. It is impossible to isolate completely echo caused by background noises. except maybe in a recording studio.

[Pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) then come into rescue. It is a sound server , aka userspace mixer that accompany [ALSA](https://www.alsa-project.org/wiki/Main_Page) in kernel level. Most of modern GNU/Linux comes with it, enabling you to do "advanced operations" with your audio devices. [ArchLinux wiki](https://wiki.archlinux.org/index.php/PulseAudio/Troubleshooting) has a comprehensive guide on Pulseaudio configuration.

Apparently, Pulseaudio have [digital echo cancellation module](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/#module-echo-cancel) embedded within it. This module can do Accoustic Echo Cancellation and filtering your audio input. Pulseaudio on Ubuntu 18.04 also already come with it, but it not loaded when the service started. In order to activated it, you have to load it. Add this module into your Pulseaudio, via `/etc/pulse/default.pa`

    load-module module-echo-cancel use_master_format=1 aec_method=webrtc\
     aec_args="analog_gain_control=0\ digital_gain_control=1"\
     source_name=echoCancel_source sink_name=echoCancel_sink
    set-default-source echoCancel_source
    set-default-sink echoCancel_sink

After that, restart your Pulseaudio service

    $pulseaudio -k
    $pulseaudio --start

Wala, you'll have virtual microphone input (echo cancel sink) from your mic. Use that as your audio capture device. Here's mine:
![virtual microphone sink](/media/pulseaudio_echo_cancel.png)

Additionaly, you can also set your sound card sampling rate to minimize static noise from your microphone. My sound card has 48000Hz sampling rate, but default value in pulseaudio was 44100Hz Edit your `/etc/pulse/daemon.pa` for sampling rate adjusment.

    #sed 's/; default-sample-rate = 48000/default-sample-rate = 44100/g' -i /etc/pulse/daemon.conf

After that, you can restart your Pulseaudio service, and your new sampling rate has been applied.