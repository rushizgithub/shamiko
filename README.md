# Shamiko

<center>こっっ…　これで勝ったと思うなよ―――!!</center>

### Introduction
Shamiko is a Zygisk module to hide Magisk root, Zygisk itself and Zygisk modules like riru hide.

Shamiko read the denylist from Magisk for simplicity but it requires denylist enforcement to be disabled first.

### Usage
1. Install Shamiko and enable Zygisk and reboot
2. Configure denylist to add processes for hiding
3. *DO NOT* turn on denylist enforcement

#### Whitelist
- You can create an empty file `/data/adb/shamiko/whitelist` to turn on whitelist mode and it can be triggered without reboot
- Whitelist has significant performance and memory consumption issue, please use it only for testing
- Only apps that was previously granted root from Magisk can access root
- If you need to grant a new app root access, disable whitelist first

### Changelog
#### 0.2.0
1. Support font modules since Android S
2. Fix module's description

#### 0.3.0
1. Support whitelist (enable by creating an empty file `/data/adb/shamiko/whitelist`)
2. Always unshare (useful for old platforms and isolated processes in new platforms)
3. Request Magisk 23017+, which allows us to strip Java daemon and change denylist regardless of enforcement status
4. Temporarily disable showing status in module description (need to find a new way for it)
5. Support module update since Magisk 23017

#### 0.4.0
1. Add module files checksum
2. Bring status show back
3. Add running status file at `/data/adb/shamiko/.tmp/status`

### 0.4.1
1. Add more hide mechanisms

### 0.4.2
1. Fix app zygote crash on Android 10-

### 0.4.3
1. Fix tmp mount being detected

### 0.4.4
1. Fix module description not showing correctly

### 0.6
1. Hide more trace of Zygisk

### 0.7
1. Support Magisk 26.0
2. Fix font loading
3. Hide more traces of Magisk

### 0.7.1
1. Merge Magisk and KernelSU branch

### 0.7.2
1. Fix a bug causing Zygisk on KernelSU failed to unload
2. Abandon a useless fix leading to more detection
2. Clean service.sh
