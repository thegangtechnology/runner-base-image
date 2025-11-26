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
      curl && \
    gem install bundler

# Ruby related tools
RUN gem install brakeman

RUN mkdir -p /opt/hostedtoolcache && \
    chown -R runner:runner /opt/hostedtoolcache

# Chrome for testing
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Switch back to runner user
USER runner