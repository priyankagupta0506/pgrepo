FROM rails:4.2.6
LABEL maintainer "Priyanka Gupta"

# Source code should be in the /usr/src/app folder
WORKDIR /usr/src/app

# Install dependencies in a cache-friendly way
COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle install
RUN apt-get update && apt-get install -y vim
# Now copy the rest of the source code
COPY . /usr/src/app
RUN chmod +x /usr/src/app/entrypoint.sh

# Run the rails server by default
EXPOSE 3000
ENTRYPOINT ["bash","/usr/src/app/entrypoint.sh"]
CMD ["rails", "server", "-b", "0.0.0.0"]
