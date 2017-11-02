#!/bin/bash

#
# Script to install Service Manager Builds Database webapp on Linux.
# See https://github.com/sjohner/scsm-builds-database for more information about this project
#
# NOTE: Intended for use by the Azure DevTest Lab artifact system.
#
# The script assumes that mariadb-server mariadb-client apache2 libapache2-mod-php php-mysql are
# already present (probably by installing them by using linux-apt-package artefact)
# If this is not the case, add the following lines:
#   export DEBIAN_FRONTEND=noninteractive
#   sudo apt-get install -q -y mariadb-server mariadb-client apache2 libapache2-mod-php php-mysql
#
# Usage: 
#
# linux-install-scsmbuildsdb.sh -p (password)
#

# Default argument values
USAGE_STRING="Usage:
linux-install-scsmbuildsdb.sh -p (password)
password
    Specify password for db user which is used by the webapp to access the database
"

# Initialize logger
LOGCMD='logger -i -t AZDEVTST_SCSMBUILDSDB --'
which logger
if [ $? -ne 0 ] ; then
    LOGCMD='echo [AZDEVTST_SCSMBUILDSDB] '
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

    # Removing existing files in /var/www/html
    $LOGCMD "Removing existing files in /var/www/html"
    sudo rm -rf /var/www/html/*

    # Cloning git repo which contains necessary files for SCSM Builds DB website
    $LOGCMD "Cloning git repo with following command:"
    $LOGCMD "git clone https://github.com/sjohner/scsm-builds-database.git"
    sudo git clone https://github.com/sjohner/scsm-builds-database.git

    # Copy sample create-database.sql and replace default password with user defined password
    $LOGCMD "Replacing default passwords in create-database.sql with user defined password"
    sudo cp scsm-builds-database/create-database.sql.example scsm-builds-database/create-database.sql
    sudo sed -i "s/P@ssw0rd/$PASSWORD/g" scsm-builds-database/create-database.sql

    # Copy sample config.php and and replace default password with user defined password
    $LOGCMD "Replacing default passwords in config.php with user defined password"
    sudo cp scsm-builds-database/config.php.example scsm-builds-database/config.php
    sudo sed -i "s/P@ssw0rd/$PASSWORD/g" scsm-builds-database/config.php

    # Create SQL database and insert data
    $LOGCMD "Creating database by using create-database.sql included in webapp source:"
    $LOGCMD "sudo mysql < scsm-builds-database/create-database.sql"
    sudo mysql < scsm-builds-database/create-database.sql

    # Copy files
    $LOGCMD "Copy webapp source files to /var/www/html/"
    sudo cp scsm-builds-database/config.php scsm-builds-database/index.php scsm-builds-database/getbuilds.php /var/www/html/

    # Restarting apache to enable php modules
    $LOGCMD "Restarting apache web server with following command:"
    $LOGCMD "service apache2 restart"
    sudo service apache2 restart

fi

if [ -f /usr/bin/yum ] ; then
    $LOGCMD "Using YUM package manager"

    # TODO: Test and implement for non-apt based systems

fi

set +e