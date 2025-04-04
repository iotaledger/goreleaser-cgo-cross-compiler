FROM debian:bullseye

# GoReleaser
ENV GORELEASER_VERSION=2.8.2
ENV GORELEASER_SHA=847e2105d50da9133e567cf5450cd437ae29181cabf13ad42683151ba0f5b587
ENV GORELEASER_DOWNLOAD_FILE=goreleaser_Linux_x86_64.tar.gz
ENV GORELEASER_DOWNLOAD_URL=https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/${GORELEASER_DOWNLOAD_FILE}

# Golang
ENV GOLANG_VERSION=1.24.2
ENV GOLANG_SHA=68097bd680839cbc9d464a0edce4f7c333975e27a90246890e9f1078c7e702ad
ENV GOLANG_DOWNLOAD_FILE=go${GOLANG_VERSION}.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_URL=https://dl.google.com/go/${GOLANG_DOWNLOAD_FILE}

# Docker
ENV DOCKER_VERSION=28.0.4
ENV DOCKER_SHA=6b130fa5fb13516620d5ece0b63f63a495cede428bb2f9e24449022e9d72e0cb
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
RUN	wget ${DOCKER_DOWNLOAD_URL}
RUN	echo "${DOCKER_SHA}  ${DOCKER_DOWNLOAD_FILE}" | sha256sum -c - || exit 1; \
	tar --extract --file ${DOCKER_DOWNLOAD_FILE} --strip-components 1 --directory /usr/local/bin/; \
	rm ${DOCKER_DOWNLOAD_FILE}

# Download GoReleaser
RUN wget ${GORELEASER_DOWNLOAD_URL}
RUN echo "${GORELEASER_SHA} ${GORELEASER_DOWNLOAD_FILE}" | sha256sum -c - || exit 1; \
	tar -xzf ${GORELEASER_DOWNLOAD_FILE} -C /usr/bin/ goreleaser; \
	rm ${GORELEASER_DOWNLOAD_FILE};

# Download Golang
RUN wget ${GOLANG_DOWNLOAD_URL};
RUN	echo "${GOLANG_SHA} ${GOLANG_DOWNLOAD_FILE}" | sha256sum -c - || exit 1; \
	tar -xzf ${GOLANG_DOWNLOAD_FILE} -C /usr/local; \
	rm ${GOLANG_DOWNLOAD_FILE};

# Add Golang to PATH
ENV PATH=${PATH}:/usr/local/go/bin

CMD ["goreleaser", "-v"]