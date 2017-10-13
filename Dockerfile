FROM ruby:2.4-slim

EXPOSE 3000

ADD https://deb.nodesource.com/setup_7.x node_setup

RUN bash node_setup \
    && apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        make \
        nodejs \
        libpq-dev

WORKDIR /microservice

ARG INSTALL_GROUPS

COPY Gemfile Gemfile.lock /microservice/

RUN echo "Installing groups:" $INSTALL_GROUPS

RUN bundle install --with $INSTALL_GROUPS

COPY . /microservice

CMD ["bundle", "exec", "rails", "server"]
