FROM debian:bullseye

# GoReleaser
ENV GORELEASER_VERSION=1.19.2
ENV GORELEASER_SHA=27c7397b816c43098f88cbccc5aeec3df929fb857f28b2cb8e885d09458ada1e
ENV GORELEASER_DOWNLOAD_FILE=goreleaser_Linux_x86_64.tar.gz
ENV GORELEASER_DOWNLOAD_URL=https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/${GORELEASER_DOWNLOAD_FILE}

# Golang
ENV GOLANG_VERSION=1.21.0
ENV GOLANG_SHA=d0398903a16ba2232b389fb31032ddf57cac34efda306a0eebac34f0965a0742
ENV GOLANG_DOWNLOAD_FILE=go${GOLANG_VERSION}.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_URL=https://dl.google.com/go/${GOLANG_DOWNLOAD_FILE}

# Docker
ENV DOCKER_VERSION=24.0.5
ENV DOCKER_SHA=0a5f3157ce25532c5c1261a97acf3b25065cfe25940ef491fa01d5bea18ddc86
ENV DOCKER_DOWNLOAD_FILE=docker-${DOCKER_VERSION}.tgz
ENV DOCKER_DOWNLOAD_URL=https://download.docker.com/linux/static/stable/x86_64/${DOCKER_DOWNLOAD_FILE}

# Install cross compiling tools
RUN apt-get update && apt-get install -y \
	build-essential \
	wget \
	git \
	cmake \
	libc6-dev-armel-cross \
	binutils-arm-linux-gnueabi \
	libncurses5-dev \
	gcc-mingw-w64 \
	g++-mingw-w64 \
	gcc-aarch64-linux-gnu \
	g++-aarch64-linux-gnu && \
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

# Add Golang to PATH
ENV PATH=${PATH}:/usr/local/go/bin

CMD ["goreleaser", "-v"]
