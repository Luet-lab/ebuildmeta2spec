FROM golang as builder
ENV GOPATH=/go
RUN apt-get install git
RUN mkdir -p $GOPATH && go get github.com/Sabayon/pkgs-checker && go install github.com/Sabayon/pkgs-checker

FROM gentoo/stage3-amd64
RUN emerge-webrsync
COPY --from=builder /go/bin/pkgs-checker /usr/bin/pkgs-checker
RUN chmod +x /usr/bin/pkgs-checker
RUN wget https://github.com/mikefarah/yq/releases/download/3.3.0/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
RUN mkdir -p /opt/ebuildmeta
COPY *.sh /opt/ebuildmeta/
RUN chmod +x /opt/ebuildmeta/*.sh
ENTRYPOINT ["/opt/ebuildmeta/ebuildmeta_depends.sh"]
