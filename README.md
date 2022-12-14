# GoReleaser CGO Cross Compiler with musl

[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=for-the-badge)](/LICENSE)

This is a Docker container to be able to cross compile Golang packages with enabled cgo together with [GoReleaser](https://goreleaser.com/).

### Supported OS and architectures:

- Windows (amd64)
- Linux (amd64, ARM64)
- macOS (amd64) **No CGO support**

### Used versions

- **GoLang**: 1.19.4
- **GoReleaser**: 1.12.3
- **Docker**: 20.10.21

### Docker

[Docker hub](https://hub.docker.com/r/iotaledger/goreleaser-cgo-cross-compiler)

```Docker
docker run --rm --privileged \
  -v $PWD:/go/src/github.com/[project]/[repo] \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w /go/src/github.com/[project]/[repo] \
  iotaledger/goreleaser-cgo-cross-compiler:latest goreleaser --snapshot --rm-dist
```
