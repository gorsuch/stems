#!/bin/bash

declare -ar packages=( git-core
                       irb ruby rubygems1.8
                       libopenssl-ruby libjson-ruby )
aptitude install --assume-yes "${packages[@]}"