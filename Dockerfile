FROM debian:bookworm

RUN                                                                            \
  apt-get update                                                            && \
  apt-get install --no-install-recommends --yes                                \
    bacula-console                                                             \
    libio-prompter-perl                                                        \
    libyaml-perl                                                               \
    perl-modules-5.36

COPY docker-entrypoint.sh /
COPY select-site.pl /
COPY bconsole.conf /etc/bacula/


ENTRYPOINT [ "bash", "/docker-entrypoint.sh" ]
