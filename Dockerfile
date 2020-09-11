#
# S3 Artifact Fetcher
# An image that can be used as an init container to fetch artifacts for runner containers from S3
#

FROM mesosphere/aws-cli:1.14.5@sha256:fb590357c2cf74e868cf110ede38daf4bdf0ebd1bdf36c21d256aa33ab22fa6e
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
