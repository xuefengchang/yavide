#!/bin/bash
# yavide installation script

#####################################################################################################
# Settings
#####################################################################################################
YAVIDE_IDE_ROOT="/opt/yavide"

#####################################################################################################
# Plugins
#####################################################################################################

# Nerdtree
PLUGINS="$PLUGINS https://github.com/scrooloose/nerdtree"

# Session
PLUGINS="$PLUGINS https://github.com/xolox/vim-session"
PLUGINS="$PLUGINS https://github.com/xolox/vim-misc.git"

# Clang_complete
PLUGINS="$PLUGINS https://github.com/Rip-Rip/clang_complete"

# SuperTab
PLUGINS="$PLUGINS https://github.com/ervandew/supertab"

# Tagbar
PLUGINS="$PLUGINS https://github.com/majutsushi/tagbar"

# Airline
PLUGINS="$PLUGINS https://github.com/bling/vim-airline"

# A
PLUGINS="$PLUGINS https://github.com/vim-scripts/a.vim"

# Auto-close
PLUGINS="$PLUGINS https://github.com/Townk/vim-autoclose"

# NERDCommenter
PLUGINS="$PLUGINS https://github.com/scrooloose/nerdcommenter"

# CtrlP
#PLUGINS="$PLUGINS https://github.com/kien/ctrlp.vim"

# Grep
#PLUGINS="$PLUGINS https://github.com/yegappan/grep"

# UltiSnips
PLUGINS="$PLUGINS https://github.com/SirVer/ultisnips"

# Git
#PLUGINS="$PLUGINS https://github.com/motemen/git-vim"

# Pathogen
PLUGINS="$PLUGINS https://github.com/tpope/vim-pathogen"

# Nice color scheme (wombat)
SCHEMES="https://github.com/jeffreyiacono/vim-colors-wombat"

#####################################################################################################
# Root password needed for some operations
#####################################################################################################
echo -n "Enter the root password: "
stty_orig=`stty -g` # save original terminal setting.
stty -echo          # turn-off echoing.
read passwd         # read the password
stty $stty_orig     # restore terminal setting.


#####################################################################################################
# Check and install the prerequisites
#####################################################################################################

# Make sure we include the LLVM repo path
UBUNTU_VER=`lsb_release -sr`
if [ $UBUNTU_VER = "12.04" ]; then
	echo "$passwd" | sudo -S add-apt-repository 'deb http://llvm.org/apt/precise/ llvm-toolchain-precise-3.4 main'
elif [ $UBUNTU_VER = "12.10" ]; then
	echo "$passwd" | sudo -S add-apt-repository 'deb http://llvm.org/apt/quantal/ llvm-toolchain-quantal-3.4 main'
elif [ $UBUNTU_VER = "13.04" ]; then
	echo "$passwd" | sudo -S add-apt-repository 'deb http://llvm.org/apt/raring/ llvm-toolchain-raring-3.4 main'
elif [ $UBUNTU_VER = "13.10" ]; then
	echo "$passwd" | sudo -S add-apt-repository 'deb http://llvm.org/apt/saucy/ llvm-toolchain-saucy-3.4 main'
elif [ $UBUNTU_VER = "14.04" ]; then
	echo "$passwd" | sudo -S add-apt-repository 'deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.4 main'
else
	echo "Unsupported Ubuntu version! Exiting ..."
	exit;
fi

# Install required packages
echo "$passwd" | sudo -S apt-get update
echo "$passwd" | sudo -S wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key
echo "$passwd" | sudo -S apt-key add -
echo "$passwd" | sudo -S apt-get install libclang1-3.4 libclang-3.4-dev clang-3.4 lldb-3.4
echo "$passwd" | sudo -S apt-get install exuberant-ctags git silversearcher-ag build-essential cmake python-dev
[ -d $/home/$USER/.fonts ] || echo "$passwd" | sudo -S mkdir /home/$USER/.fonts
echo "$passwd" | sudo -S git clone https://github.com/Lokaltog/powerline-fonts.git /home/$USER/.fonts
fc-cache -vf /home/$USER/.fonts

#####################################################################################################
# Start the installation
#####################################################################################################

# Build the directory structure
[ -d $YAVIDE_IDE_ROOT ] || echo "$passwd" | sudo -S mkdir $YAVIDE_IDE_ROOT
[ -d $YAVIDE_IDE_ROOT/bundle ] || echo "$passwd" | sudo -S mkdir $YAVIDE_IDE_ROOT/bundle
[ -d $YAVIDE_IDE_ROOT/colors ] || echo "$passwd" | sudo -S mkdir $YAVIDE_IDE_ROOT/colors

# Copy the pre-configured stuff
echo "$passwd" | sudo -S cp yavide.desktop $YAVIDE_IDE_ROOT
echo "$passwd" | sudo -S cp yavide.desktop /home/$USER/Desktop
echo "$passwd" | sudo -S cp .ycm_extra_conf.py $YAVIDE_IDE_ROOT
echo "$passwd" | sudo -S cp .vimrc $YAVIDE_IDE_ROOT
echo "$passwd" | sudo -S cp -R sessions $YAVIDE_IDE_ROOT/sessions

echo "\n"
echo "----------------------------------------------------------------------------"
echo "Installing plugins ..."
echo "----------------------------------------------------------------------------"
cd $YAVIDE_IDE_ROOT/bundle

# Fetch/update the plugins
for URL in $PLUGINS; do
    # remove path from url
    DIR=${URL##*/}
    # remove extension from dir
    DIR=${DIR%.*}
    if [ -d $DIR  ]; then
        echo "Updating plugin $DIR..."
        cd $DIR
        echo "$passwd" | sudo -S git pull
        cd ..
    else
        echo "$passwd" | sudo -S git clone $URL $DIR
    fi
done

# YCM installation requires some more steps to be done
cd $YAVIDE_IDE_ROOT/bundle/YouCompleteMe
echo "$passwd" | sudo -S git submodule update --init --recursive
echo "$passwd" | sudo -S mkdir temp_ycm_build
cd temp_ycm_build
echo "$passwd" | sudo -S cmake -G "Unix Makefiles" -DUSE_SYSTEM_LIBCLANG=ON . $YAVIDE_IDE_ROOT/bundle/YouCompleteMe/third_party/ycmd/cpp
echo "$passwd" | sudo -S make ycm_support_libs
cd ..
echo "$passwd" | sudo -S rm -R temp_ycm_build

echo "----------------------------------------------------------------------------"
echo "Installing color schemes ..."
echo "----------------------------------------------------------------------------"
cd $YAVIDE_IDE_ROOT/colors

# Fetch/update the color schemes
for URL in $SCHEMES; do
    # remove path from url
    DIR=${URL##*/}
    # remove extension from dir
    DIR=${DIR%.*}
    if [ -d $DIR  ]; then
        echo "Updating scheme $DIR..."
        cd $DIR
        echo "$passwd" | sudo -S git pull
        cd ..
    else
        echo "$passwd" | sudo -S git clone $URL $DIR
	fi
done

# Make symlinks to scheme files
echo "$passwd" | sudo -S ln -s `find . -name '*.vim'` .

echo "----------------------------------------------------------------------------"
echo "Setting permissions ..."
echo "----------------------------------------------------------------------------"
echo "$passwd" | sudo -S chown $USER /home/$USER/Desktop/yavide.desktop
echo "$passwd" | sudo -S chown -R $USER $YAVIDE_IDE_ROOT

