#Docker file with Influxdb/Telegraf/Kapacitor/Grafana

From centos:7

#File Author 
MAINTAINER Pratik

#Environment
ENV container docker

#Manual systemctl installation
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tempfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*; \
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;
	VOLUME [ "/sys/fs/cgroup" ]
	CMD [ "/usr/sbin/init" ]

#Update the repository and install dependencies:
#RUN yum -y update
RUN yum -y install epel-release \
	java \
	telnet \
	vim \
	unzip \
	wget

################## BEGIN INSTALLATION ######################

################## Install Influxdb ########################

#Add influx repo file and install influxdb
ADD influxdb.repo /etc/yum.repos.d/influxdb.repo
RUN yum -y install influxdb

#Add custom conf file
RUN mv /etc/influxdb/influxdb.conf /etc/influxdb.conf.orig
ADD influxdb.conf /etc/influxdb/influxdb.conf

#################### Install Telegraf ######################
RUN wget https://repos.influxdata.com/rhel/7/amd64/stable/telegraf-1.2.1.x86_64.rpm
RUN yum -y localinstall telegraf-1.2.1.x86_64.rpm

#ADD custom conf file
RUN mv /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.orig
ADD telegraf.conf /etc/telegraf/telegraf.conf

################## Install kapacitor ########################
RUN wget https://s3.amazonaws.com/kapacitor/kapacitor-0.11.0-1.x86_64.rpm
RUN yum -y localinstall kapacitor-0.11.0-1.x86_64.rpm

#ADD custom conf file
RUN mv /etc/kapacitor/kapacitor.conf /etc/kapacitor/kapacitor.conf.orig
ADD kapacitor.conf /etc/kapacitor/kapacitor.conf

################## Install kapacitor ########################
RUN wget https://grafanarel.s3.amazonaws.com/builds/grafana-2.6.0-1.x86_64.rpm
RUN yum -y localinstall grafana-2.6.0-1.x86_64.rpm

################## Install Grafana Web Interface ########################
RUN wget https://grafanarel.s3.amazonaws.com/builds/grafana-2.6.0-1.x86_64.rpm
RUN yum -y localinstall grafana-2.6.0-1.x86_64.rpm 

#Add Custom Conf file
RUN mv /etc/grafana/grafana.ini /etc/grafana/grafana.ini.orig
ADD grafana.ini /etc/grafana/grafana.ini
EXPOSE 3000
RUN chown root:grafana /etc/grafana/grafana.ini
RUN systemctl start grafana-server
