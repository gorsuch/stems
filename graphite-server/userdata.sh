#!/bin/bash -x

function userdata() {
	echo BEGIN USERDATA
	aptitude update
	declare -ar packages=( git-core
	                       irb ruby rubygems1.8 ruby1.8-dev
	                       libopenssl-ruby )
	aptitude install --assume-yes "${packages[@]}"

	gem install chef --version 0.9.12 --no-ri --no-rdoc

	cp packet/etc/profile.d/ruby.sh /etc/profile.d/ruby.sh
	. /etc/profile.d/ruby.sh
	
	mkdir -p /root/chef
	cp packet/chef/* /root/chef
	git clone git://github.com/gorsuch/sandbox_cookbooks.git /root/chef/cookbooks
	chef-solo -c /root/chef/solo.rb -j /root/chef/node.json
	
	cp packet/etc/rc.local /etc/rc.local
	echo END USERDATA
}

userdata >> /var/log/userdata.log 2>&1