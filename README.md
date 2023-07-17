# Shamiko

<center>こっっ…　これで勝ったと思うなよ―――!!</center>

### Introduction
Shamiko is a Zygisk module to hide Magisk root, Zygisk itself and Zygisk modules like riru hide.
Shamiko read the list of apps to hide from Magisk's denylist for simplicity but it requires denylist to be disabled first.
### Usage
1. Install Shamiko and enable Zygisk and reboot
1. Turn on denylist to configure denylist.
1. Once denylist is configured, disable it to activate Shamiko

### Changelog
#### 0.2.0
1. Support font modules since Android S
1. Fix module's description

#### 0.3.0
1. Support whitelist (enable by creating an empty file `/data/adb/shamiko/whitelist`)
1. Always unshare (useful for old platforms and isolated processes in new platforms)
1. Request Magisk 23017+, which allows us to strip Java daemon and change denylist regardless of enforcement status
1. Temporarily disable showing status in module description (need to find a new way for it)
1. Support module update since Magisk 23017
