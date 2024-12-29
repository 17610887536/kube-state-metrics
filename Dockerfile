ARG GOVERSION=1.23
ARG GOARCH
ARG GOARCH=adm64

FROM crpi-w4rfgpyx2sgqpdgm.cn-hangzhou.personal.cr.aliyuncs.com/cpp-images/kube-state-metres:1.20 AS builder

ARG GOARCH
ENV GOARCH=${GOARCH}
WORKDIR /go/src/k8s.io/kube-state-metrics/
COPY . /go/src/k8s.io/kube-state-metrics/

RUN make install-tools && make build-local

FROM gcr.io/distroless/static-debian12:latest-${GOARCH}
COPY --from=builder /go/src/k8s.io/kube-state-metrics/kube-state-metrics /

USER nobody

ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]

EXPOSE 8080 8081
