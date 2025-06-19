FROM docker.io/library/debian:trixie-slim AS base
SHELL [ "/bin/bash", "-Eeuo", "pipefail", "-c" ]

RUN useradd --create-home ci_user && \
mkdir /repo && \
chown -R ci_user:ci_user /repo && \
apt-get update && \
apt-get install --yes --no-install-recommends \
    curl ca-certificates git libyaml-dev xz-utils make ripgrep build-essential libffi-dev ruby-dev && \
apt-get clean && rm -rf /var/lib/apt/lists/*

USER ci_user
ENV HOME="/home/ci_user"
ENV ASDF_DIR="${HOME}/.asdf"
ENV PATH="${ASDF_DIR}/bin:${ASDF_DIR}/shims:${HOME}/.local/bin:${PATH}"

RUN curl -SsfL https://philcrockett.com/yolo/v1.sh \
    | bash -s -- asdf && \
git config --global advice.detachedHead false && \
asdf plugin add shellcheck https://github.com/pcrockett/asdf-shellcheck.git && \
asdf plugin add cue https://github.com/asdf-community/asdf-cue.git && \
asdf plugin add bashly https://github.com/pcrockett/asdf-bashly.git && \
asdf plugin add bats https://github.com/pcrockett/asdf-bats.git

WORKDIR /repo

COPY .tool-versions .
RUN asdf install

COPY --chown=ci_user:ci_user . .
