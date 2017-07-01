FROM andronux/ruby2.1.5
MAINTAINER Karim EL MANSOURI <karim.elmansouri@gmail.com>

# Install gems
ENV APP_HOME /app
ENV HOME /root
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
COPY Gemfile* $APP_HOME/
RUN bundle install

# Upload source
COPY . $APP_HOME

# Start server
ENV PORT 80
ENTRYPOINT ["./entrypoint.sh"]
EXPOSE 80
