#!/bin/bash

git submodule update --init
ln -s tommorow-theme/vim/colors/*vim colors/
cd $HOME
ln -s dotvim-new .vim
ln -s .vim/vimrc .vimrc
