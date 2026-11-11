# Conky theme, "Time_Clock_of_the_Heart"


> [!NOTE]
> There may be slight differences between the images shown here and the results produced by the latest source code.


## 1. Overview

Conky theme, a 24-hour clock that uses the entire display.
It is not the hands of the clock that rotate; **the dial rotates**.

This is the screen that appears when you first launch this Conky theme.
Note, however, that the fonts used in this theme are highly unlikely to display correctly—for reasons explained later.

<img src="./screenshot/main..01.png" width=500 />

Left-click the white circle in the center of the screen.
Doing so will result in the view shown in the image below.
Left-clicking toggles the visibility of information such as the current time and today's date.

<img src="./screenshot/main..02.png" width=500 />


## 2. How to start


### 2.1. For those who want to get things up and running quickly.

In this case—as I will explain later—there is a possibility that the fonts, in particular, may not display as I intended.

1. Download the source code found here to your local PC in some way.
1. `sh `[`./start.sh`][start.sh]


### 2.2. (Operation has been verified.) For those who wish to customize this theme.

I have prepared various configuration settings—such as color schemes and visibility toggles—that I have not yet documented.  
In terms of the logic for this theme, the default [`./config/color_default.lua`][color_default.lua] and [`./config/config_default.lua`][config_default.lua] are assumed to always exist;  
If `./config/color_me.lua` and/or `./config/config_me.lua` are present, it will be loaded instead, and the default items will not be loaded.


#### 2.2.1. Adjusting the color scheme

Copy and rename [`./config/color_default.lua`][color_default.lua] to `./config/color_me.lua` (the filename is fixed), then modify `./config/color_me.lua`.


#### 2.2.2. Customization other than color schemes

Copy and rename [`./config/config_default.lua`][config_default.lua] to `./config/config_me.lua` (the filename is fixed), then modify `./config/config_me.lua`.  
However, changing the font settings might be a bit complicated (more on this later).
And I’ve made it possible to configure a rather excessive number of detailed settings, but I’m afraid I have no plans to document them…

> [!NOTE]
> The following explanation assumes that `./config/color_me.lua` and `./config/config_me.lua` exist.


## 3. Notes on using this theme


### 3.1. Regarding the fonts used

The following two types of fonts are used:

1. [Ptolemy Font](https://www.1001fonts.com/ptolemy-font.html)  
   Used for the dial of a 24-hour clock
1. [Bernardo Moda Font](https://www.1001fonts.com/bernardo-moda-font.html)  
   Used for the current time display at the top of the screen and other text.

If the font is changed, I suspect some fine-tuning will likely be required.
With this in mind, I have implemented certain aspects as external parameters or parameter values; however, I am not entirely certain how effective this approach will prove to be.

1. [`./lua/const.lua`][const.lua]  
  Definition of the font(s) used for this theme.
1. `./config/config_me.lua`  
  Settings for the fonts used in various components.


### 3.2. **Important:** Regarding versatility

I have **NOT** taken into account the kind of versatility that would allow the product to be used by a wide range of people.  
**The following features are not enabled unless the configuration file is modified.**  
Whether or not to display the item is toggled based on the `true`/`false` status of `Info.Text.Other.Other_display_flag` and/or `Info.Text.Other.Special_display_flag` in the `./config/config_me.lua`.


#### 3.2.1. Displaying the total number of packages and the number of packages currently available for update.

See the 3rd row in the figure below.
Set `Info.Text.Other.Other_display_flag` to `true` in `./config/config_me.lua`.

<img src="./screenshot/main..03.png" width=400 />

In my case, since I am using *EndeavourOS*, this applies to *Arch Linux*.  
See [`./lua/sub_parse.lua`][sub_parse.lua], `Packages.checkupdates` and `Packages.checkupdates.packman_Q`.
Here, the following command is being executed.

- `checkupdates | wc -l`
- `pacman -Q | wc -l`


#### 3.2.2. Time elapsed since the PC was started and time elapsed since the current login

See the 4th and 5th rows in the figure below.
Set `Info.Text.Other.Other_display_flag` and `Info.Text.Other.Special_display_flag` to `true` in `./config/config_me.lua`.

<img src="./screenshot/main..04.png" width=400 />

**These work in my environment, but I’m not sure whether or not they will work in yours.**  
The 4th and 5th rows use a custom Python script that is included with this theme.
These Python scripts have not been granted execution permissions.
They are being run using `python3 <full path>`.
See [`./lua/sub_parse.lua`][sub_parse.lua].

- [`./python/login_elapsed.py`][login_elapsed.py]  
  Use the `last` command to display the number of seconds that have elapsed since login.
- [`./python/sec_to_regular_time.py`][sec_to_regular_time.py]  
  Convert seconds into a time format. Using a short-form time notation. For example, "1wk 1d 1hr 1min".

The general processing steps for the 4th and 5th rows:

1. The 4th row, time elapsed since the PC was started  
   Execute `awk '{print $1}' /proc/uptime` from the command line and piping its output to [`./python/login_elapsed.py`][login_elapsed.py].
1. The 5th row, time elapsed since the current login  
   In Python, execute `last -1 -F $USER | awk 'NR==1{print $4, $5, $6, $7, $8}'` and calculate the resulting duration in seconds.
   This result is being piped to [`./python/login_elapsed.py`][login_elapsed.py].


## 4. TODO

- [x] [HIGH] A review of the script `require` mechanism, along with a major overhaul of how user-specific configurations and color scheme files are set up.
- [x] Should I also include the Python scripts used within this script?  
      **Unfortunately**, this also included a Fish shell script function that I had created. I’m not yet sure how to handle this; it would be a hassle to rewrite it from a Fish shell script into Python just for this one thing.
- [x] Creating a theme configuration file for public release
- [x] It looks too flat, so I’ll add some touches to give the text a three-dimensional appearance—much like creating drop-shadow lettering.  
      I had a hunch, but I did a quick check. Since this theme uses unnecessarily large text—which would likely lead to a slight increase in CPU load—I’m going to mark this as "pending" and consider it closed.
- Display the following information on a 24-hour clock:
    - [ ] Sunrise, sunset, and lunar data, retrieved via the *U.S. Naval Observatory* API, implemented in Python  
          **Using 'astral', a Python library for solar and astronomical calculations.**
    - [ ] Upcoming scheduled jobs, obtained using `systemctl list-timers --all` and/or `systemctl --user list-timers --all`, implemented in Python
- [ ] Information regarding the historical graph for CPU load:  
      The design calls for a graph that follows the circular path of a clock face, extending inward from the 24-hour hand toward the center.
- [ ] Use *Pywal* to automatically change the color scheme for this theme?
- [x] Nothing is decided yet, but perhaps adding some kind of feature triggered by a *mouse hover*?
      It is unclear whether *mouse hover* events can be detected in Conky/Lua; *mouse clicks*, however, can be detected.
- [ ] I would like to modify the system so that it can start using only the default configuration file I provide.   
      If a user creates a copy and modifies it, those custom keys and values ​​should take precedence.
- [ ] Represent 24 hours a day or 365 days a year using an arc.
- [ ] Once development has reached a relatively stable state, move management to GitHub issues.


- - -


## Motivation for development

- I have a massive, usable workspace measuring 1920x1080 pixels.
- To the question, "*But how are you supposed to see the time?*", I respond as follows:
    - You could just look at a (physical) clock.
    - Since I use *Qtile*—a tiling window manager—I can simply open a dedicated workspace for this display.
    - Thanks to transparency settings in *Picom*, I can see the background if I really want to (though it’s admittedly quite difficult).
    - While I am well aware of the current trend toward widget-based displays, this is simply what I want.

The environment I am actually using is as follows.

<img src="./screenshot/sub..01.png" width=250 /> <img src="./screenshot/sub..02.png" width=250 /> <img src="./screenshot/sub..03.png" width=250 />

In practice, I rely on the Qtile widgets (located on the bottom bar) to keep track of the current time, the number of available package updates, and the CPU load.
In other words, no issues will arise even if this theme is not displayed.

See also the following—specifically, my *dotfiles*:

- [dotfiles_ver3_terminal](https://github.com/dollplayer2501/dotfiles_ver3_terminal)
- [dotfiles_ver3_window-manager](https://github.com/dollplayer2501/dotfiles_ver3_window-manager)




[config_default.lua]: ./config/config_default.lua
[color_default.lua]: ./config/color_default.lua
[start.sh]: ./start.sh
[const.lua]: ./lua/const.lua
[sub_parse.lua]: ./lua/sub_parse.lua
[login_elapsed.py]: ./python/login_elapsed.py
[sec_to_regular_time.py]: ./python/sec_to_regular_time.py
