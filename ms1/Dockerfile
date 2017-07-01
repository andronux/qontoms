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
EXPOSE 80
CMD ["bundle", "exec", "ruby", "web.rb", "-s", "Puma", "-p", "$PORT"]
