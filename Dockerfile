FROM ubuntu:jammy

RUN apt-get update
RUN apt-get clean
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qqy bash-static

RUN mkdir -p /target

WORKDIR "${HOME}"
ADD run.sh "${HOME}/"
RUN chmod +x run.sh

ENTRYPOINT ["./run.sh"]
