FROM dockercore/golang-cross

ENV GORELEASER_VERSION=0.121.0
ENV GORELEASER_SHA=da59c1afcdc1604744e502b35f1cae8d3cfee77f688af20603d4c4a19e586da2

ENV GORELEASER_DOWNLOAD_FILE=goreleaser_Linux_x86_64.tar.gz
ENV GORELEASER_DOWNLOAD_URL=https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/${GORELEASER_DOWNLOAD_FILE}

RUN  wget ${GORELEASER_DOWNLOAD_URL}; \
			echo "$GORELEASER_SHA $GORELEASER_DOWNLOAD_FILE" | sha256sum -c - || exit 1; \
			tar -xzf $GORELEASER_DOWNLOAD_FILE -C /usr/bin/ goreleaser; \
			rm $GORELEASER_DOWNLOAD_FILE;

RUN apt-get update && apt-get install -y gcc-arm-linux-gnueabi g++-arm-linux-gnueabi gcc-aarch64-linux-gnu g++-aarch64-linux-gnu && \
	wget -O docker.tgz "https://download.docker.com/linux/static/stable/x86_64/docker-19.03.5.tgz" && \
	tar --extract --file docker.tgz --strip-components 1 --directory /usr/local/bin/ && \
	rm docker.tgz

CMD ["goreleaser", "-v"]