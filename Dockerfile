FROM elixir:1.10-alpine

ENV TERM xterm
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV APP_PATH /opt/app

COPY mix.exs $APP_PATH/mix.exs
COPY assets/package.json $APP_PATH/assets/package.json

WORKDIR $APP_PATH

RUN apk update && \
    apk upgrade && \
    apk add --no-cache --update build-base openssh nodejs nodejs-npm inotify-tools

RUN mix local.hex --force && mix local.rebar --force

CMD ["/bin/sh"]