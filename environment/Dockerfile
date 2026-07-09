# hash:sha256:16a54343c83446772895fc0c0b1e88a6dbd136fee70bcacffff7886f30541b82
ARG REGISTRY_HOST
FROM $REGISTRY_HOST/codeocean/mosuite-minimal:v0.3.2

ARG DEBIAN_FRONTEND=noninteractive
ARG GIT_ASKPASS
COPY git-askpass /

COPY postInstall /
RUN --mount=type=secret,id=secrets . /run/secrets/secrets \
    && /postInstall
