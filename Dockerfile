FROM arm32v7/golang:alpine AS build
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add git
WORKDIR /go/src/swirl/
ADD . .
ENV GO111MODULE on
ENV GOPROXY=https://goproxy.cn,direct
RUN CGO_ENABLED=0 go build -ldflags "-s -w"

FROM arm32v7/alpine:3.9
LABEL maintainer="cuigh <noname@live.com>"
WORKDIR /app
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories
RUN apk add --no-cache ca-certificates
COPY --from=build /go/src/swirl/swirl .
COPY --from=build /go/src/swirl/config ./config/
COPY --from=build /go/src/swirl/assets ./assets/
COPY --from=build /go/src/swirl/views ./views/
EXPOSE 8001
ENTRYPOINT ["/app/swirl"]
