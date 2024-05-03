FROM alpine:3.19

RUN apk add --update git openssh

RUN addgroup -g 1000 -S git && \
    adduser -u 1000 -S git -G git

ADD --chown=git script.sh /

RUN mkdir /home/git/.ssh/  && \
    chown git /home/git/.ssh && \
	mkdir /repository && \
	chown git /repository && \
	touch /home/git/.ssh/known_hosts && \
	echo "" >> /etc/ssh/ssh_config && \
	echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config &&\
	chown git /etc/ssh/ssh_config
RUN chmod -R a+rwx /home/git

USER git

CMD ["/script.sh"]