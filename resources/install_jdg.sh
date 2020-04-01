#!/bin/sh

# Exit if an error is encountered
set -e -x

# Unzip EAP to the version-generic home directory
# TODO make more generic so this doesn't have to change for upgrades
echo "unzipping files..."
unzip -q ${INSTALL_DIR}/jboss-datagrid-7.3.0-1-server.zip -d ${EAP_PARENT}

mv ${EAP_PARENT}/jboss-datagrid-7.3.0-server ${EAP_HOME}
chmod +x ${EAP_HOME}/jboss-datagrid-7.3.0-server/bin/*.sh

# Move the entrypoint scripts to EAP_HOME
mv entrypoint.sh ${EAP_HOME}/

