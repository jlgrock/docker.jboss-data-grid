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
# Available Configuration Parameters

*Please refer the docker run command options for the `--env-file` flag where you can specify all required environment 
variables in a single file. This will save you from writing a potentially long docker run command.*

Below is the complete list of available options that can be used to customize your installation.

- **MODE**: You can either run in `STANDALONE` mode (single server), `DOMAIN_MASTER` (clustered - is required for any 
slaves to be started), or `DOMAIN_SLAVE` (clustered - needs to be linked to the DOMAIN_MASTER).  The default is `STANDALONE`.
- **JDG_ADMIN_USERNAME**: The username for accessing the admin console.  By default this is `admin`.  Note that users can be 
changed/added, but currently this doesn't allow for removal without destroying the container.
- **JDG_ADMIN_PASSWORD**: The username password for accessing the admin console.  By default this is `admin123!`.  Note that users can 
be changed/added, but currently this doesn't allow for removal without destroying the container.
- **JDG_USERNAME**: The username for accessing the REST API.  By default this is `user`.  Note that users can be 
changed/added, but currently this doesn't allow for removal without destroying the container.
- **JDG_PASSWORD**: The username password for accessing the REST API.  By default this is `user123!`.  Note that users can 
be changed/added, but currently this doesn't allow for removal without destroying the container.
- **JDG_CACHE_NAME**: The cache store name for storing cache. By default is `default_cache`. Note that caches can 
be changed/added.
- **JDG_DISK_PERSISTENCE**: If persistence is needed or not. By default this is `true`
- **JDG_PERSISTENCE_PATH**: The path to store the persistance file containing all cache data. By default this is `/files/` 
- **JDG_SERVER_NAME **: The name for this server so HotRod connector can be configured. By default this is `default-server`

#Accessing the Admin Console
http://localhost:9990/  
user:admin
pass:admin123!

#Adding key entries
POST: http://localhost:8080/rest/${Cache-name}/${key}
Body: ${value}
Basic Authentication:
user:user
pass:user123!
Ex. http://localhost:8080/rest/default/key4Test

#Retreiving cache entries
GET: http://localhost:8080/rest/${Cache-name}/${key}
Basic Authentication:
user:user
pass:user123!
Ex. http://localhost:8080/rest/default/key1Test
	http://localhost:8080/rest/default/key2Test
	http://localhost:8080/rest/default/key3Test

#Other operations
https://infinispan.org/docs/dev/titles/rest/rest.html#rest_server

#Adding users
inside container execute /bin/add-user.sh

Default Management user:
user:admin
pass:admin123!

Default Rest user:
user:user
pass:user123!

#Adding Cache Stores that persists to disk
May use the Management Console on port 9990 or 
modify the .../configuration/standalone.xml file. 
Notice there is a local-cache 'default_cache'. Same way others
could be added. 

			<cache-container name="local" default-cache="default" statistics="true">
				<global-state/>
				<local-cache name="default"/>
				<local-cache name="namedCache"/>
				<local-cache name="default_cache">
				  <persistence>
					<file-store path="/files/" fetch-state="true"/>
				  </persistence>
				</local-cache>
				<security>
				  <authorization>
					<identity-role-mapper/>
					<role name="user" permissions="READ WRITE "/>
				  </authorization>
				</security>
			  </cache-container>
