FROM debian:bullseye

# GoReleaser
ENV GORELEASER_VERSION=1.10.3
ENV GORELEASER_SHA=942c2ddc87b589fd73f5b612909c31298b1e8b8a7ee9b6a463dd5038030b1cc2
ENV GORELEASER_DOWNLOAD_FILE=goreleaser_Linux_x86_64.tar.gz
ENV GORELEASER_DOWNLOAD_URL=https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/${GORELEASER_DOWNLOAD_FILE}

# Golang
ENV GOLANG_VERSION=1.19
ENV GOLANG_SHA=464b6b66591f6cf055bc5df90a9750bf5fbc9d038722bb84a9d56a2bea974be6
ENV GOLANG_DOWNLOAD_FILE=go${GOLANG_VERSION}.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_URL=https://dl.google.com/go/${GOLANG_DOWNLOAD_FILE}

# MUSL
ENV MUSL_DOWNLOAD_SOURCE=https://musl.cc/

ENV MUSL_x86_64_DOWNLOAD_FILE=x86_64-linux-musl-native.tgz
ENV MUSL_x86_64_DOWNLOAD=${MUSL_DOWNLOAD_SOURCE}${MUSL_x86_64_DOWNLOAD_FILE}
ENV MUSL_AARCH64_DOWNLOAD_FILE=aarch64-linux-musl-cross.tgz
ENV MUSL_AARCH64_DOWNLOAD=${MUSL_DOWNLOAD_SOURCE}${MUSL_AARCH64_DOWNLOAD_FILE}

# Docker
ENV DOCKER_VERSION=20.10.9
ENV DOCKER_SHA=caf74e54b58c0b38bb4d96c8f87665f29b684371c9a325562a3904b8c389995e
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
