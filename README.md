# linux-omen-module

blacklist the current running hp_wmi driver

run the fanset.sh after changing directories containing saurabh to your username

A timer function has been added for this; you can check how it works in the scripts


```bash
fan_max 0 - Turns off max fan mode
fan_max 1 - Enables max fan mode
```
For manual fan speed control, there is also an application called fan_speed which takes a hexadecimal value as input:

```bash
fan_speed [decimal_value_fan_speed]
```

Performance modes are now available and can be controlled via platform-profiles.

"⚠️ Important: If any of the provided executables or scripts contain references to $USER, please verify that it matches your system username. If necessary, replace $USER with your actual username to avoid runtime issues. "

Also, feel free to read through the executables/scripts — they are simple and easy to understand.

you can add sudo visudo commands 

replace saurabh with your username

saurabh ALL=(root) NOPASSWD: /usr/bin/systemctl start omenfan.service
saurabh ALL=(root) NOPASSWD: /usr/local/bin/fan_auto
saurabh ALL=(root) NOPASSWD: /usr/local/bin/fan_speed
saurabh ALL=(root) NOPASSWD: /usr/bin/tee /sys/devices/platform/hp-wmi/fancount
saurabh ALL=(root) NOPASSWD: /usr/local/bin/fanset.sh
saurabh ALL=(root) NOPASSWD: /usr/bin/systemctl restart fan_auto.timer

