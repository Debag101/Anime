#!/bin/zsh
set -e

sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed base-devel git linux-headers wget zsh

if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ..
    rm -rf yay-bin
fi

sudo pacman -S --noconfirm --needed \
    amd-ucode mesa vulkan-radeon lib32-mesa lib32-vulkan-radeon \
    networkmanager ntfs-3g bluez bluez-utils \
    pipewire pipewire-alsa pipewire-pulse wireplumber rtkit pavucontrol

sudo pacman -S --noconfirm --needed \
    hyprland xdg-desktop-portal-hyprland qt5-wayland qt6-wayland xorg-xwayland \
    sddm qt5-graphicaleffects qt5-quickcontrols2 qt5-svg

sudo pacman -S --noconfirm --needed \
    alacritty fuzzel waybar fastfetch htop btop swww gum cava cmatrix \
    thunar thunar-archive-plugin thunar-volman tumbler gvfs zip unzip rclone \
    flameshot grim copyq calc coreutils ripgrep ffmpeg wf-recorder gphoto2 \
    neovim python gcc github-cli php starship \
    obs-studio mpv krita kdenlive okular xournalpp rnote godot \
    kdeconnect wireguard-tools qbittorrent android-tools scrcpy \
    opentabletdriver

sudo pacman -S --noconfirm --needed \
    cmake pkgconf libglvnd glew glm freetype2 \
    wayland-protocols libxkbcommon alsa-lib libpulse \
    nlohmann-json glslang

sudo pacman -S --noconfirm --needed \
    ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-font-awesome

yay -S --noconfirm --needed \
    swaybg zen-browser-bin microsoft-edge-stable-bin vesktop-bin visual-studio-code-bin \
    spotify aseprite marktext-bin cloudflare-warp-bin protonvpn-gui \
    obs-backgroundremoval obs-pipewire-audio-capture-bin obs-gstreamer obs-vkcapture \
    droidcam v4l2loopback-dkms glslviewer

echo 'options v4l2loopback exclusive_caps=1 card_label="DroidCam"' | sudo tee /etc/modprobe.d/v4l2loopback.conf

sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
sudo systemctl enable sddm
sudo systemctl enable warp-svc
systemctl --user enable --now opentabletdriver.service

sudo chsh -s $(which zsh) $USER

if [ ! -f ~/.zshrc ]; then
    touch ~/.zshrc
fi

if ! grep -q "starship init zsh" ~/.zshrc; then
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

cd ~
if [ -d "Matuprland" ]; then
    echo "matuprland preinstalled."
else
    git clone https://github.com/Abhra00/Matuprland
fi

cd Matuprland
chmod +x ./install.sh
./install.sh

echo "config /etc/sddm.conf.d/wayland.conf"
