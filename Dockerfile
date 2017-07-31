FROM ubuntu:14.04
MAINTAINER Edvinas Aleksejonokas <http://github.com/rezonanc>

# Install LXDE and VNC server
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y lxde-core lxterminal tightvncserver curl gnupg

# Install additional packages
RUN apt-get install -y dos2unix

# Download litecoin
ENV LITECOIN_VERSION 0.13.2
RUN curl -SLO "https://download.litecoin.org/litecoin-$LITECOIN_VERSION/linux/litecoin-$LITECOIN_VERSION-x86_64-linux-gnu.tar.gz" \
 && curl -SLO "https://download.litecoin.org/litecoin-$LITECOIN_VERSION/linux/litecoin-$LITECOIN_VERSION-linux-signatures.asc" \
 && mv litecoin-$LITECOIN_VERSION-linux-signatures.asc SHA256SUMS.asc \
 && dos2unix SHA256SUMS.asc

# Verify and install download
ENV LITECOIN_KEY_FINGERPRINT fe3348877809386c
RUN gpg --keyserver pgp.mit.edu --recv-keys $LITECOIN_KEY_FINGERPRINT \
 && gpg --verify --trust-model=always SHA256SUMS.asc \
 && gpg --decrypt --output SHA256SUMS SHA256SUMS.asc \
 && grep "x86_64" SHA256SUMS | sha256sum -c - \
 && tar -xzf "litecoin-$LITECOIN_VERSION-x86_64-linux-gnu.tar.gz" -C /usr --strip-components=1 \
 && rm "litecoin-$LITECOIN_VERSION-x86_64-linux-gnu.tar.gz" "SHA256SUMS.asc" SHA256SUMS

# Copy VNC script that handles restarts
COPY run.sh /opt/
COPY litecoin.desktop /opt/

# Prepare environment
RUN mkdir -p /home/litecoin && chmod uog=rwx /home/litecoin
WORKDIR /home/litecoin

EXPOSE 5901

CMD ["/opt/run.sh"]
