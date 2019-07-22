#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM rust:1

#ENV https_proxy "http://199.19.250.205:80/"
#ENV http_proxy "http://199.19.250.205:80/"

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
# Execute and also put the following line last in ~/.profile
ENV PATH="${HOME_DIR}/Nim/bin:${HOME_DIR}/.nimble/bin:$PATH"
ARG version=0.20.2
WORKDIR ${HOME_DIR}
RUN wget http://nim-lang.org/download/nim-${version}.tar.xz \
    && tar xf nim-${version}.tar.xz; rm nim-${version}.tar.xz \
    && mv nim-${version} Nim
WORKDIR ${HOME_DIR}/Nim
RUN sh build.sh \
    && ln -snfv ${PWD}/bin/nim /bin/nim
RUN nim c koch \
    && ./koch tools \
    && ln -snfv ${PWD}/bin/nimble /bin/nimble \
    && ln -snfv ${PWD}/bin/nimsuggest /bin/nimsuggest \
    && ln -snfv ${PWD}/bin/nimfind /bin/nimfind \
    && ln -snfv ${PWD}/bin/nimgrep /bin/nimgrep \
    && ln -snfv ${PWD}/bin/nimpretty /bin/nimpretty
RUN nimble refresh \
    && nimble install c2nim \
    && ln -snfv ${HOME_DIR}/.nimble/bin/c2nim /bin/c2nim
WORKDIR ${HOME_DIR}
RUN git clone https://github.com/BaldEagleX02/Arduino-Nim.git ardunimo
WORKDIR ${HOME_DIR}/ardunimo
RUN make sdk \
    && cp -fv wrapper/fixed/alloc.nim ${HOME_DIR}/Nim/lib/system/alloc.nim


# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
