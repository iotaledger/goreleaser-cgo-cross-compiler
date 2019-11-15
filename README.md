# GoReleaser CGO Cross Compiler

[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=for-the-badge)](/LICENSE)

This is a Docker container to be able to cross compile Golang packages with enabled cgo together with [GoReleaser](https://goreleaser.com/).

### Supported OS and architectures:
* Windows (amd64)
* Linux (amd64, ARMv6, ARMv7, ARM64)
* OSX (amd64)

### Docker

[Docker hub](https://hub.docker.com/r/iotmod/goreleaser-cgo-cross-compiler)

```Docker
docker run --rm --privileged \
  -v $PWD:/go/src/gitlab.com/[project]/[repo] \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w /go/src/github.com/[project]/[repo] \
  iotmod/goreleaser-cgo-cross-compiler goreleaser --snapshot --rm-dist
```

### License
This project is forked from [goreleaser-xcgo](https://github.com/mailchain/goreleaser-xcgo)