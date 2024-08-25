FROM varilink/tools/bconsole

RUN                                                                            \
  sudo apt-get update                                                       && \
  sudo apt-get install --no-install-recommends --yes                           \
    libio-prompter-perl                                                        \
    libyaml-perl                                                               \
    perl-modules-5.36

COPY docker-entrypoint.sh /
COPY select-site.pl /

ENTRYPOINT [ "bash", "/docker-entrypoint.sh" ]
