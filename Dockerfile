FROM 481315189088.dkr.ecr.us-east-1.amazonaws.com/deloitte-irsm/centos-openjdk:6.6-8u221
MAINTAINER Justin Grant <jlgrock@gmail.com>

ENV EAP_PARENT /opt/app/jboss
ENV INSTALL_DIR ${EAP_PARENT}/install-files
ENV EAP_HOME ${EAP_PARENT}/jboss-jdg

RUN mkdir -p ${EAP_PARENT}/ \
             ${EAP_PARENT}/jboss-jdg \
             ${INSTALL_DIR}

ADD resources/ $EAP_PARENT/
ADD install-files/ /opt/app/jboss/install-files

#set the working directory for the installation
WORKDIR ${EAP_PARENT}

# Install JBOSS DataGrid
RUN ./install_jdg.sh

# Set the working directory for execution
WORKDIR ${EAP_HOME}

ENTRYPOINT ["./entrypoint.sh"]