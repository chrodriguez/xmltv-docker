FROM iuuuuan/xmltv
ENV VERSION_XMLTV="0.5.67"
MAINTAINER chrodriguez <chrodriguez@gmail.com>
ADD https://github.com/chrodriguez/xmltv2vdr/archive/1.0.0.tar.gz /tmp/1.0.0.tar.gz
RUN cd /tmp && tar xvfz 1.0.0.tar.gz -C /opt && ln -s /opt/xmltv2vdr-1.0.0/xmltv2vdr.pl /usr/bin/xmltv2vdr
RUN apt-get -y update && apt-get install -y libdate-manip-perl

# Ruby Install
# Install packages for building ruby
RUN apt-get install -y --force-yes build-essential curl git
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev

# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /root/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /root/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'export PATH=/root/.rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'export PATH=/root/.rbenv/bin:$PATH' >> .bashrc
RUN echo 'eval "$(rbenv init -)"' >> .bashrc

# Install multiple versions of ruby
ENV CONFIGURE_OPTS --disable-install-doc
ADD ./ruby-versions.txt /root/versions.txt
RUN xargs -L 1 rbenv install < /root/versions.txt

# Install Bundler for each version of ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -l -c 'for v in $(cat /root/versions.txt); do rbenv global $v; gem install bundler; done'
# End ruby install

## vdr-ar-analog-channels

RUN git clone https://github.com/chrodriguez/vdr-ar-analog-channels.git /opt/vdr-ar-channels

# Soporte de LWP::Protocol::https
RUN cpan install LWP::Protocol::https && rm -rf /root/.cpan

COPY patches/tv_grab_ar /usr/local/bin/
