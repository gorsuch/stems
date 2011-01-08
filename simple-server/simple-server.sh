#!/bin/bash

aptitude update
declare -ar packages=( git-core
                       irb ruby rubygems1.8 ruby1.8-dev
                       libopenssl-ruby )
aptitude install --assume-yes "${packages[@]}"

gem install chef --version 0.9.12 --no-ri --no-rdoc

git clone git://github.com/gorsuch/sandbox_cookbooks.git /tmp/sandbox_cookbooks

export PATH=$PATH:/var/lib/gems/1.8/bin