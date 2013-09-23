#!/bin/bash

git submodule update --init
cd /home/vjordan
mv dotvim-new .vim
ln -s .vim/vimrc .vimrc
