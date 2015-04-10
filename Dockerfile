FROM vbatts/slackware-base:latest
MAINTAINER roninkenji

RUN echo "http://ftp.osuosl.org/.2/slackware/slackware64-14.1/" >> /etc/slackpkg/mirrors
RUN slackpkg -batch=on -default_answer=yes update && slackpkg -batch=on -default_answer=yes upgrade-all && rm -rv /usr/doc

