FROM jlgrock/centos-oraclejdk:6.6-8u45
MAINTAINER Justin Grant <jlgrock@gmail.com>

# Set the INFINISPAN_SERVER_HOME env variable
ENV INFINISPAN_SERVER_HOME /opt/jboss/infinispan-server

ADD resources/ $EAP_PARENT/
ADD install_files/ $EAP_PARENT/
ADD VERSION $INFINISPAN_SERVER_HOME/VERSION
ADD loadenv.sh $INFINISPAN_SERVER_HOME/loadenv.sh

WORKDIR $INFINISPAN_SERVER_HOME

# Set the INFINISPAN_VERSION env variable
ENV INFINISPAN_VERSION 8.0.0.Final

# Download and unzip Infinispan server
RUN cd $HOME && curl http://downloads.jboss.org/infinispan/$INFINISPAN_VERSION/infinispan-server-$INFINISPAN_VERSION-bin.zip | bsdtar -xf - && mv $HOME/infinispan-server-$INFINISPAN_VERSION $HOME/infinispan-server && chmod +x /opt/jboss/infinispan-server/bin/standalone.sh

### Start JBoss Data Grid
CMD $EAP_HOME/startup.sh

# Run Infinispan server and bind to all interface
CMD ["/opt/jboss/infinispan-server/bin/standalone.sh", "-b", "0.0.0.0"]

