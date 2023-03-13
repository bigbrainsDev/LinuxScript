#!/bin/bash

# This script upgrades all domains in a WebLogic Server installation.

# Make the script executable using the following command:
# chmod +x multiupdate_SUSEWeblogic.sh

# Run the script using the following command:
# ./multiupdate_SUSEWeblogic.sh

# Replace the values for the WL_HOME and DOMAIN_HOME variables with the appropriate values for your system.

# Define the WebLogic Server installation directory
WL_HOME=/path/to/weblogic/installation

# Define the domain directory
DOMAIN_HOME=/path/to/weblogic/domain

# Define the upgrade script location
UPGRADE_SCRIPT=$WL_HOME/config.sh

# Upgrade each domain
for domain_dir in $DOMAIN_HOME/*
do
    echo "Upgrading domain in $domain_dir..."
    cd $domain_dir
    $UPGRADE_SCRIPT -mode=upgrade
    echo "Upgrade complete for $domain_dir."
done

# Restart the servers
for domain_dir in $DOMAIN_HOME/*
do
    echo "Starting server in $domain_dir..."
    cd $domain_dir
    ./startWebLogic.sh
    echo "Server started for $domain_dir."
done
