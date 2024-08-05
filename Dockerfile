FROM ruby:3.0.0

ENV RAILS_ENV development

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update -qq  \
  && apt-get install -y \
    apt-utils \
    nodejs \
    yarn \
    nano \
    default-mysql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /chat_system_api
WORKDIR /chat_system_api

COPY Gemfile /chat_system_api/Gemfile
COPY Gemfile.lock /chat_system_api/Gemfile.lock

RUN bundle install
RUN gem install bundler 

COPY . /chat_system_api

EXPOSE 3000 3035

RUN chmod +x /chat_system_api/start.sh

CMD ["/chat_system_api/start.sh"]