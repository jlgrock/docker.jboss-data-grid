#!/bin/sh

# Exit if an error is encountered
set -e -x

# Unzip JDG server to the version-generic home directory
# TODO make more generic so this doesn't have to change for upgrades
echo "unzipping files..."
unzip -q ${INSTALL_DIR}/jboss-datagrid-7.3.0-1-server.zip -d ${JDG_PARENT}

mv ${JDG_PARENT}/jboss-datagrid-7.3.0-server ${JDG_HOME}
chmod +x ${JDG_HOME}/jboss-datagrid-7.3.0-server/bin/*.sh

# Move the entrypoint scripts to JDG_HOME
mv entrypoint.sh ${JDG_HOME}/

