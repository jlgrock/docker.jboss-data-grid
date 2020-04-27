# Introduction

This is a very basic install of Infinispan (not technically JBoss Data Grid).  The goal is to update this to be the full JDG installation and parameterize this.  This is very much a work in progress, but should suit needs for initial testing.

# Hardware Requirements

## Memory

TBD

# How to get the image

You can either download the image from a docker registry or build it yourself.

## Building the Image
* run `build.sh`

These builds are not performed by the **Docker Trusted Build** service because it contains JBoss proprietary code, but this method can be used if using a [Private Docker Registry](https://docs.docker.com/registry/deploying/).

```bash
docker pull deloitte-irsm/rhjdg:$VERSION
```

# Examples of Running a Container

Starting Jboss Data Grid Server in Standalone mode
```bash
 docker run -it --rm --name jboss-jdg -p 8080:8080 -p 9990:9990 deloitte-irsm/rhjdg:7.3.5
```

Or you can run docker-compose to avoid typing a long docker-run command.

```bash
 docker-compose up --build
```

#Accessing the Admin Console
http://localhost:9990/  
user:admin
pass:password123

#Adding key entries
POST: http://localhost:8080/rest/${Cache-name}/${key}
Body: ${value}
Basic Authentication:
user:cmuser
pass:password123
Ex. http://localhost:8080/rest/CM_CACHE/key4Test

#Retreiving cache entries
GET: http://localhost:8080/rest/${Cache-name}/${key}
Basic Authentication:
user:cmuser
pass:password123
Ex. http://localhost:8080/rest/CM_CACHE/key1Test
	http://localhost:8080/rest/CM_CACHE/key2Test
	http://localhost:8080/rest/CM_CACHE/key3Test

#Other operations
https://infinispan.org/docs/dev/titles/rest/rest.html#rest_server

#Adding users
inside container execute /bin/add-user.sh

Default Management user:
user:admin
pass:password123

Default Rest user:
user:cmuser
pass:password123

#Adding Cache Stores that persists to disk
May use the Management Console on port 9990 or 
modify the .../configuration/standalone.xml file. 
Notice there is a local-cache 'CM_CACHE'. Same way others
could be added. 

			<cache-container name="local" default-cache="default" statistics="true">
                <security>
                    <authorization>
                        <identity-role-mapper/>
                        <role name="admin" permissions="READ WRITE BULK_READ BULK_WRITE EXEC LISTEN ADMIN"/>
                    </authorization>
                </security>
                <global-state/>
                <local-cache name="CM_CACHE">
                    <persistence>
                        <file-store path="/files/" fetch-state="true"/>
                    </persistence>
                </local-cache>
            </cache-container>
