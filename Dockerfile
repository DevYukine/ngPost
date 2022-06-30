# Usage:
# Assuming you want to share the "files" subdirectory
# and your ngPost config is ngPost.docker.conf.
# $ docker build -t ngpost .
# $ docker run -it -v $PWD/files:/root/files -v $PWD/ngPost.docker.conf:/root/.ngPost ngpost ARGUMENTS

FROM ubuntu:20.04

# Define software versions.
ARG NGPOST_VERSION=4.16

# Define software download URLs.
ARG NGPOST_URL=https://github.com/mbruel/ngPost/archive/v${NGPOST_VERSION}.tar.gz

ENV LANG en_GB.UTF-8
ENV LC_ALL en_GB.UTF-8

# Define working directory.
WORKDIR /usr/src/ngPost

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update
RUN apt install -y tzdata

# Install dependencies.
RUN apt update -y && apt install -y \
    curl \
    qt5-default \
    libssl-dev \
    build-essential \
    nodejs \
    npm \
    git \
    wget \
    python2-dev \
    rar \
    bash \
    language-pack-ja \
    language-pack-zh* \
    language-pack-ko

RUN \
    # Download sources for ngPost.
    echo "Downloading ngPost package..." && \
    mkdir ngPost && \
    curl -# -L ${NGPOST_URL} | tar xz --strip 1 -C ngPost && \
    # Compile.
    cd ngPost/src && \
    /usr/lib/qt5/bin/qmake && \
    make && \
    cp ngPost /usr/bin/ngPost && \
    cd && \
    # Cleanup.
    rm -rf /usr/src/ngPost/* /usr/src/ngPost/.[!.]*


# Compile and install ParPar.

RUN \
    # Download sources for parpar
    echo "Downloading & Installing ParPar" && \
    npm install -g @animetosho/parpar --unsafe-perm

# Copy default config
COPY ngPost.docker.conf /root/.ngPost

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]