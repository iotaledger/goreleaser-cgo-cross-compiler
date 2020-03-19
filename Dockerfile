FROM debian:buster

# GoReleaser
ENV GORELEASER_VERSION=0.127.0
ENV GORELEASER_SHA=bf7e0f34d1d46041f302a0dd773a5c70ff7476c147d3a30659a5a11e823bccbd
ENV GORELEASER_DOWNLOAD_FILE=goreleaser_Linux_x86_64.tar.gz
ENV GORELEASER_DOWNLOAD_URL=https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/${GORELEASER_DOWNLOAD_FILE}

# Golang
ENV GOLANG_VERSION=1.14.1
ENV GOLANG_SHA=2f49eb17ce8b48c680cdb166ffd7389702c0dec6effa090c324804a5cac8a7f8
ENV GOLANG_DOWNLOAD_FILE=go${GOLANG_VERSION}.linux-amd64.tar.gz
ENV GOLANG_DOWNLOAD_URL=https://dl.google.com/go/${GOLANG_DOWNLOAD_FILE}

# MUSL
ENV MUSL_x86_64_DOWNLOAD_FILE=x86_64-linux-musl-native.tgz
ENV MUSL_x86_64_DOWNLOAD=https://cross.iotmod.de/${MUSL_x86_64_DOWNLOAD_FILE}
ENV MUSL_AARCH64_DOWNLOAD_FILE=aarch64-linux-musl-cross.tgz
ENV MUSL_AARCH64_DOWNLOAD=https://cross.iotmod.de/${MUSL_AARCH64_DOWNLOAD_FILE}
ENV MUSL_ARMHF_DOWNLOAD_FILE=arm-linux-musleabihf-cross.tgz
ENV MUSL_ARMHF_DOWNLOAD=https://cross.iotmod.de/${MUSL_ARMHF_DOWNLOAD_FILE}
ENV MUSL_ARMV7L_DOWNLOAD_FILE=armv7l-linux-musleabihf-cross.tgz
ENV MUSL_ARMV7L_DOWNLOAD=https://cross.iotmod.de/${MUSL_ARMV7L_DOWNLOAD_FILE}

# Install cross compiling tools
RUN apt-get update && apt-get install -y build-essential wget git \
	gcc-arm-linux-gnueabi g++-arm-linux-gnueabi gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
	libc6-dev-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev \
	gcc-mingw-w64 g++-mingw-w64 \
	gcc-aarch64-linux-gnu g++-aarch64-linux-gnu && \
	apt-get -y autoremove && \
	wget -O docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-19.03.5.tgz" && \
	tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin/ && \
	rm docker.tgz

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
RUN	wget ${MUSL_ARMHF_DOWNLOAD}; \
	tar -xzf ${MUSL_ARMHF_DOWNLOAD_FILE} -C /etc/musl/; \
	rm ${MUSL_ARMHF_DOWNLOAD_FILE};
RUN	wget ${MUSL_ARMV7L_DOWNLOAD}; \
	tar -xzf ${MUSL_ARMV7L_DOWNLOAD_FILE} -C /etc/musl/; \
	rm ${MUSL_ARMV7L_DOWNLOAD_FILE};

# Add MUSL and Golang to PATH
ENV PATH=${PATH}:/etc/musl/x86_64-linux-musl-native/bin:/etc/musl/aarch64-linux-musl-cross/bin:/etc/musl/arm-linux-musleabihf-cross/bin:/etc/musl/armv7l-linux-musleabihf-cross/bin:/usr/local/go/bin

CMD ["goreleaser", "-v"]