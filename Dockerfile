FROM debian:11

# GoReleaser
ENV GORELEASER_VERSION=1.16.1
ENV GORELEASER_SHA=fa370201538b2a93d960ca620cb3e26e25adba5abd115bb91f3517086f2324b7
ENV GORELEASER_DOWNLOAD_FILE=goreleaser_Linux_x86_64.tar.gz
ENV GORELEASER_DOWNLOAD_URL=https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/${GORELEASER_DOWNLOAD_FILE}

# Golang
ENV GOLANG_VERSION=1.20.2
ENV GOLANG_SHA=4eaea32f59cde4dc635fbc42161031d13e1c780b87097f4b4234cfce671f1768
ENV GOLANG_DOWNLOAD_FILE=go${GOLANG_VERSION}.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_URL=https://dl.google.com/go/${GOLANG_DOWNLOAD_FILE}

# Docker
ENV DOCKER_VERSION=20.10.23
ENV DOCKER_SHA=0ee39f72cc434137d294c14d30897826bad6e24979e421f51a252769ad37e6d1
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
