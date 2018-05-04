#!/bin/bash
#be sure to call this script from where its located, ie do "./install.sh" do not "../install.sh"
#?TODO get omnisharp-vim working?

profile_file=".bashrc"
initial_pwd=`pwd`

echo "build-essential cmake python3-dev mono-devel npm git vim-nox vim" #python-dev
read -r -p "Are the above listed packages installed? [y/N] " response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ ]]
then
    cp -a ./vim/* ~/.vim
    #cd ~/.vim/bundle/
    #git clone https://github.com/Valloric/YouCompleteMe.git #TODO use git submodules... < these are rather confusing ATM..
    cd ~/.vim/bundle/YouCompleteMe
    #git submodule update --init --recursive
    ./install.py --clang-completer --cs-completer --js-completer
    [ -e ~/.bash_profile ] && mv ~/.bash_profile ~/.old_bash_profile|echo "backing up existing .bash_profile to .old_bash_profile..."
    cd ${initial_pwd}
    cp ./bash_profile ~/.bash_profile
    cd ${HOME}
    if ! [ -e ${profile_file} ]
      then
        touch ${profile_file} |echo "${profile_file} does not exist, creating..."
    fi
    if ! grep -q 'source ~/.bash_profile' "${profile_file}" ; then
        echo "Adding 'source ~/.bash_profile' to ${profile_file}"
        echo "source ~/.bash_profile" >> "${profile_file}"
    fi
    cd ${initial_pwd}
    [ -e ~/.vimrc ] && mv ~/.vimrc ~/.old_vimrc|echo "backing up existing .vimrc to .old_vimrc..."
    cp ./vimrc ~/.vimrc
    echo "logout and back in to complete setup (or '$ source ~/.bashrc')"
fi
