# hash:sha256:d5a413744d1647e7a0e70b8fcf6cfe6f1694ffcc86dee625190b1f45662464a4
ARG REGISTRY_HOST
FROM $REGISTRY_HOST/codeocean/mosuite:v0.2.1.9001_dad61d3

ARG DEBIAN_FRONTEND=noninteractive
ARG GIT_ASKPASS
COPY git-askpass /

COPY postInstall /
RUN --mount=type=secret,id=secrets . /run/secrets/secrets \
    && /postInstall
