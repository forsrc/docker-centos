FROM centos:7
MAINTAINER forsrc@gmail.com


ARG USER
ENV USER=${USER:-forsrc}
ARG PASSWD
ARG PASSWD=${PASSWD:-forsrc}

RUN yum makecache
#RUN yum install -y epel*
RUN yum install -y systemd sudo

RUN yum clean all && rm -rf /var/cache/yum/*


RUN useradd -m --shell /bin/bash $USER && \
    echo "$USER:$PASSWD" | chpasswd && \
    echo "$USER ALL=(ALL) ALL" >> /etc/sudoers

RUN echo  "#\!/bin/sh" | sed -e "s/\\\\//g"                              >  /start.sh
RUN echo echo [\`date \'+%Y-%m-%d %H:%M:%S\'\`] [start...] \`hostname\`  >> /start.sh
RUN echo ""                                                              >> /start.sh
RUN echo echo [\`date \'+%Y-%m-%d %H:%M:%S\'\`] [end.....] \`hostname\`  >> /start.sh
RUN chmod +x /start.sh
RUN cat /start.sh 1>&2

#COPY entrypoint.sh /
RUN echo  "#\!/bin/sh" | sed -e "s/\\\\//g" >  /entrypoint.sh
RUN echo /start.sh                          >> /entrypoint.sh
RUN echo exec \"\$@\"                       >> /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN cat /entrypoint.sh 1>&2

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /home/$USER
USER $USER

#EXPOSE 8080

CMD [ \
    "/usr/sbin/init" \
]
