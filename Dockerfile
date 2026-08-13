FROM python:3.11-slim
ARG HOME_DIR
ARG WORKING_DIR
# Install basic tools + Node.js + npm
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    less \
    vim \
    nano \
    gnupg \
 && rm -rf /var/lib/apt/lists/*

# Install Node.js (LTS) + npm via NodeSource
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get update && apt-get install -y --no-install-recommends nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN node -v && npm -v

RUN npm install -g \
    yarn \
    pnpm \
    @vue/cli \
    && true

# Install PHP 8.4 (CLI only, no fpm) + extensions + Composer
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    apt-transport-https \
    lsb-release \
    gnupg \
 && curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
 && apt-get update && apt-get install -y --no-install-recommends \
    php8.4-cli \
    php8.4-mbstring \
    php8.4-zip \
    php8.4-opcache \
    php8.4-intl \
    php8.4-gd \
    php8.4-xml \
    php8.4-curl \
    php8.4-pgsql \
 && rm -rf /var/lib/apt/lists/*
COPY php.ini /usr/local/etc/php/php.ini
ENV HOME=${HOME_DIR}
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -fsSL https://claude.ai/install.sh | bash
RUN mkdir -p ${HOME_DIR}/.config/claude
RUN mkdir -p ${HOME_DIR}/.claude
RUN mkdir -p ${HOME_DIR}/.memsearch
RUN mkdir -p ${HOME_DIR}/.mempalace

RUN mkdir -p ${WORKING_DIR}

ENV PATH="/usr/local/bin:${PATH}"
ENV PATH="/root/.local/bin:${PATH}"

WORKDIR /workspace
CMD ["/bin/bash"]
