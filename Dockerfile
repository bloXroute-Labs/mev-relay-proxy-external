# syntax=docker/dockerfile:1
FROM golang:1.20.10 as builder
ARG VERSION
ARG APP
ARG MAIN_FILE_PATH
ARG SECRET_TOKEN

WORKDIR /build

COPY go.mod ./
COPY go.sum ./

RUN go mod download
ADD . .
RUN --mount=type=cache,target=/root/.cache/go-build make build-for-docker

FROM alpine

RUN apk add --no-cache libgcc libstdc++ libc6-compat
WORKDIR /app
COPY --from=builder /build/mev-relay-proxy /app/mev-relay-proxy
EXPOSE 18550
ENTRYPOINT ["/app/mev-relay-proxy"]
