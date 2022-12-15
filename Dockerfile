FROM ubuntu:jammy

RUN apt-get update
RUN apt-get clean
RUN DEBIAN_FRONTEND=noninteractive apt-get install -qqy bash-static

RUN mkdir -p /target

WORKDIR "${HOME}"
ADD docker_entrypoint.sh "${HOME}/"
RUN chmod +x docker_entrypoint.sh

ENTRYPOINT ["./docker_entrypoint.sh"]
