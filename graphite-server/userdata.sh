#!/bin/bash -x

function userdata() {
	aptitude update
	declare -ar packages=( git-core
	                       irb ruby rubygems1.8 ruby1.8-dev
	                       libopenssl-ruby )
	aptitude install --assume-yes "${packages[@]}"

	gem install chef --version 0.9.12 --no-ri --no-rdoc

	cp packet/etc/profile.d/ruby.sh /etc/profile.d/ruby.sh
	cp packet/ubuntu/* /home/ubuntu
	
	export PATH="$PATH:/var/lib/gems/1.8/bin"
	export RUBYOPT="-Ku -rubygems"

	git clone git://github.com/gorsuch/sandbox_cookbooks.git /tmp/sandbox_cookbooks
	chef-solo -c /home/ubuntu/solo.rb -j /home/ubuntu/node.json
}

userdata >> /var/log/userdata.log 2>&1