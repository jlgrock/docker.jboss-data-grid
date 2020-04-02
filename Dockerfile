FROM 481315189088.dkr.ecr.us-east-1.amazonaws.com/deloitte-irsm/centos-openjdk:6.6-8u221
MAINTAINER Justin Grant <jlgrock@gmail.com>

ENV JDG_PARENT /opt/app/jboss
ENV INSTALL_DIR ${JDG_PARENT}/install-files
ENV JDG_HOME ${JDG_PARENT}/jboss-jdg

RUN mkdir -p ${JDG_PARENT}/ \
             ${JDG_PARENT}/jboss-jdg \
             ${INSTALL_DIR}

ADD resources/ $JDG_PARENT/
ADD install-files/ /opt/app/jboss/install-files

#set the working directory for the installation
WORKDIR ${JDG_PARENT}

# Install JBOSS DataGrid
RUN ./install_jdg.sh

# Set the working directory for execution
WORKDIR ${JDG_HOME}

ENTRYPOINT ["./entrypoint.sh"]