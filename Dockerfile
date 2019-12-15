# Original credit: https://github.com/jpetazzo/dockvpn
ARG BASEIMAGE=alpine:3.10
FROM $BASEIMAGE

LABEL maintainer="Kyle Manna <kyle@kylemanna.com>"

RUN apk add --no-cache openvpn iptables bash easy-rsa openvpn-auth-pam google-authenticator
RUN apk add --no-cache \
            --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
            pamtester
RUN ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin

# Needed by scripts
ENV OPENVPN /etc/openvpn
ENV EASYRSA /usr/share/easy-rsa
ENV EASYRSA_PKI $OPENVPN/pki
ENV EASYRSA_VARS_FILE $OPENVPN/vars

# Prevents refused client connection because of an expired CRL
ENV EASYRSA_CRL_DAYS 3650

VOLUME ["/etc/openvpn"]

# Internally uses port 1194/udp, remap using `docker run -p 443:1194/tcp`
EXPOSE 1194/udp

CMD ["ovpn_run"]

ADD ./bin /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# Add support for OTP authentication using a PAM module
ADD ./otp/openvpn /etc/pam.d/

# "strong primes" my ass, DSA-like is enough
RUN sed -i "s/dhparam -out/dhparam -dsaparam -out/" /usr/local/bin/easyrsa
