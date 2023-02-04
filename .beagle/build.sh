#!/bin/bash 

set -ex

mkdir -p dist

make gen-go

# amd64
export CGO_ENABLED=1
go run build.go build

# arm64
export GOARCH=arm64
export CC=aarch64-linux-gnu-gcc
export CXX=aarch64-linux-gnu-g++
go run build.go build

# ppc64le
export GOARCH=ppc64le
export CC=powerpc64le-linux-gnu-gcc
export CXX=powerpc64le-linux-gnu-g++
go run build.go build

# mips64le
export GOARCH=mips64le
export CC=mips64el-linux-gnuabi64-gcc
export CXX=mips64el-linux-gnuabi64-g++
go run build.go build