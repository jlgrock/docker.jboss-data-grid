#!/bin/sh

###############################################################
# This script will build the core version of the EAP instance,
# storing the image to jlgrock/jboss-eap.  If you drop extra WARs
# into the install directory, you can create a custom deployment.
# It is suggested that you don't use this script though, as you'll
# want to store this image to something other than jlgrock/jboss-eap.
# For example, you can put webapp.war in there and create an instance
# called my/webapp.
###############################################################

# load the versions
. ./loadenv.sh

echo "Processing for JBOSS Data Grid Version $JBOSS_JDG"

if [[ ! -e install_files/jboss-datagrid-${JBOSS_JDG_BASE}-server.zip ]]; then
    echo "could not find file install_files/jboss-datagrid-${JBOSS_JDG_BASE}-server.zip"
    echo "You should put the required binary into the root directory first."
    exit 255
fi

# Create containers
echo "Creating JBoss Data Grid Container ..."
docker build -q --rm -t deloitte-irsm/rhjdg:${JBOSS_JDG} .

if [ $? -eq 0 ]; then
    echo "Container Built"
else
    echo "Error: Unable to Build Container"
fi
