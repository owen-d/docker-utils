FROM logstash:2.3

RUN /opt/logstash/bin/plugin install logstash-input-sqs

COPY config/logstash.conf /logstash.conf

CMD ["/opt/logstash/bin/logstash", "-f", "/logstash.conf", "--allow-env", "|", "tee", "-a", "${LOGFILE:-/tmp/logstash.log}"]
