# GoReleaser CGO Cross Compiler with musl

[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=for-the-badge)](/LICENSE)

This is a Docker container to be able to cross compile Golang packages with enabled cgo together with [GoReleaser](https://goreleaser.com/).

### Supported OS and architectures:

- Windows (amd64)
- Linux (amd64, ARMv7, ARM64)
- macOS (amd64) **No CGO support**

### Used versions

- **GoLang**: 1.13.7
- **GoReleaser**: 0.126.0
- **MUSL**: 2019-12-20 Release

### Docker

[Docker hub](https://hub.docker.com/r/iotmod/goreleaser-cgo-cross-compiler)

```Docker
docker run --rm --privileged \
  -v $PWD:/go/src/gitlab.com/[project]/[repo] \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -w /go/src/github.com/[project]/[repo] \
  iotmod/goreleaser-cgo-cross-compiler:1.13.5-musl goreleaser --snapshot --rm-dist
```
