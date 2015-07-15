# Docker xmltv with xmltv2vdr

XMLTV binaries from iuuuuan/xmltv but adding xmltv2vdr script

docker build --rm=true -t "chrodriguez/xmltv-docker" .

# Using image

## Configure grabber

```
docker run -it -v `pwd`/channels/xmltv-config:/etc/xmltv \
        chrodriguez/xmlt tv_grab_ar \
        --config-file /etc/xmltv/tv_grab_ar.conf \
        --configure
```

## Run grabber

```
docker run -it -v `pwd`/channels/xmltv-config:/etc/xmltv \
        chrodriguez/xmltv tv_grab_ar \
        --config-file /etc/xmltv/tv_grab_ar.conf \
        --days 7 | iconv -f iso88591 -t utf8 > /tmp/tv.xml
```

## Run xmltv2vdr

```
docker run -it -v /tmp/tv.xml:/tmp/tv.xml \
        -v `pwd`/config/channels.conf:/tmp/channels.conf \
        --net=container:vdr \
        chrodriguez/xmltv xmltv2vdr \
        -x /tmp/tv.xml -a -180 \
        -c /tmp/channels.conf
```

