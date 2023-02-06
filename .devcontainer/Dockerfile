#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM rust:1

ENV https_proxy "http://199.19.250.205:80/"
ENV http_proxy "http://199.19.250.205:80/"

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1 \
    #
    # Verify git, needed tools installed
    && apt-get -y install git procps lsb-release \
    #
    # Install other dependencies
    && apt-get install -y lldb-3.9 \
    #
    # Install Rust components
    && rustup update \
    && rustup component add rls rust-analysis rust-src \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*


ENV HOME_DIR=/root
ARG version=0.13.0
WORKDIR ${HOME_DIR}
# If in a fresh Ubuntu
RUN apt-get update \
    && sudo apt-get upgrade \
    && apt-get install git unzip build-essential \
    # Install Nim and bootstrap it
    && git clone https://github.com/nim-lang/Nim.git \
    && git checkout 
WORKDIR ${HOME_DIR}/Nim
RUN git clone --depth 1 https://github.com/nim-lang/csources
WORKDIR ${HOME_DIR}/Nim/csources
RUN sh build.sh
WORKDIR ${HOME_DIR}/Nim
RUN bin/nim c koch \
    && ./koch boot -d:release
# Execute and also put the following line last in ~/.profile
ENV PATH="${HOME_DIR}/Nim/bin:${HOME_DIR}/.nimble/bin:$PATH"
# Then install nimble
RUN nim e install_nimble.nims \
    # Let it refresh the package list
    && nimble refresh \
    # Use nimble to install c2nim
    && nimble install c2nim


WORKDIR ${HOME_DIR}
RUN git clone https://github.com/BaldEagleX02/Arduino-Nim.git ardunimo
WORKDIR ${HOME_DIR}/ardunimo
RUN make sdk \
    && cp -fv wrapper/fixed/alloc.nim ${HOME_DIR}/Nim/lib/system/alloc.nim


# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
