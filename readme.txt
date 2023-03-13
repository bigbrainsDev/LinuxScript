1. Download the latest version of WebLogic Server from the Oracle website.

2. Extract the contents of the downloaded file to a directory on your system.

3. Replace the values for the WL_HOME and DOMAIN_HOME variables with the appropriate values for your system.

4. Make the script executable using the following command:

chmod +x multiupdate_SUSEWeblogic.sh

5. Run the script using the following command:

./multiupdate_SUSEWeblogic.sh

This will upgrade all the WebLogic Server instances in the specified domain directories and restart the servers.

Note that this is just an example and may need to be customized for your specific environment. Also, make sure to test the script in a non-production environment before running it in a production environment.