# README

## Setup

With ruby ruby-3.2.1, redis and postgresql installed:

```
bundle install
bundle exec rails db:setup
```

## Run
```
bundle exec rails s
bundle exec sidekiq -C config/sidekiq.yml
```

## Test
```
bundle exec rspec
```

## Mails
For development is used Mailcatcher

```
gem install mailcatcher
mailcatcher
Go to http://127.0.0.1:1080/
```
