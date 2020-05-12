FROM 481315189088.dkr.ecr.us-east-1.amazonaws.com/deloitte-irsm/centos-openjdk:6.6-8u221
MAINTAINER Justin Grant <jlgrock@gmail.com>

ENV JDG_PARENT /opt/app/jboss
ENV INSTALL_DIR ${JDG_PARENT}/install-files
ENV JDG_HOME ${JDG_PARENT}/jboss-jdg
ENV JDG_DATA ${JDG_HOME}/jboss-datagrid-7.3.1-server/standalone/data

RUN mkdir -p ${JDG_PARENT}/ \
             ${JDG_PARENT}/jboss-jdg \
             ${INSTALL_DIR}
			 
RUN touch /var/lib/rpm/* && \
    yum install -y epel-release && \
    yum install -y xmlstarlet \
        unzip

ADD resources/ $JDG_PARENT/
ADD install-files/ /opt/app/jboss/install-files

#set the working directory for the installation
WORKDIR ${JDG_PARENT}

# Install JBOSS DataGrid
RUN ./install_jdg.sh

# Set the working directory for execution
WORKDIR ${JDG_HOME}
#Copy file with data
ADD data/files/ ${JDG_DATA}/files

VOLUME ["/data"]

ENTRYPOINT ["./entrypoint.sh"]