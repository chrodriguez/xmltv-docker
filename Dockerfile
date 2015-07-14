FROM iuuuuan/xmltv
MAINTAINER chrodriguez <chrodriguez@gmail.com>
ADD https://github.com/chrodriguez/xmltv2vdr/archive/1.0.0.tar.gz /tmp/1.0.0.tar.gz
RUN cd /tmp && tar xvfz 1.0.0.tar.gz -C /opt && ln -s /opt/xmltv2vdr-1.0.0/xmltv2vdr.pl /usr/bin/xmltv2vdr
RUN apt-get -y update && apt-get install -y libdate-manip-perl
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
