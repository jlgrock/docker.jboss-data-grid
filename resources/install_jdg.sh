#!/bin/sh

# Exit if an error is encountered
set -e -x

# Unzip JDG server to the version-generic home directory
# TODO make more generic so this doesn't have to change for upgrades
echo "unzipping files..."
unzip -q ${INSTALL_DIR}/jboss-datagrid-7.3.1-server.zip -d ${JDG_PARENT}

mv ${JDG_PARENT}/jboss-datagrid-7.3.1-server ${JDG_PARENT}/jboss-jdg
chmod +x ${JDG_HOME}/jboss-datagrid-7.3.1-server/bin/*.sh

#apply the patch
$JDG_HOME/jboss-datagrid-7.3.1-server/bin/cli.sh "patch apply $INSTALL_DIR/jboss-datagrid-7.3.5-server-patch.zip"

# Move the entrypoint scripts to JDG_HOME
mv entrypoint.sh ${JDG_HOME}/

