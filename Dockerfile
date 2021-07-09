FROM ruby:3.0.2-alpine3.13

ARG UID=1001

RUN apk add build-base bash libcurl

RUN addgroup -g ${UID} -S appgroup && \
  adduser -u ${UID} -S appuser -G appgroup

WORKDIR /app

RUN chown appuser:appgroup /app

COPY --chown=appuser:appgroup Gemfile Gemfile.lock ./

RUN gem install bundler

ARG BUNDLE_ARGS='--jobs 4 --without test development'
RUN bundle install --no-cache ${BUNDLE_ARGS}

COPY --chown=appuser:appgroup . .

ENV APP_PORT 4567
EXPOSE $APP_PORT

USER ${UID}
CMD ./start.sh
