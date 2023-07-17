# Shamiko

<center>こっっ…　これで勝ったと思うなよ―――!!</center>

### Introduction
Shamiko is a Zygisk module to hide Magisk root, Zygisk itself and Zygisk modules like riru hide.

Shamiko read the denylist from Magisk for simplicity but it requires denylist enforcement to be disabled first.

_Currently, system apps (with uid%100000=1000) cannot be hidden even it's in the denylist. This issue comes from Magisk._

### Usage
1. Install Shamiko and enable Zygisk and reboot
1. Configure denylist to add processes for hiding
1. *DO NOT* turn on denylist enforcement

#### Whitelist
- You can create an empty file `/data/adb/shamiko/whitelist` to turn on whitelist mode and it can be triggered without reboot
- Whitelist has significant performance and memory consumption issue, please use it only for testing
- Only apps that was previously granted root from Magisk can access root
- If you need to grant a new app root access, disable whitelist first

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

#### 0.4.0
1. Add module files checksum
1. Bring status show back
1. Add running status file at `/data/adb/shamiko/.tmp/status`

### 0.4.1
1. Add more hide mechanisms

### 0.4.2
1. Fix app zygote crash on Android 10-

### 0.4.3
1. Fix tmp mount being detected
