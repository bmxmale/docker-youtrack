FROM ubuntu:16.04
MAINTAINER Mateusz Lerczak <mlerczak@pl.sii.eu>

ARG YOUTRACK_UID=2000
ARG YOUTRACK_ROOT="/opt/youtrack"

ENV YOUTRACK_VERSION="2017.3.37517"
ENV YOUTRACK_FILE="youtrack-${YOUTRACK_VERSION}.zip"

RUN \
    useradd -u ${YOUTRACK_UID} -ms /bin/bash youtrack

RUN \
    apt-get update \
    && apt-get install -y \
        supervisor \
        wget \
        unzip

COPY container /

RUN \
    mkdir -p /var/log/supervisor

RUN \
    wget https://download.jetbrains.com/charisma/${YOUTRACK_FILE} \
    && unzip ${YOUTRACK_FILE} \
    && mv youtrack-${YOUTRACK_VERSION} ${YOUTRACK_ROOT} \
    && rm ${YOUTRACK_FILE} \
    && chown -R youtrack:youtrack ${YOUTRACK_ROOT}

CMD ["/usr/bin/supervisord"]
