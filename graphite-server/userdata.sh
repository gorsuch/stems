#!/bin/bash -x

export CHEF_ROOT=/root/chef
export COOKBOOK_REPO=git://github.com/gorsuch/sandbox_cookbooks.git

function create_files() {
mkdir -p $CHEF_ROOT

cat <<EOF > $CHEF_ROOT/node.json
{
  "run_list": [ "recipe[graphite]", "recipe[collectd]" ]
}	
EOF

cat <<EOF > $CHEF_ROOT/solo.rb
cookbook_path "$CHEF_ROOT/cookbooks"
EOF

cat <<EOF > /etc/rc.local
. /etc/profile.d/ruby.sh

if [ ! -d /root/chef/cookbooks ]
then
  git clone $COOKBOOK_REPO $CHEF_ROOT/cookbooks
fi

cd $CHEF_ROOT/cookbooks && git pull && chef-solo -c $CHEF_ROOT/solo.rb -j $CHEF_ROOT/node.json
EOF

cat <<EOF > /etc/profile.d/ruby.sh
export PATH="$PATH:/var/lib/gems/1.8/bin"
export RUBYOPT="-Ku -rubygems"
EOF
}

function userdata() {
	echo BEGIN USERDATA
	aptitude update
	declare -ar packages=( git-core
	                       irb ruby rubygems1.8 ruby1.8-dev
	                       libopenssl-ruby )
	aptitude install --assume-yes "${packages[@]}"
	gem install chef --version 0.9.12 --no-ri --no-rdoc
	create_files
	/etc/rc.local
	echo END USERDATA
}
	
userdata >> /var/log/userdata.log 2>&1