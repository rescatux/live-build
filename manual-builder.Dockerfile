FROM i386/debian:12

ARG RESCATUX_BUILDER_UID
ARG RESCATUX_BUILDER_GID

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -qq update -y && \
    apt-get -qq install -y \
                       sudo \
                       git

RUN apt-get -qq install -y \
                       dpkg-dev \
                       debhelper-compat \
                       po4a \
                       gettext

RUN apt-get -qq install -y locales
RUN dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

RUN apt-get -qq update -y

RUN echo "rbuilder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rbuilder-sudo
RUN groupadd -g ${RESCATUX_BUILDER_GID} rbuilder
RUN useradd -u ${RESCATUX_BUILDER_UID} rbuilder -g rbuilder
ADD --chown=${RESCATUX_BUILDER_UID}:${RESCATUX_BUILDER_GID} . /live-build-repo
RUN mkdir --parents /deb-output/live-build-build
RUN mkdir /live-build-release
RUN chown ${RESCATUX_BUILDER_UID}:${RESCATUX_BUILDER_GID} /live-build-release
RUN chown ${RESCATUX_BUILDER_UID}:${RESCATUX_BUILDER_GID} /deb-output
RUN chown ${RESCATUX_BUILDER_UID}:${RESCATUX_BUILDER_GID} /deb-output/live-build-build

USER rbuilder
RUN git clone /live-build-repo /deb-output/live-build-build

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

WORKDIR /deb-output/live-build-build
