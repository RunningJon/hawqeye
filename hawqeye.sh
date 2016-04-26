#!/bin/bash
set -e

PWD=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

GIT_USERNAME=$1

if [ "$GIT_USERNAME" == "" ]; then
	echo "You must provide your github username"
	echo "Example: ./hawqeye.sh pivotalguru"
	exit 1
fi

MYCMD="hawqeye.sh"
MYVAR="tpcds_variables.sh"
REPO="hawqeye"
REPO_URL="https://$GIT_USERNAME@github.com/pivotalguru/hawqeye.git"
GIT_SSL_NO_VERIFY="true"
ADMIN_USER=$(echo $USER)

##################################################################################################################################################
# Functions
##################################################################################################################################################

yum_checks()
{
	echo "############################################################################"
	echo "Make sure git and gcc is installed."
	echo "############################################################################"
	echo ""
	# Install git and gcc if not found
	local CURL_INSTALLED=$(gcc --help 2> /dev/null | wc -l)
	local GIT_INSTALLED=$(git --help 2> /dev/null | wc -l)

	if [ "$CURL_INSTALLED" -eq "0" ]; then
		echo "gcc not installed.  Please install gcc and try again."
		exit 1
	fi
	if [ "$GIT_INSTALLED" -eq "0" ]; then
		echo "git not installed.  Please install git and try again."
		exit 1
	fi
	echo ""
}

repo_init()
{
	### Install repo ###
	echo "############################################################################"
	echo "Install the github repository."
	echo "############################################################################"
	echo ""

	internet_down="0"
	for j in $(curl google.com 2>&1 | grep "Could not resolve host"); do
		internet_down="1"
	done

	if [ ! -d $PWD/$REPO ]; then
		if [ "$internet_down" -eq "1" ]; then
			echo "Unable to continue because repo hasn't been downloaded and Internet is not available."
			exit 1
		else
			echo ""
			echo "Creating $REPO directory"
			echo "-------------------------------------------------------------------------"
			mkdir $PWD/$REPO
			git clone --depth=1 $REPO_URL
		fi
	else
		if [ "$internet_down" -eq "0" ]; then
			cd $PWD/$REPO
			git fetch --all
			git reset --hard origin/master
			cd ..
		fi
	fi
}

echo_variables()
{
	echo "############################################################################"
	echo "REPO: $REPO"
	echo "REPO_URL: $REPO_URL"
	echo "ADMIN_USER: $ADMIN_USER"
	echo "############################################################################"
	echo ""
}

##################################################################################################################################################
# Body
##################################################################################################################################################

yum_checks
repo_init
echo_variables

echo "Done!"
