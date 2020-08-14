FROM ruby:2.5-slim
LABEL maintainer "Ilya Glotov <contact@ilyaglotov.com>"

ARG COMMIT=8876f69ba618c5872b3fb1bbe543892ad05de54e

ENV LANG="C.UTF-8" \
    DEPS="build-essential \
          git \
          libsqlite3-dev \
          libcurl4-openssl-dev"

RUN apt-get update \
  && apt-get install -y $DEPS \
                        sqlite3 \
                        nodejs \
  && useradd -m beef \
  && git clone --depth=1 \
    --branch=master \
    https://github.com/beefproject/beef.git \
    /home/beef/beef \
  && chown -R beef:beef /home/beef \
  && cd /home/beef/beef \
  && bundle install --without test development \
  \
  && rm -rf /home/beef/beef/.git \
  && apt-get purge -y $DEPS \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /home/beef/beef

VOLUME /home/beef/.beef

USER beef

EXPOSE 3000 6789 61985 61986

COPY entrypoint.sh /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]
