FROM ubuntu:14.04
MAINTAINER Edvinas Aleksejonokas <http://github.com/rezonanc>

EXPOSE 5901
ENV USER bitcoin
RUN mkdir /home/bitcoin
WORKDIR /home/bitcoin

# Install LXDE and VNC server
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y lxde-core lxterminal tightvncserver curl gnupg

# Download bitcoin
ENV BITCOIN_VERSION 0.14.2
RUN curl -SLO "https://bitcoin.org/bin/bitcoin-core-$BITCOIN_VERSION/bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz" \
 && curl -SLO "https://bitcoin.org/bin/bitcoin-core-$BITCOIN_VERSION/SHA256SUMS.asc"

# Verify and install download
ENV BITCOIN_KEY_FINGERPRINT 90C8019E36C2E964
RUN gpg --keyserver pgp.mit.edu --recv-keys $BITCOIN_KEY_FINGERPRINT \
 && gpg --verify --trust-model=always SHA256SUMS.asc \
 && gpg --decrypt --output SHA256SUMS SHA256SUMS.asc \
 && grep "bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz" SHA256SUMS | sha256sum -c - \
 && tar -xzf "bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz" -C /usr --strip-components=1 \
 && rm "bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz" SHA256SUMS.asc SHA256SUMS

# Copy VNC script that handles restarts
COPY run.sh /opt/
COPY bitcoin.desktop /opt/

ARG PUID=1000
RUN chown -R $PUID /home/bitcoin

CMD ["/opt/run.sh"]
