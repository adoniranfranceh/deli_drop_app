FROM ruby:3.3.6

COPY Gemfile* ./
RUN bundle install

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update -y
RUN apt-get install -y nodejs
RUN npm install -g yarn

WORKDIR /app
COPY . /app

RUN yarn install

CMD ["rails", "server", "-b", "0.0.0.0"]
