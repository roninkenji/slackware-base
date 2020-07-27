FROM vbatts/slackware-base:current
LABEL maintainer=roninkenji

# RUN sed -i -e 's/^WGETFLAGS=.*/WGETFLAGS="--passive-ftp --no-verbose"/' /etc/slackpkg/slackpkg.conf
RUN touch /var/lib/slackpkg/current
RUN slackpkg -batch=on -default_answer=yes update && \
    slackpkg -batch=on -default_answer=yes upgrade slackpkg && \
    slackpkg -batch=on -default_answer=yes update && \
    slackpkg -batch=on -default_answer=yes upgrade-all && \
    slackpkg -batch=on -default_answer=yes update && \
    slackpkg -batch=on -default_answer=yes install ca-certificates && \
    # manually generate CA cert hashes since we don't have perl to run update-ca-certificates properly
    ( cd /etc/ssl/certs; grep -v '^#' /etc/ca-certificates.conf | while read CERT; do ln -fsv /usr/share/ca-certificates/$CERT `basename ${CERT/.crt/.pem}`; ln -fsv /usr/share/ca-certificates/$CERT `openssl x509 -hash -noout -in /usr/share/ca-certificates/$CERT`.0; done )

# Set default LANG to en_US.UTF-8
RUN ( echo export LANG=en_US.UTF-8; echo export LC_COLLATE=C ) > /etc/profile.d/lang.sh
RUN ( echo setenv LANG en_US.UTF-8; echo setenv LC_COLLATE C ) > /etc/profile.d/lang.csh
