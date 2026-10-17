# Conky theme, "Time_Clock_of_the_Heart"

<img src="./Chandanna_EndeavourOS_Qtile-my-local_2026-10-17_10-03-40.png" width=500 />


## Notes on using this theme


### 1. Regarding the fonts used

The following three types of fonts are used:

- [Ptolemy Font](https://www.1001fonts.com/ptolemy-font.html)  
  Used for the dial of a 24-hour clock
- [Bernardo Moda Font](https://www.1001fonts.com/bernardo-moda-font.html)  
  Used for the current time display at the top of the screen
- [Embolism Spark Font](https://www.1001fonts.com/embolism-spark-font.html)  
  Used in other text

If the font is changed, I suspect some fine-tuning will likely be required.
With this in mind, I have implemented certain aspects as external parameters or parameter values; however, I am not entirely certain how effective this approach will prove to be.

1. [./conky_global_const.lua](./conky_global_const.lua)  
  Definition of the font(s) used for this theme.
1. [./conky_my_config.lua](./conky_my_config.lua)  
  Settings for the fonts used in various components. I have endeavored to define literal values ​​here as much as possible.


### 2. **Important:** Regarding versatility

I have **NOT** taken into account the kind of versatility that would allow the product to be used by a wide range of people.
The reason is that the following is the theme I am actually using.  

**The following features are not enabled unless the configuration file is modified.**  
To enable this, activate the following flag for [./conky_my_config.lua](./conky_my_config.lua).
To enable this, you must set the flag for `Info.Text.Other.Other_display_flag` and/or `Info.Text.Other.Special_display_flag` within this file.


#### 2.1. Displaying the total number of packages and the number of packages currently available for update.

See the 3rd row in the figure below.

<img src="./Chandanna_EndeavourOS_Qtile-my-local_2026-10-17_10-04-29.png" width=400 /><br clear="all" />

In my case, since I am using *EndeavourOS*, this applies to *Arch Linux*.  
See [./conky_sub_parse.lua](./conky_sub_parse.lua), `Packages.checkupdates` and `Packages.checkupdates.packman_Q`.


#### 2.2. **Important:** Time elapsed since the PC was started, and time elapsed since the current login.  

See the 4th and 5th rows in the figure below.

<img src="./Chandanna_EndeavourOS_Qtile-my-local_2026-10-17_10-04-47.png" width=400 /><br clear="all" />

**These are entirely dependent on my environment**, I would like to standardize the display format for normalized dates.

First:  
For time normalization, I have implemented a separate Python routine as shown below.
Provide a number of seconds to this Python script, it will return a normalized time.  
See [my_python_sec_to_regular_time.py](https://github.com/dollplayer2501/dotfiles_ver3_terminal/blob/main/_bin/my_python_sec_to_regular_time.py)

Next:  
The number of seconds elapsed since the PC was booted is obtained by processing `/proc/uptime` with `awk` and passing the result to the aforementioned Python script.  
See [./conky_sub_parse.lua](./conky_sub_parse.lua), `Commands.Special.uptime`.

Additionally:  
The time elapsed since login is retrieved using the following Fish shell function that I created.
In other words, it obtains information from `last -1 -F $USER`.  
See [my_login_elapsed.fish](https://github.com/dollplayer2501/dotfiles_ver3_terminal/blob/main/fish/functions/my_login_elapsed.fish)  
And [./conky_sub_parse.lua](./conky_sub_parse.lua), `Commands.Special.login`.


## TODO

- Display the following information on a 24-hour clock:
    - [ ] Sunrise, sunset, and lunar data, retrieved via the *U.S. Naval Observatory* API, implemented in Python
    - [ ] Upcoming scheduled jobs, obtained using `systemctl list-timers --all` and/or `systemctl --user list-timers --all`, implemented in Python
- [ ] Information regarding the historical graph for CPU load:  
The design calls for a graph that follows the circular path of a clock face, extending inward from the 24-hour hand toward the center.
- [ ] Use *Pywal* to automatically change the color scheme for this theme?
- [ ] Nothing is decided yet, but perhaps adding some kind of feature triggered by a *mouse hover*?


- - -


## Motivation for development

- I have a massive, usable workspace measuring 1920x1080 pixels.
- To the question, "*But how are you supposed to see the time?*", I respond as follows:
    - You could just look at a (physical) clock.
    - Since I use *Qtile*—a tiling window manager—I can simply open a dedicated workspace for this display.
    - Thanks to transparency settings in *Picom*, I can see the background if I really want to (though it’s admittedly quite difficult).
    - While I am well aware of the current trend toward widget-based displays, this is simply what I want.

The environment I am actually using is as follows.

<img src="./Chandanna_EndeavourOS_Qtile-my-local_2026-10-17_10-12-23.png" width=300 />&nbsp;
<img src="./Chandanna_EndeavourOS_Qtile-my-local_2026-10-17_10-12-36.png" width=300 />&nbsp;
<img src="./Chandanna_EndeavourOS_Qtile-my-local_2026-10-17_10-28-14.png" width=300 />

In practice, I rely on the Qtile widgets (located on the bottom bar) to keep track of the current time, the number of available package updates, and the CPU load.
In other words, no issues will arise even if this theme is not displayed.

See also the following—specifically, my "dotfiles":

- [dotfiles_ver3_terminal](https://github.com/dollplayer2501/dotfiles_ver3_terminal)
- [dotfiles_ver3_window-manager](https://github.com/dollplayer2501/dotfiles_ver3_window-manager)

