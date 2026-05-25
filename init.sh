# Install zsh and oh-my-zsh
if ! command -v zsh &> /dev/null; then
  echo "Installing zsh..."
  sudo pacman -S zsh --noconfirm
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "zsh is already installed."
fi


# Install .tmux and tpm
if ! command -v tmux &> /dev/null; then
  echo "Installing tmux..."
  sudo pacman -S tmux --noconfirm

  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
else
  echo "tmux is already installed."
fi


# Install packer
if [ ! -d "$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
  echo "Installing packer.nvim..."
  git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
else
  echo "packer.nvim is already installed."
fi


# Backup ~/.config/nvim
if [ -d "$HOME/.config/nvim" ] && [ ! -d "$HOME/.config/nvim.bak" ]; then
  echo "Backing up existing ~/.config/nvim..."
  mv ~/.config/nvim ~/.config/nvim.bak
else 
  echo "~/.config/nvim backup already exists or not found."
fi


# Clone https://github.com/deleonn/.dotfiles
if [ ! -d "$HOME/.config/nvim" ]; then
  echo "Cloning dotfiles..."
  git clone https://github.com/deleonn/.dotfiles ~/.config/nvim
else
  echo "dotfiles already cloned."
fi

if [ ! -f "~/.tmux.conf" ]; then
  cp ~/.config/nvim/tmux/.tmux.conf ~/
else
  echo ".tmux.conf already exists."
fi

if [ ! -f "~/.tmux/tmux-sessionizer.sh" ]; then
  cp ~/.config/nvim/tmux/tmux-sessionizer.sh ~/.tmux/
else
  echo "tmux-sessionizer.sh already exists."
fi


# Install brave
if ! command -v brave &> /dev/null; then
  echo "Installing brave..."
  curl -fsS https://dl.brave.com/install.sh | sh
else
  echo "Brave is already installed."
fi


# Install plugins
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
  echo "Cloning zsh-syntax-highlighting plugin..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
  echo "zsh-syntax-highlighting is already cloned."
fi

if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
  echo "Cloning zsh-autosuggestions plugin..."
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
  echo "zsh-autosuggestions is already cloned."
fi


# Look for the `plugins=(git)` line in ~/.zshrc and replace it with `plugins=(git zsh-syntax-highlighting zsh-autosuggestions)`
echo "Replacing plugins..."
sed -i 's/^plugins=(git)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc

echo "Adding aliases..."
# Add useful aliases
echo 'alias dev="cd ~/Developer"' >> ~/.zshrc
echo 'alias d="docker"' >> ~/.zshrc
echo 'alias dc="docker compose"' >> ~/.zshrc
echo 'alias t="dev && tmux attach -t dev || tmux new -s dev"' >> ~/.zshrc
