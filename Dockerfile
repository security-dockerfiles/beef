FROM ruby:2.3-slim
LABEL maintainer "Ilya Glotov <contact@ilyaglotov.com>"

ENV LANG C.UTF-8

ENV DEPS build-essential \
         git \
         libsqlite3-dev

RUN apt-get update \
  && apt-get install -y \
    $DEPS \
    sqlite3 \
    \
  && useradd -m beef \
  \
  && git clone --depth=1 \
    --branch=master \
    https://github.com/beefproject/beef.git \
    /home/beef/beef \
    \
  && cd /home/beef/beef \
  && gem install rake \
  && bundle install --without test development \
  \
  && chown -R beef /home/beef/beef \
  \
  && rm -rf /home/beef/beef/.git \
  && apt-get purge -y $DEPS \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /home/beef/beef

VOLUME /home/beef/.beef

USER beef

EXPOSE 3000 6789 61985 61986

ENTRYPOINT ["./beef"]
