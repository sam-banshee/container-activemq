FROM amazoncorretto:11
ENV ACTIVEMQ_VERSION=5.16.5
ENV ACTIVEMQ=apache-activemq-5.16.5 ACTIVEMQ_TCP=61616 ACTIVEMQ_AMQP=5672 ACTIVEMQ_STOMP=61613 ACTIVEMQ_MQTT=1883 ACTIVEMQ_WS=61614 ACTIVEMQ_UI=8161
ENV ACTIVEMQ_HOME=/opt/activemq
RUN yum -y update  \
	&& yum install -y yum-utils  curl tar gzip shadow-utils \
	&& yum autoremove -y \
	&& yum clean all \
	&& rm -rf /var/cache/yum \
	&& curl "https://archive.apache.org/dist/activemq/$ACTIVEMQ_VERSION/$ACTIVEMQ-bin.tar.gz" -o $ACTIVEMQ-bin.tar.gz \
	&& tar xzf $ACTIVEMQ-bin.tar.gz -C /opt \
	&& ln -s /opt/$ACTIVEMQ $ACTIVEMQ_HOME \
	&& useradd -r -M -d $ACTIVEMQ_HOME activemq -u 12999 \
	&& chown -R activemq:0 /opt/$ACTIVEMQ \
	&& chown -h activemq:0 $ACTIVEMQ_HOME \
	&& chmod go+rwX -R $ACTIVEMQ_HOME \
	&& chgrp -R 0 $ACTIVEMQ_HOME \
	&& chmod -R g=u $ACTIVEMQ_HOME
USER 12999
WORKDIR /opt/activemq
EXPOSE 1883 5672 61613 61614 61616 8161
CMD ["/bin/sh", "-c", "bin/activemq console"]
