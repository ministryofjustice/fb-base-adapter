FROM ruby:3.2.2-alpine3.18

ARG UID=1001

RUN apk add build-base bash libcurl

RUN addgroup -g ${UID} -S appgroup && \
  adduser -u ${UID} -S appuser -G appgroup

WORKDIR /app

RUN chown appuser:appgroup /app

COPY --chown=appuser:appgroup Gemfile Gemfile.lock ./

RUN gem install bundler

RUN bundle config set no-cache 'true'
RUN bundle config set without 'test development'
RUN bundle config set jobs '4'
RUN bundle install

COPY --chown=appuser:appgroup . .

ENV APP_PORT=4567
EXPOSE $APP_PORT

USER ${UID}
CMD ["./start.sh"]
