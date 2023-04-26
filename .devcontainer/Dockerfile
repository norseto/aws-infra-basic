# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.238.0/containers/debian/.devcontainer/base.Dockerfile
# If you have trouble building container image around docker.io/docker/dockerfile:1.4,
# see https://github.com/microsoft/vscode-remote-release/issues/6920#issuecomment-1271484634

# [Choice] Debian version (use bullseye on local arm64/Apple Silicon): bullseye, buster
ARG VARIANT="bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-${VARIANT}

ARG REMOTE_USER=vscode
# ** [Optional] Uncomment this section to install additional packages. **
# RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#     && apt-get -y install --no-install-recommends <your-package-list-here>
RUN mkdir -p /home/$REMOTE_USER/.vscode-server/extensions \
        /home/$REMOTE_USER/.aws \
    && chown -R $REMOTE_USER /home/$REMOTE_USER/.vscode-server \
        /home/$REMOTE_USER/.aws 
