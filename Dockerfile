FROM ubuntu:22.04

COPY --from=circleci/runner-agent:machine-3 /opt/circleci /opt/circleci

ENV DEBIAN_FRONTEND=noninteractive

# Install prerequisite packages
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg2 \
    lsb-release \
    curl \
    wget

# Docker Repo
RUN install -m 0755 -d /etc/apt/keyrings; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc; \
    chmod a+r /etc/apt/keyrings/docker.asc; \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null;

# Hashicorp Repo
RUN curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg; \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list;

# Install other dependencies
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
        bind9utils \
        build-essential \
        git \
        gpg \
        libbz2-dev \
        libffi-dev \
        liblzma-dev \
        libncurses5-dev \
        libncursesw5-dev \
        libreadline-dev \
        libsqlite3-dev \
        libssl-dev \
        llvm \
        lsb-release \
        make \
        openssh-client \
        tk-dev \
        wget \
        xz-utils \
        zlib1g-dev \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin \
        nomad

# Pyenv
RUN git clone https://github.com/pyenv/pyenv.git /opt/pyenv
ENV PYENV_ROOT=/opt/pyenv
ENV PATH /opt/pyenv/shims:$PYENV_ROOT/bin:$PATH
RUN pyenv install 3.11.3; \
    pyenv install 3.12.2; \
    pyenv install 3.12.3

# Task
RUN wget -q -O /tmp/task.deb https://github.com/go-task/task/releases/download/v3.36.0/task_linux_$(dpkg --print-architecture).deb && \
    dpkg -i /tmp/task.deb && rm -f /tmp/task.deb

CMD ["/opt/circleci/scripts/run.sh"]
