FROM alpine:latest
RUN apk update
# Alpine Linux package management : http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
# http://dl-4.alpinelinux.org/alpine/edge/testing/x86_64/
RUN apk add tor --update-cache --repository http://dl-4.alpinelinux.org/alpine/edge/testing/ --allow-untrusted

# Ports
EXPOSE 9001
EXPOSE 9050
EXPOSE 8080
EXPOSE 443

RUN rm /var/cache/apk/*

ADD ./torrc /etc/tor/torrc
# Allow you to upgrade your relay without having to regenerate keys
VOLUME /.tor

# Generate a random nickname for the relay
RUN echo "Nickname $(head -c 19 /dev/urandom  | sha1sum | cut -c1-19)" >> /etc/tor/torrc

USER tor
CMD /usr/bin/tor -f /etc/tor/torrc
