#!/bin/bash

#
# Script to install MariaDB package on Linux.
# See https://github.com/sjohner/azure-devtestlabs-artifacts/tree/master/linux-install-mariadb for more information
#
# NOTE: Intended for use by the Azure DevTest Lab artifact system.
#
# Usage: 
#
# linux-install-mariadb.sh -p (password)
#

# Default argument values
USAGE_STRING="Usage:
linux-install-mariadb.sh -p (password)
password
    Specify pasword for MariaDB root
"

# Initialize logger
export LOGCMD='logger -i -t AZDEVTST_MARIADB --'
which logger
if [ $? -ne 0 ] ; then
    LOGCMD='echo [AZDEVTST_MARIADB] '
fi

# Check for minimum number of parameters first - must be at minimum 1
if [ $# -lt 1 ] ; then
    $LOGCMD "ERROR: This script needs at least 1 command-line argument, password=."
    $LOGCMD "$USAGE_STRING"
    exit 1
fi

# Get parameter value for password
while getopts p: option
do
    case "${option}"
    in
    p) PASSWORD=${OPTARG};;
    esac
done

set -e

$LOGCMD "Checking for package manager (apt/yum)"

if [ -f /usr/bin/apt ] ; then

    $LOGCMD "apt package manager present"

    # Configuring debconf for unattended installation and setting the given root password
    $LOGCMD "Setting DEBIAN_FRONTEND to 'noninteractive' for unattended installation"
    export DEBIAN_FRONTEND=noninteractive

    DEBCONFPWD="mariadb-server-10.0 mysql-server/root_password password $PASSWORD"
    DEBCONFPWDREPEAT="mariadb-server-10.0 mysql-server/root_password_again password $PASSWORD"

    $LOGCMD "Configuring Debconf with following commands to enable unattended installation:"
    $LOGCMD "sudo debconf-set-selections <<< '$DEBCONFPWD'"
    $LOGCMD "sudo debconf-set-selections <<< '$DEBCONFPWDREPEAT'"

    bash -c "sudo debconf-set-selections <<< '$DEBCONFPWD'"
    bash -c "sudo debconf-set-selections <<< '$DEBCONFPWDREPEAT'"

    # Updating the system using apt-get update.
    $LOGCMD "Updating the system using apt-get -y update"
    sudo apt-get -y update

    # Installl MariaDB packages
    $LOGCMD "Installing MariaDB using the following command:"
    $LOGCMD "apt-get install -q -y mariadb-server mariadb-client"
    sudo apt-get install -q -y mariadb-server mariadb-client

    # No need to create my.cnf file because since Ubuntu 15.10 MariaDB UNIX_SOCKET Authentication Plugin is enabled by default

fi

if [ -f /usr/bin/yum ] ; then
    $LOGCMD "Using YUM package manager"

    # TODO: Test and implement for non-apt based systems

fi

set +e