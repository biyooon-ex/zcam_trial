FROM ubuntu:22.04

ARG TARGETPLATFORM
ENV ZENOH_VERSION=0.11.0


# Install Zenoh
RUN apt-get update && apt-get install -y \
  wget unzip tzdata \
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
