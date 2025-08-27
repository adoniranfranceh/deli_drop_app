FROM ruby:3.3.6

WORKDIR /app

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get update -y \
  && apt-get install -y nodejs \
  && npm install -g yarn \
  && apt-get install -y \
    chromium \
    chromium-driver \
    fonts-liberation \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    xdg-utils \
    wget \
    unzip \
    --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

CMD ["rails", "server", "-b", "0.0.0.0"]
