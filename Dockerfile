FROM ruby:2.6-slim
LABEL maintainer "Ilya Milov <contact@ilya.app>"

ARG COMMIT=0b4177561858a9a64d7d519153a3fcd7be691991

ENV LANG="C.UTF-8" \
    DEPS="build-essential \
          libsqlite3-dev \
          libcurl4-openssl-dev \
          wget"

RUN apt-get update \
  && apt-get install -y $DEPS \
                        sqlite3 \
                        nodejs \
  && useradd -m beef \
  && wget -q https://github.com/beefproject/beef/tarball/$COMMIT -O beef.tgz \
  && mkdir /home/beef/beef \
  && tar -xzf beef.tgz --strip 1 -C /home/beef/beef \
  && cd /home/beef/beef \
  && chown -R beef:beef /home/beef \
  && gem install bundler:2.1.4 \
  && bundle config set --local without 'test development' \
  && bundle install \
  \
  && rm -rf beef.tgz \
  && apt-get purge -y $DEPS \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /home/beef/beef

USER beef

EXPOSE 3000 6789 61985 61986

COPY entrypoint.sh /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]
