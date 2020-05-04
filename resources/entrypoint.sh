#!/bin/bash

# Exit if an error is encountered
set -e

### Set defaults for any of the environment variables
set_defaults() {
    if [[ ! "${MODE}" ]]; then
        MODE="STANDALONE"
    fi

    if [[ ! "${JDG_USERNAME}" ]]; then
        JDG_USERNAME="user"
    fi

    if [[ ! "${JDG_PASSWORD}" ]]; then
        JDG_PASSWORD="user123!"
    fi
	
	if [[ ! "${JDG_ADMIN_USERNAME}" ]]; then
        JDG_ADMIN_USERNAME="admin"
    fi

    if [[ ! "${JDG_ADMIN_PASSWORD}" ]]; then
        JDG_ADMIN_PASSWORD="admin123!"
	fi
	
	if [[ ! "${JDG_CACHE_NAME}" ]]; then
        JDG_CACHE_NAME="default_cache"
    fi
	
	if [[ ! "${JDG_DISK_PERSISTENCE}" ]]; then
        JDG_DISK_PERSISTENCE= "true"
    fi
	
	if [[ ! "${JDG_PERSISTENCE_PATH}" ]]; then
        JDG_PERSISTENCE_PATH="/files/"
    fi
	
	if [[ ! "${JDG_SERVER_NAME}" ]]; then
        JDG_SERVER_NAME="default-server"
    fi
	
}

# Creates the options to be passed to the program that will start up jboss, facilitating variable replacement in the
# XML files
create_option_string() {
    OPTS="$OPTS"
    
    # set the host ip for eth0 - this may not scale well
    HOST_IP=$(/sbin/ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}')

    OPTS="${OPTS} -Djboss.bind.address=${HOST_IP}"
    OPTS="${OPTS} -Djboss.bind.address.unsecure=${HOST_IP}"
    OPTS="${OPTS} -Djboss.bind.address.management=${HOST_IP}"

    echo "Created Option String: ${OPTS}"
}

### Create  User
create_user() {
echo "Adding users"
     ${JDG_HOME}/jboss-datagrid-7.3.1-server/bin/add-user.sh -m -u ${JDG_ADMIN_USERNAME} -p ${JDG_ADMIN_PASSWORD} -ro admin --silent
	 ${JDG_HOME}/jboss-datagrid-7.3.1-server/bin/add-user.sh -a -u ${JDG_USERNAME} -p ${JDG_PASSWORD} -ro user --silent
}

start_standalone() {

    create_option_string

    ${JDG_HOME}/jboss-datagrid-7.3.1-server/bin/standalone.sh -c standalone.xml ${OPTS}
	
}

add_cache() {
    echo "Adding Cache Store"

xmlstarlet ed --inplace \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']" -t elem -n "local-cache" -v "" \
-i "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']/*[local-name() = 'local-cache'][not(@*)]" -t attr -n "name" -v ${JDG_CACHE_NAME} \
${JDG_HOME}/jboss-datagrid-7.3.1-server/standalone/configuration/standalone.xml
}

add_persistence() {
echo "Adding Persistence"
xmlstarlet ed --inplace \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']/*[local-name() = 'local-cache'][@name='${JDG_CACHE_NAME}']" -t elem -n "persistence" -v "" \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']/*[local-name() = 'local-cache'][@name='${JDG_CACHE_NAME}']/*[local-name() = 'persistence']" -t elem -n "file-store" -v "" \
-i "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']/*[local-name() = 'local-cache'][@name='${JDG_CACHE_NAME}']/*[local-name() = 'persistence']/*[local-name() = 'file-store']" -t attr -n "path" -v ${JDG_PERSISTENCE_PATH} \
-i "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']/*[local-name() = 'local-cache'][@name='${JDG_CACHE_NAME}']/*[local-name() = 'persistence']/*[local-name() = 'file-store']" -t attr -n "fetch-state" -v "true" \
${JDG_HOME}/jboss-datagrid-7.3.1-server/standalone/configuration/standalone.xml
}

add_security_to_cache_container() {

echo "Adding security to cache container"
xmlstarlet ed --inplace \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']" -t elem -n "security" -v "" \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']/*[local-name() = 'security']" -t elem -n "authorization" -v "" \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']/*[local-name() = 'security']/*[local-name() = 'authorization']" -t elem -n "identity-role-mapper" -v "" \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']/*[local-name() = 'security']/*[local-name() = 'authorization']" -t elem -n "role" -v "" \
-i "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']/*[local-name() = 'security']/*[local-name() = 'authorization']/*[local-name() = 'role']" -t attr -n "name" -v ${JDG_USERNAME} \
-i "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:core:9.4']/*[local-name() = 'cache-container']/*[local-name() = 'security']/*[local-name() = 'authorization']/*[local-name() = 'role']" -t attr -n "permissions" -v "READ WRITE " \
${JDG_HOME}/jboss-datagrid-7.3.1-server/standalone/configuration/standalone.xml
}

add_security_hotrod() {
echo "Adding security hotrod connector"
xmlstarlet ed --inplace \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:endpoint:9.4']/*[local-name() = 'hotrod-connector']" -t elem -n "authentication" -v "" \
-i "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:endpoint:9.4']/*[local-name() = 'hotrod-connector']/*[local-name() = 'authentication']" -t attr -n "security-realm" -v "ApplicationRealm" \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:endpoint:9.4']/*[local-name() = 'hotrod-connector']/*[local-name() = 'authentication']" -t elem -n "sasl" -v "" \
-i "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:endpoint:9.4']/*[local-name() = 'hotrod-connector']/*[local-name() = 'authentication']/*[local-name() = 'sasl']" -t attr -n "server-name" -v ${JDG_SERVER_NAME} \
-i "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:endpoint:9.4']/*[local-name() = 'hotrod-connector']/*[local-name() = 'authentication']/*[local-name() = 'sasl']" -t attr -n "mechanisms" -v "DIGEST-MD5" \
-i "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:endpoint:9.4']/*[local-name() = 'hotrod-connector']/*[local-name() = 'authentication']/*[local-name() = 'sasl']" -t attr -n "qop" -v "auth" \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:endpoint:9.4']/*[local-name() = 'hotrod-connector']/*[local-name() = 'authentication']/*[local-name() = 'sasl']" -t elem -n "policy" -v "" \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:endpoint:9.4']/*[local-name() = 'hotrod-connector']/*[local-name() = 'authentication']/*[local-name() = 'sasl']/*[local-name() = 'policy']" -t elem -n "no-anonymous" -v "" \
-i "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:endpoint:9.4']/*[local-name() = 'hotrod-connector']/*[local-name() = 'authentication']/*[local-name() = 'sasl']/*[local-name() = 'policy']/*[local-name() = 'no-anonymous']" -t attr -n "value" -v "true" \
-s "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:endpoint:9.4']/*[local-name() = 'hotrod-connector']/*[local-name() = 'authentication']/*[local-name() = 'sasl']" -t elem -n "property" -v "true" \
-i "/*[local-name() = 'server']/*[local-name() = 'profile']/*[local-name() = 'subsystem'][namespace-uri() = 'urn:infinispan:server:endpoint:9.4']/*[local-name() = 'hotrod-connector']/*[local-name() = 'authentication']/*[local-name() = 'sasl']/*[local-name() = 'property']" -t attr -n "name" -v "com.sun.security.sasl.digest.utf8" \
${JDG_HOME}/jboss-datagrid-7.3.1-server/standalone/configuration/standalone.xml

}

set_defaults
#check_env_values
create_user
add_cache
	if [[${JDG_DISK_PERSISTENCE} == "true"]]; then
        add_persistence
    fi
add_security_to_cache_container
add_security_hotrod

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