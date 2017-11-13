FROM ubuntu:16.04
MAINTAINER Mateusz Lerczak <mlerczak@pl.sii.eu>

ARG YOUTRACK_UID=2000
ARG YOUTRACK_USER="youtrack"
ARG YOUTRACK_ROOT="/opt/youtrack"
ARG YOUTRACK_VERSION="2017.3.37517"
ARG YOUTRACK_FILE="youtrack-${YOUTRACK_VERSION}.zip"

RUN \
    useradd -u ${YOUTRACK_UID} -s /bin/bash -d ${YOUTRACK_ROOT} ${YOUTRACK_USER}

RUN \
    apt-get update \
    && apt-get install -y \
        supervisor \
        wget \
        unzip

COPY container /

RUN \
    mkdir -p /var/log/supervisor

# Download and extract YouTrack
RUN \
    wget https://download.jetbrains.com/charisma/${YOUTRACK_FILE} \
    && unzip ${YOUTRACK_FILE} \
    && mv youtrack-${YOUTRACK_VERSION} ${YOUTRACK_ROOT} \
    && rm ${YOUTRACK_FILE}

# Remove files for Windows and Mac
RUN \
    rm -rf "${YOUTRACK_ROOT}/internal/java/mac-x64" \
    && rm -rf "${YOUTRACK_ROOT}/internal/java/windows-amd64"

# Chown YouTrack files
RUN \
    chown -R youtrack:youtrack ${YOUTRACK_ROOT}

CMD ["/usr/bin/supervisord","-n","-c","/etc/supervisor/conf.d/youtrack.conf"]

WORKDIR ${YOUTRACK_ROOT}

USER ${YOUTRACK_USER}
