#!/bin/bash -x

export CHEF_VERSION=0.9.12
export CHEF_ROOT=/root/chef
export COOKBOOKS_URL=https://s3.amazonaws.com/gorsuch-cookbooks/cookbooks.tar.gz
export JSON_URL=https://s3.amazonaws.com/gorsuch-cookbooks/node.json

function create_files() {
mkdir -p $CHEF_ROOT

cat <<EOF > $CHEF_ROOT/solo.rb
cookbook_path "$CHEF_ROOT/cookbooks"
recipe_url "$COOKBOOKS_URL"
json_attribs "$JSON_URL"
EOF

cat <<EOF > /etc/rc.local
. /etc/profile.d/ruby.sh

chef-solo -c $CHEF_ROOT/solo.rb
EOF

cat <<EOF > /etc/profile.d/ruby.sh
export PATH="$PATH:/var/lib/gems/1.8/bin"
export RUBYOPT="-Ku -rubygems"
EOF
}

function userdata() {
	echo BEGIN USERDATA
	aptitude update
	declare -ar packages=( irb ruby rubygems1.8 ruby1.8-dev
	                       libopenssl-ruby )
	aptitude install --assume-yes "${packages[@]}"
	gem install chef --version $CHEF_VERSION --no-ri --no-rdoc
	create_files
	/etc/rc.local
	echo END USERDATA
}
	
userdata >> /var/log/userdata.log 2>&1
