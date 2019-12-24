# Ubuntu setup automatization script


## Installation

```bash
git clone https://github.com/jkpark/dotfiles.git
cd dotfiles
./install -a
```

## Advanced Topics

### zsh font

my `zsh` theme is [powerlevel10k](https://github.com/romkatv/powerlevel10k) and it requires glyphs patch such like [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) and [Powerline](https://github.com/powerline/fonts). if you can not see glyphs correctly, change to the patched font.

### google-chrome 

if you are VM user, you may need to disable hardware acceleration to fix slow loading.


## Support IP and Proxy setup.

Run `setup_ip.sh` the automated setup script.

```
sudo ./setup_ip.sh
```
