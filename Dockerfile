FROM ubuntu:20.04

# Install packages
RUN apt-get update; \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    docker.io \
    git \
    openssh-client \
    wget

RUN mkdir -p /opt/circleci/workdir
WORKDIR /opt/circleci

ENV AGENT_VERSION=1.0.33818-051c2fc
ENV TARGET_PLATFORM=linux/amd64

COPY . .

RUN ./init-launch-agent.sh $AGENT_VERSION $TARGET_PLATFORM

# Install Task
RUN wget -q -O /tmp/task.deb https://github.com/go-task/task/releases/download/v3.7.3/task_linux_amd64.deb && \
    dpkg -i /tmp/task.deb && rm -f /tmp/task.deb

CMD ["/opt/circleci/start.sh"]
