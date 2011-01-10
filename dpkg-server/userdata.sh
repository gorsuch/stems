#!/bin/bash -x

function userdata() {
	aptitude update
	declare -ar packages=( git-core 
		build-essential dh-make debhelper devscripts 
		quilt cdbs )
	aptitude install --assume-yes "${packages[@]}"
}

userdata >> /var/log/userdata.log 2>&1
