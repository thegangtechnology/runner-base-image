FROM ghcr.io/actions/actions-runner:latest

# Switch to root to install packages
USER root

# Install dependencies for Ruby & Rails
RUN apt-get update && \
    apt-get install -y \
      ruby-full \
      build-essential \
      libpq-dev \
      libsqlite3-dev \
      zlib1g-dev \
      libvips-dev \
      libyaml-dev \
      git \
      unzip \
      wget \
      curl \
      jq && \
    gem install bundler

# Ruby related tools
RUN gem install brakeman

RUN mkdir -p /opt/hostedtoolcache && \
    chown -R runner:runner /opt/hostedtoolcache

# Chrome and dependencies for testing
RUN apt-get install -y \
      fonts-liberation \
      libasound2 \
      libatk-bridge2.0-0 \
      libatk1.0-0 \
      libatspi2.0-0 \
      libcups2 \
      libdbus-1-3 \
      libdrm2 \
      libgbm1 \
      libgtk-3-0 \
      libnspr4 \
      libnss3 \
      libwayland-client0 \
      libxcomposite1 \
      libxdamage1 \
      libxfixes3 \
      libxkbcommon0 \
      libxrandr2 \
      xdg-utils && \
    wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Setup timezone
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata && \
    ln -fs /usr/share/zoneinfo/Asia/Bangkok /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Setup Docker Compose for e2e tests
ENV DOCKER_CONFIG=/usr/local/lib/docker
RUN mkdir -p $DOCKER_CONFIG/cli-plugins && \
    curl -SL https://github.com/docker/compose/releases/download/v5.0.0/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose && \
    chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# Grant permission for docker buildx
RUN mkdir -p /usr/local/lib/docker/buildx/certs \
    && chown -R runner:runner /usr/local/lib/docker \
    && chmod -R 755 /usr/local/lib/docker

# Switch back to runner user
USER runner
