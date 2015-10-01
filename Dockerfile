FROM vbatts/slackware-base:latest
MAINTAINER roninkenji

RUN echo "http://ftp.osuosl.org/.2/slackware/slackware64-14.1/" >> /etc/slackpkg/mirrors
RUN sed -i -e 's/^WGETFLAGS=.*/WGETFLAGS="--passive-ftp --no-verbose"/' /etc/slackpkg/slackpkg.conf
RUN slackpkg -batch=on -default_answer=yes update && slackpkg -batch=on -default_answer=yes upgrade-all

# Upgrading CA-certificates
RUN slackpkg -batch=on -default_answer=yes install ca-certificates && ( cd /etc/ssl/certs; grep -v '^#' /etc/ca-certificates.conf | while read CERT; do ln -fsv /usr/share/ca-certificates/$CERT `basename ${CERT/.crt/.pem}`; ln -fsv /usr/share/ca-certificates/$CERT `openssl x509 -hash -noout -in /usr/share/ca-certificates/$CERT`.0; done )

