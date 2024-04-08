# my-desktop
## The base container for my Linux desktop machines
This repository uses [BlueBuild](https://blue-build.org/) to generate a custom operating system images, using [uBlue](https://universal-blue.org)'s [Fedora Atomic](https://fedoraproject.org/atomic-desktops/)-based base images as a starting point.

This project was inspired by [secureblue](https://github.com/secureblue/secureblue) and [wayblue](https://github.com/wayblueorg/wayblue).



## How it works
The `recipe` files in `config`are used to generate a `Containerfile`. A GitHub Action then automatically builds an OCI images based on this `Containerfile`. The ready to use image is then stored in the GitHub Container Registry. Finally, Fedora Atomic users can rebase the immutable part of their OS to this container image. This approach allows cloud/container tooling to be used for Linux desktop and should result in a more stable experience.

If you want to know more about this model, check out the [uBlue website](https://universal-blue.org).



## Features
A beautiful yet very functional "keyboard first" [Hyprland](https://github.com/hyprwm/Hyprland) experience.

*screenshots are comming soon*


### Configured programs
* Hyprland
* Waybar
* Wofi
* Kitty
* Wlogout
* Swayidle
* Swaylock
* Kanshi (See monitor setup)



## Usage
Even though this is a personal project, as of now this image is usable for people other than me. However, if you want to use this image for anything more than just checking it out, **I strongly recommend forking  this repository** instead of using it directly.

Because of the personal nature of this project, I can not and will not ensure anything. That means this repository could be totally different tomorrow than it is today. Additionally, while I try to merge only tested changes into the main branch, I do not guarantee for this image to be usable at all!

See the [BlueBuild docs](https://blue-build.org/how-to/setup/) for quick setup instructions for own repository if you do not want to forking this project.


### Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/timon-schwarz/my-desktop
```


### Installation
> **Warning**  
> [This project is based on an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

> **Warning**  
> This is also specifaclly talored for my PERSONAL needs.  
> I recommend forking this repository or [setting up your own](https://blue-build.org/how-to/setup/).

To rebase an existing Fedora Atomic installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```bash
  rpm-ostree rebase ostree-unverified-registry:ghcr.io/timon-schwarz/my-desktop:latest
  ```
- Reboot to complete the rebase:
  ```bash
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```bash
  rpm-ostree rebase ostree-image-signed:docker://ghcr.io/timon-schwarz/my-desktop:latest
  ```
- Reboot again to complete the installation
  ```bash
  systemctl reboot
  ```

> **Info**  
> The `latest` tag will automatically point to the latest build.  
> That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

> **Info**  
> The `br-dev-39` tag will automatically point to the latest dev build using Fedora 39.
> However, these tend to be very unstable however.


### Post installation

After installation, [yafti](https://github.com/ublue-os/yafti) might open. Make sure to follow the steps listed carefully and read the directions closely.

#### Monitors
Use `hyprctl monitors all` to get your monitor information.

Copy `/etc/xdg/kanshi` to `~/.config/kanshi` and adjust the configuration to your monitors.

Copy `/etc/xdg/hypr` to `~/.config/hypr` and adjust workspace to monitor binding configuration according to your monitors.

#### Nvidia

If you are using an nvidia image, run this after installation:

```bash
rpm-ostree kargs \
    --append=rd.driver.blacklist=nouveau \
    --append=modprobe.blacklist=nouveau \
    --append=nvidia-drm.modeset=1 \
    --append=nvidia.NVreg_PreserveVideoMemoryAllocations=1
systemctl enable nvidia-suspend.service
systemctl enable nvidia-hibernate.service
systemctl enable nvidia-resume.service
```

Then reboot your machine.

#### Nvidia optimus laptop

If you are using an nvidia image on an optimus laptop, run this after installation:

```bash
ujust configure-nvidia-optimus
```

Then reboot your machine.


### Dotfiles

This repository is the base of my Linux desktop machines. If you are interested in all my dotfiles check out [my dotfiles repo](https://github.com/timon-schwarz/my-dotfiles.git).



## Decision documentation
* This is the base of my Linux desktop machines. Therefore, only a minimal set of applications should be installed. I think of it as my own desktop environment. Other programs I need on top are handled by [my dotfiles repo](https://github.com/timon-schwarz/my-dotfiles.git).
* `/usr/share/my-desktop` is used in things that would normally go into `/usr/local` because the latter is a symlink to a directory that is wiped when building the image.
* `/usr/share/my-desktop/bin` is added to the `PATH` and used for scripts where manually running them in the terminal is a plausible use-case.
* `/usr/share/my-desktop/scripts` is used for scripts that are used by applications but are most likely not run manually.
* `/usr/share/my-desktop/wallpapers` is used for wallpapers.
* `/usr/share/my-desktop/colors` is used for color themes for **all** applications where a separate theme file is feasible. Even if the theme file can only be used by one application. 



## Known issues
* Some HDMI displays turn back on shortly after going to sleep. This could be an issue with AMD, Wayland or Hyprland. Because I currently do not use any HDMI displays, I will not try to implement a workaround.
* The blurred wallpaper is slightly offset in wlogout. I do not know why that is. Any hints appreciated.

