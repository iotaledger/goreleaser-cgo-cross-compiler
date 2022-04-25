FROM debian:buster

# GoReleaser
ENV GORELEASER_VERSION=1.8.3
ENV GORELEASER_SHA=304fa012709d12800528b124c9dbeabdcf8918f5e77b3877916e705798ed7962
ENV GORELEASER_DOWNLOAD_FILE=goreleaser_Linux_x86_64.tar.gz
ENV GORELEASER_DOWNLOAD_URL=https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/${GORELEASER_DOWNLOAD_FILE}

# Golang
ENV GOLANG_VERSION=1.18.1
ENV GOLANG_SHA=b3b815f47ababac13810fc6021eb73d65478e0b2db4b09d348eefad9581a2334
ENV GOLANG_DOWNLOAD_FILE=go${GOLANG_VERSION}.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_URL=https://dl.google.com/go/${GOLANG_DOWNLOAD_FILE}

# MUSL
ENV MUSL_DOWNLOAD_SOURCE=https://musl.cc/

ENV MUSL_x86_64_DOWNLOAD_FILE=x86_64-linux-musl-native.tgz
ENV MUSL_x86_64_DOWNLOAD=${MUSL_DOWNLOAD_SOURCE}${MUSL_x86_64_DOWNLOAD_FILE}
ENV MUSL_AARCH64_DOWNLOAD_FILE=aarch64-linux-musl-cross.tgz
ENV MUSL_AARCH64_DOWNLOAD=${MUSL_DOWNLOAD_SOURCE}${MUSL_AARCH64_DOWNLOAD_FILE}

# Docker
ENV DOCKER_VERSION=20.10.8
ENV DOCKER_SHA=7ea11ecb100fdc085dbfd9ab1ff380e7f99733c890ed815510a5952e5d6dd7e0
ENV DOCKER_DOWNLOAD_FILE=docker-${DOCKER_VERSION}.tgz
ENV DOCKER_DOWNLOAD_URL=https://download.docker.com/linux/static/stable/x86_64/${DOCKER_DOWNLOAD_FILE}

# Install cross compiling tools
RUN apt-get update && apt-get install -y build-essential wget git cmake \
	libc6-dev-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev \
	gcc-mingw-w64 g++-mingw-w64 \
	gcc-aarch64-linux-gnu g++-aarch64-linux-gnu && \
	apt-get -y autoremove

# Download Docker
RUN	wget ${DOCKER_DOWNLOAD_URL}; \
	echo "${DOCKER_SHA} ${DOCKER_DOWNLOAD_FILE}" | sha256sum -c - || exit 1; \
	tar --extract --file ${DOCKER_DOWNLOAD_FILE} --strip-components 1 --directory /usr/local/bin/; \
	rm ${DOCKER_DOWNLOAD_FILE}

# Download GoReleaser
RUN wget ${GORELEASER_DOWNLOAD_URL}; \
	echo "${GORELEASER_SHA} ${GORELEASER_DOWNLOAD_FILE}" | sha256sum -c - || exit 1; \
	tar -xzf ${GORELEASER_DOWNLOAD_FILE} -C /usr/bin/ goreleaser; \
	rm ${GORELEASER_DOWNLOAD_FILE};

# Download Golang
RUN wget ${GOLANG_DOWNLOAD_URL}; \
	echo "${GOLANG_SHA} ${GOLANG_DOWNLOAD_FILE}" | sha256sum -c - || exit 1; \
	tar -xzf ${GOLANG_DOWNLOAD_FILE} -C /usr/local; \
	rm ${GOLANG_DOWNLOAD_FILE};

# Download MUSL
RUN mkdir /etc/musl;

RUN wget ${MUSL_x86_64_DOWNLOAD}; \
	tar -xzf ${MUSL_x86_64_DOWNLOAD_FILE} -C /etc/musl/; \
	rm ${MUSL_x86_64_DOWNLOAD_FILE};
RUN	wget ${MUSL_AARCH64_DOWNLOAD}; \
	tar -xzf ${MUSL_AARCH64_DOWNLOAD_FILE} -C /etc/musl/; \
	rm ${MUSL_AARCH64_DOWNLOAD_FILE};

# Add MUSL and Golang to PATH
ENV PATH=${PATH}:/etc/musl/x86_64-linux-musl-native/bin:/etc/musl/aarch64-linux-musl-cross/bin:/usr/local/go/bin

CMD ["goreleaser", "-v"]
