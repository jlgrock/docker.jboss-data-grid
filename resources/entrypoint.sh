#!/bin/bash

# Exit if an error is encountered
set -e

### Set defaults for any of the environment variables
set_defaults() {
    if [[ ! "${MODE}" ]]; then
        MODE="STANDALONE"
    fi

    if [[ ! "${JDG_USERNAME}" ]]; then
        JDG_USERNAME="myuser"
    fi

    if [[ ! "${JDG_PASSWORD}" ]]; then
        JDG_PASSWORD="admin123!"
    fi
}

### Create  User
create_user() {
     ${JDG_HOME}/jboss-datagrid-7.3.0-server/bin/add-user.sh -a -u ${JDG_USERNAME} -p ${JDG_PASSWORD} -ro supervisor,reader,writer --silent
}


start_standalone() {

    ${JDG_HOME}/jboss-datagrid-7.3.0-server/bin/standalone.sh -c standalone.xml
}

set_defaults
#check_env_values
create_user

case "${MODE}" in
    STANDALONE*)
        echo "Starting JBOSS Data Grid Server in STANDALONE mode"
        start_standalone
    ;;
    #DOMAIN_MASTER*)
    #    echo "Starting JBOSS Data Grid Server in DOMAIN mode as Domain Master"
    #    start_domain_master
    #;;
    #DOMAIN_SLAVE*)
    #    echo "Starting JBOSS Data Grid Server in DOMAIN mode as Domain Slave"
    #    start_domain_master
esac