#!/bin/bash

if [ "`whoami`" != "root" ]; then
    echo "Require root privilege" && exit 1
fi

curl -z /home/vsonline/workspace/.devcontainer/Dockerfile_buildpack-deps_buster-curl https://raw.githubusercontent.com/docker-library/buildpack-deps/b0fc01aa5e3aed6820d8fed6f3301e0542fbeb36/buster/curl/Dockerfile -o /home/vsonline/workspace/.devcontainer/Dockerfile_buildpack-deps_buster-curl \
&& curl -z /home/vsonline/workspace/.devcontainer/Dockerfile_buildpack-deps_buster-scm https://raw.githubusercontent.com/docker-library/buildpack-deps/99a1c33fda559272e9322b02a5d778bbd04154e7/buster/scm/Dockerfile -o /home/vsonline/workspace/.devcontainer/Dockerfile_buildpack-deps_buster-scm \
&& curl -z /home/vsonline/workspace/.devcontainer/Dockerfile_buildpack-deps_buster https://raw.githubusercontent.com/docker-library/buildpack-deps/cd0058f0893008c7ffa8e9cb9d3d5208cf5f2f75/buster/Dockerfile -o /home/vsonline/workspace/.devcontainer/Dockerfile_buildpack-deps_buster \
&& curl -z /home/vsonline/workspace/.devcontainer/Dockerfile_rust_1 https://raw.githubusercontent.com/rust-lang/docker-rust/3898d19194231639f1afc3096bd04702eaf555e7/1.40.0/buster/Dockerfile -o /home/vsonline/workspace/.devcontainer/Dockerfile_rust_1 \
&& for SRC in /home/vsonline/workspace/.devcontainer/Dockerfile*; do
    DST=${SRC//Dockerfile_/}.sh \
    && echo '#!/bin/sh' > $DST \
    && sed \
        -e 's/# .*$//g' \
        -e 's/#$//g' \
        -e '/^[ \t]*$/d' \
        -e 's/^FROM /# FROM /g' \
        -e 's/^RUN //g' \
        -e 's/^ENV /export /g' \
        -e 's/^ARG //g' \
        -e 's/^WORKDIR /cd /g' \
        $SRC >> $DST \
    && chmod +x $DST
done \
&& mv /home/vsonline/workspace/.devcontainer/{Dockerfile.sh,base-dockerfile.sh} \
&& . /home/vsonline/workspace/.devcontainer/buildpack-deps_buster-curl.sh \
&& . /home/vsonline/workspace/.devcontainer/buildpack-deps_buster-scm.sh \
&& . /home/vsonline/workspace/.devcontainer/buildpack-deps_buster.sh \
&& . /home/vsonline/workspace/.devcontainer/rust_1.sh \
&& . /home/vsonline/workspace/.devcontainer/base-dockerfile.sh
