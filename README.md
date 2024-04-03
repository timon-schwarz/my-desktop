# my-desktop

See the [BlueBuild docs](https://blue-build.org/how-to/setup/) for quick setup instructions for setting up your own repository based on this template.

This repo uses [BlueBuild](https://blue-build.org/) to generate a custom operating system images, using [uBlue](https://universal-blue.org)'s [Fedora Atomic](https://fedoraproject.org/atomic-desktops/)-based [base image](https://github.com/ublue-os/main/pkgs/container/base-main) as a starting point.
For the nvidia build the nvidia [base image](https://github.com/ublue-os/hwe/pkgs/container/base-nvidia) is used as starting point instead.

This project was inspired by [secureblue](https://github.com/secureblue/secureblue) and [wayblue](https://github.com/wayblueorg/wayblue).


## Installation

> **Warning**  
> [This project is based on an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.  
> This is also specifaclly talored for my PERSONAL needs. I recommend [setting up your own repository](https://blue-build.org/how-to/setup/).

To rebase an existing atomic Fedora installation to the latest build:

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
  rpm-ostree rebase ostree-image-signed:ghcr.io/timon-schwarz/my-desktop:latest
  ```
- Reboot again to complete the installation
  ```bash
  systemctl reboot
  ```

> **Info**  
> The `latest` tag will automatically point to the latest build.  
> That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.


## Post installation

After installation, [yafti](https://github.com/ublue-os/yafti) might open. Make sure to follow the steps listed carefully and read the directions closely.

### Nvidia

If you are using an nvidia image, run this after installation:

```bash
rpm-ostree kargs \
    --append=rd.driver.blacklist=nouveau \
    --append=modprobe.blacklist=nouveau \
    --append=nvidia-drm.modeset=1
```

#### Nvidia optimus laptop

If you are using an nvidia image on an optimus laptop, run this after installation:

```bash
ujust configure-nvidia-optimus
```

### Dotfiles

To get my dotfiles follow these simple steps:
1. Install nix by following these [instructions](https://github.com/DeterminateSystems/nix-installer).
2. Install home-manager in standalone mode by following these [instructions](https://nix-community.github.io/home-manager/#sec-install-standalone).
3. Run the following commands in your terminal:

        ```bash
        git clone https://github.com/timon-schwarz/my-dotfiles.git ~/.config/home-manager
        home-manager switch
        ```

4. Restart your system.


## Customization

If you want to add your own customizations on top of this image, you are advised strongly against forking. Instead, create a repo for your own image by using the [BlueBuild template](https://github.com/blue-build/template), then change your `base-image` to this image.
This will allow you to apply your customizations to secureblue in a concise and maintainable way, without the need to constantly sync with upstream. 
Granted I still do not recommend this because I will be changing this image as I see fit for my PERSONAL needs.
 
## Verification

These images are signed with [Sigstore](https://www.sigstore.dev/)'s [cosign](https://github.com/sigstore/cosign). You can verify the signature by downloading the `cosign.pub` file from this repo and running the following command:

```bash
cosign verify --key cosign.pub ghcr.io/timon-schwarz/my-desktop
```
