#
# S3 Artifact Fetcher
# An image that can be used as an init container to fetch artifacts for runner containers from S3
#

FROM amazon/aws-cli:2.10.2@sha256:75f8cf2ad8e18e6da8fa3698dcdefd5d0a0f0db6a3fb9f9bf2a7bc563a9ce367
LABEL maintainer="Agile Digital <info@agiledigital.com.au>"
LABEL description="An image that can be used as an init container to fetch artifacts for runner containers from S3" Vendor="Agile Digital" Version="0.1"

ENV RUNNER_USER runner
ENV HOME /home/${RUNNER_USER}

ENV ARTIFACT_DIR $HOME/artifacts

RUN adduser -S -u 10000 -h "${HOME}" "${RUNNER_USER}"

WORKDIR $HOME

COPY app "${HOME}/app"
RUN chmod +x "${HOME}/app/run.sh"

RUN chmod g+w /etc/passwd
RUN chgrp -R root "${HOME}" && chmod -R g+w "${HOME}"

USER runner:root

ENTRYPOINT [ "/home/runner/app/run.sh" ]
