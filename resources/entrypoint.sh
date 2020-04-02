#!/bin/bash

# Exit if an error is encountered
set -e

### Create  User
create_user() {
    echo "placeholder"
}

start_standalone() {

    ${JDG_HOME}/jboss-datagrid-7.3.0-server/bin/standalone.sh
}

start_standalone
