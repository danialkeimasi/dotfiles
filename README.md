# Danial's Dotfiles

```
╱╱╭━━━┳━━┳╮╱╱╭━━━┳━━━╮
╱╱┃╭━━┻┫┣┫┃╱╱┃╭━━┫╭━╮┃
╱╱┃╰━━╮┃┃┃┃╱╱┃╰━━┫╰━━╮
╱╱┃╭━━╯┃┃┃┃╱╭┫╭━━┻━━╮┃
╭╮┃┃╱╱╭┫┣┫╰━╯┃╰━━┫╰━╯┃
╰╯╰╯╱╱╰━━┻━━━┻━━━┻━━━╯
```

I use Ansible for it's flexibility. The primary Ansible tasks can be found in [`roles/dotfiles/tasks`](https://github.com/danialkeimasi/dotfiles/tree/main/roles/dotfiles/tasks).

## Requirements

Install ansible and required collections:

```shell
sudo pacman -S python-pip python-packaging ansible
ansible-galaxy install -r requirements.yml
```

## Installation

Copy `.env.sample` to `.env` and configure environment variables. Then run the playbook:

```shell
./install.sh
```

You can pass ansible-playbook arguments to `install.sh`:

```shell
./install.sh --tags gnome
./install.sh --skip-tags fonts
```

The list of available tags is in `roles/dotfiles/tasks/main.yml`.

After installing, do not move dotfiles repository. If you did that, install once again.

## Manual Configurations

Below are some manual configurations that are either hard to automate or were not automated by choice.

### Wayland

#### Screen Capture on Wayland

To fix the black screen issue during screen sharing/recording in Wayland, read [this guide](https://wiki.archlinux.org/title/PipeWire#WebRTC_screen_sharing).

### HiDPI + Full HD Monitor in Gnome

For a multi-monitor setup with different DPIs:

1. Use Wayland.
2. Enable Wayland's experimental fractional scaling feature:
```shell
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
```

3. Navigate to `Settings -> Displays` and adjust the Scale for each monitor as needed.

### HP Printer Setup

Execute the following commands:

```shell
sudo pacman -S cups
sudo systemctl enable --now cups
sudo pacman -S hplip
sudo hp-setup -i
```

### Mapping the Xiao AI Button (redmikey)

References:

- [Mapping Scancodes to Keycodes](https://wiki.archlinux.org/title/map_scancodes_to_keycodes)
- [Keyboard Input Identification](https://wiki.archlinux.org/title/Keyboard_input#Identifying_scancodes)

My Xiaomi laptop's keyboard has a button for using Xiao AI in Windows,
but it was unusable in Linux. To use this button,
I found its scancode (`0x72`) and mapped it to a linux keycode.

To find the scancode, press the key and look for logs like this in `dmesg` output:

```
[ 8474.796476] atkbd serio0: Unknown key pressed (translated set 2, code 0x72 on isa0060/serio0).
[ 8474.796481] atkbd serio0: Use 'setkeycodes 72 <keycode>' to make it known.
```

Open list of linux keycodes and pick a keycode (e.g. `88`: F12):
```shell
cat /usr/include/linux/input-event-codes.h | grep KEY_
```
#### One-Time Mapping
```shell
sudo setkeycodes 72 88
```

#### Permanent Mapping

Create a systemd service and run the same command at startup.

### Fixing Default App for Dirs After Installing VSCode

If you experience an issue where directories open in VSCode instead of the default file manager after installing VSCode, this will reassigns the default application for handling directories back to the GNOME Nautilus file manager, effectively resolving the problem.

```shell
xdg-mime default org.gnome.Nautilus.desktop inode/directory
```

## References

- [Nerd Fonts](https://www.nerdfonts.com/)
- [Terminal Makeover Tips](https://www.roboleary.net/2021/06/09/give-your-terminal-a-makeover.html)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)

## Acknowledgments

This repository is a fork of [mjnaderi/dotfiles](https://github.com/mjnaderi/dotfiles). My initial setup was inspired by his work.
