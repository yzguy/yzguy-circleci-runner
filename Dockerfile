FROM ubuntu:22.04

COPY --from=circleci/runner-agent:machine-3 /opt/circleci /opt/circleci

# Install packages
RUN apt-get update; \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    curl

# Install Docker
RUN install -m 0755 -d /etc/apt/keyrings; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc; \
    chmod a+r /etc/apt/keyrings/docker.asc; \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends\
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin

# Install other dependencies
RUN DEBIAN_FRONTEND=noninteractive \
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
        zlib1g-dev

# Install Pyenv
RUN git clone https://github.com/pyenv/pyenv.git /opt/pyenv
ENV PYENV_ROOT=/opt/pyenv
ENV PATH $PYENV_ROOT/bin:$PATH
RUN pyenv install 3.11.3; \
    pyenv install 3.12.2; \
    pyenv install 3.12.3

# Install Task
RUN wget -q -O /tmp/task.deb https://github.com/go-task/task/releases/download/v3.36.0/task_linux_$(dpkg --print-architecture).deb && \
    dpkg -i /tmp/task.deb && rm -f /tmp/task.deb

CMD ["/opt/circleci/circleci-runner"]
