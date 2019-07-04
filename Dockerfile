FROM debian:stretch-slim

LABEL maintainer="Kerem Bozdas <krmbzds.github@gmail.com>"
LABEL repository="https://github.com/krmbzds/docker-activitywatch"

RUN mkdir /app
WORKDIR /app

RUN apt-get -qq -y update \
  && apt-get install -qq -y --no-install-recommends ca-certificates unzip wget \
  && wget -q -O - https://api.github.com/repos/activitywatch/activitywatch/releases \
  | grep "https" \
  | grep "linux-x86_64" \
  | head -1 \
  | cut -d : -f 2,3 \
  | tr -d '", ' \
  | wget -q -i - \
  && unzip ./activitywatch*.zip \
  && rm ./activitywatch*.zip \
  && chmod +x ./activitywatch/aw-server \
  && apt-get purge -qq -y --auto-remove ca-certificates unzip wget

EXPOSE 5600
SHELL ["/bin/bash", "-c"]
CMD ["/app/activitywatch/aw-server", "--host", "0.0.0.0"]
