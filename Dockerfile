FROM rabbitmq:3

# Configuration files
ADD etc/security/limits.conf /etc/security/limits.conf
ADD etc/sysctl.conf /etc/sysctl.conf

ADD rabbitmq.config /etc/rabbitmq/
COPY erlang.cookie /var/lib/rabbitmq/.erlang.cookie
Run chmod u+rw /etc/rabbitmq/rabbitmq.config

RUN chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
RUN chmod 400 /var/lib/rabbitmq/.erlang.cookie

# Add scripts
ADD run.sh /run.sh
RUN chmod 755 ./*.sh

# Expose ports.
EXPOSE 1883 5672 15672 25672 35197

CMD ["/run.sh"]
