#!/bin/bash

# Define variables
WEBLOGIC_HOME=/usr/local/weblogic
PATCH_DIR=/opt/patches
PATCH_FILE=weblogic_patch.zip
LOG_FILE=/var/log/weblogic_patch.log
JAVA_HOME=/usr/local/java

# Check for dependencies
echo "Checking for dependencies..." >> ${LOG_FILE}
# Insert commands to check for dependencies here
# Examples : Java Development Kit (JDK) / JDBC drivers / WebLogic / Patch File / Server List.txt File
echo "Checking for JDK..."
if [ -x "${JAVA_HOME}/bin/java" ]; then
    java_version=$("${JAVA_HOME}/bin/java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
    echo "JDK version is $java_version" >> ${LOG_FILE}
else
    echo "JDK is not installed" >> ${LOG_FILE}
    exit 1
fi

# Check for WebLogic
echo "Checking for WebLogic..."
if [ -d "${WEBLOGIC_HOME}" ]; then
    echo "WebLogic is installed" >> ${LOG_FILE}
else
    echo "WebLogic is not installed" >> ${LOG_FILE}
    exit 1
fi

# Check for patch
echo "Checking for patch..."
if [ -f "${PATCH_DIR}/${PATCH_FILE}" ]; then
    echo "Patch is available" >> ${LOG_FILE}
else
    echo "Patch is not available" >> ${LOG_FILE}
    exit 1
fi

# Check for server list
echo "Checking for server list..."
if [ -f "server_list.txt" ]; then
    echo "Server list is available" >> ${LOG_FILE}
else
    echo "Server list is not available" >> ${LOG_FILE}
    exit 1
fi

# Loop through server list and apply patch to each server
while read server_name; do
    echo "Applying patch to $server_name..." >> ${LOG_FILE}

    # Stop the server
    echo "Stopping WebLogic server..." >> ${LOG_FILE}
    ssh $server_name /opt/oracle/weblogic/bin/stopWebLogic.sh

    # Apply the patch
    echo "Applying patch..." >> ${LOG_FILE}
    scp ${PATCH_DIR}/${PATCH_FILE} $server_name:/tmp/
    ssh $server_name "unzip /tmp/${PATCH_FILE} -d /opt/oracle/weblogic/"

    # Restart the server
    echo "Starting WebLogic server..." >> ${LOG_FILE}
    ssh $server_name /opt/oracle/weblogic/bin/startWebLogic.sh

    # Verification
    echo "Verifying patch installation..." >> ${LOG_FILE}
    weblogic_version=$(${WEBLOGIC_HOME}/bin/version.sh | awk '/WebLogic Server/ {print $4}')
    if [ "$weblogic_version" == "12.2.1.4.0" ]; then
        echo "Patch installation successful" >> ${LOG_FILE}
    else
        echo "Patch installation failed" >> ${LOG_FILE}
        exit 1
    fi

    # Cleanup
    echo "Cleaning up temporary files..." >> ${LOG_FILE}
    ssh $server_name "rm -rf /tmp/${PATCH_FILE}"

    # Logging
    echo "Patch installation completed for $server_name." >> ${LOG_FILE}

done < server_list.txt

echo "Patch installation completed for all servers." >> ${LOG_FILE}