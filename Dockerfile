FROM ruby
MAINTAINER inokappa
RUN apt-get update
ADD . /app
RUN chmod 755 /app/run.sh
RUN mkdir -p /app/output/html
RUN mkdir -p /app/output/png
RUN gem install aws-sdk nokogiri googlecharts --no-ri --no-rdoc

CMD /app/run.sh
