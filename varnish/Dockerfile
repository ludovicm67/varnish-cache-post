ARG VARNISH_PKG_VERSION="6.4"

FROM "docker.io/varnish:${VARNISH_PKG_VERSION}"

ARG VARNISH_PKG_VERSION

RUN apt-get update && apt-get install -y build-essential automake libtool git python-docutils varnish-dev pkg-config libvarnishapi1 autotools-dev
RUN git clone --branch "${VARNISH_PKG_VERSION}" --single-branch https://github.com/varnish/varnish-modules.git /tmp/vm
WORKDIR /tmp/vm

RUN ./bootstrap \
  && ./configure \
  && make \
  && make check \
  && make install

COPY default.vcl /etc/varnish
