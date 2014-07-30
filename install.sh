#!/bin/bash

git submodule update --init
cd $HOME
ln -s dotvim-new .vim
ln -s .vim/vimrc .vimrc
