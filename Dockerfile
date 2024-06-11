FROM ubuntu:22.04

ARG TARGETPLATFORM
ENV ZENOH_VERSION=0.11.0


# Install Zenoh
RUN apt-get update && apt-get install -y \
  wget unzip tzdata curl \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN if [ ${TARGETPLATFORM} = "linux/arm64" ]; then \
    wget -O /zenoh-pkgs.zip https://github.com/eclipse-zenoh/zenoh/releases/download/${ZENOH_VERSION}/zenoh-${ZENOH_VERSION}-aarch64-unknown-linux-gnu-debian.zip ; \
  elif [ ${TARGETPLATFORM} = "linux/amd64" ]; then \
    wget -O /zenoh-pkgs.zip https://github.com/eclipse-zenoh/zenoh/releases/download/${ZENOH_VERSION}/zenoh-${ZENOH_VERSION}-x86_64-unknown-linux-gnu-debian.zip ; \
  fi
RUN unzip /zenoh-pkgs.zip \
  && dpkg -i /*.deb \
  && rm -f /zenoh-pkgs.zip /zenoh*.deb

# Install Python, zenoh-python and opencv for zcam
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
  python3-pip libopencv-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN pip install -U pip \
  && pip install --no-cache-dir eclipse-zenoh==${ZENOH_VERSION} opencv-python numpy imutils

# Install Erlang from source
ENV OTP_VERSION="26.2.5"
RUN set -xe \
  && OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
  && runtimeDeps='libodbc1 \
    libsctp1 \
    libwxgtk3.0 \
    libwxgtk-webview3.0-gtk3-0v5' \
  && buildDeps='unixodbc-dev \
    libsctp-dev \
    libwxgtk-webview3.0-gtk3-dev' \
  && apt-get update \
  && apt-get install -y --no-install-recommends $runtimeDeps \
  && apt-get install -y --no-install-recommends $buildDeps \
  && curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
  && export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
  && mkdir -vp $ERL_TOP \
  && tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
  && rm otp-src.tar.gz \
  && ( cd $ERL_TOP \
    && ./otp_build autoconf \
    && gnuArch="$(dpkg-architecture --query DEB_HOST_GNU_TYPE)" \
    && ./configure --build="$gnuArch" \
    && make -j$(nproc) \
    && make -j$(nproc) docs DOC_TARGETS=chunks \
    && make install install-docs DOC_TARGETS=chunks ) \
  && find /usr/local -name examples | xargs rm -rf \
  && apt-get purge -y --auto-remove $buildDeps \
  && rm -rf $ERL_TOP /var/lib/apt/lists/*

# Install Elixir from source
ENV ELIXIR_VERSION="v1.16.3" \
	LANG=C.UTF-8
# Elixir for linux/arm64 from source
RUN set -xe \
  && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
  && curl -fSL -o elixir-src.tar.gz $ELIXIR_DOWNLOAD_URL \
  && mkdir -p /usr/local/src/elixir \
  && tar -xzC /usr/local/src/elixir --strip-components=1 -f elixir-src.tar.gz \
  && rm elixir-src.tar.gz \
  && cd /usr/local/src/elixir \
  && make install clean \
  && find /usr/local/src/elixir/ -type f -not -regex "/usr/local/src/elixir/lib/[^\/]*/lib.*" -exec rm -rf {} + \
  && find /usr/local/src/elixir/ -type d -depth -empty -delete \
  && mix local.hex --force
