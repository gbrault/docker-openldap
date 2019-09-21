FROM debian

ENV OPENLDAP_VERSION 2.4.47
ENV DEBUG_LEVEL 32768

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        ldap-utils procps net-tools nano rsyslog \
        slapd=${OPENLDAP_VERSION}* && \ 
        apt-get clean && \
        rm -rf /var/lib/apt/lists/*

RUN mv /etc/ldap /etc/ldap.dist

COPY modules/ /etc/ldap.dist/modules

COPY entrypoint.sh /entrypoint.sh

EXPOSE 389

VOLUME ["/etc/ldap", "/var/lib/ldap"]

ENTRYPOINT ["/entrypoint.sh"]

# CMD ["sh", "-c", "slapd -h 'ldap:/// ldapi:///' -d ${DEBUG_LEVEL} -u openldap -g openldap"]
CMD ["sh", "-c", "slapd -h 'ldap:/// ldapi:///' -d ${DEBUG_LEVEL} -u openldap -g openldap"]
