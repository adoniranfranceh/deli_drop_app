FROM ruby:3.3.6

WORKDIR /app

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get update -y \
  && apt-get install -y nodejs \
  && npm install -g yarn

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]
