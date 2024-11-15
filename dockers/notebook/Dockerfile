ARG BASE_IMAGE=debian
ARG BASE_IMAGE_TAG=12
ARG BUILD_ON_IMAGE=glcr.b-data.ch/r/ver
ARG R_VERSION
ARG CUDA_IMAGE_FLAVOR

ARG NB_USER=d4now
ARG NB_UID=1000
ARG JUPYTERHUB_VERSION=4.1.5
ARG JUPYTERLAB_VERSION=4.2.3
ARG JUPYTERLAB_LANG_PACK=4.2.post1
ARG CODE_BUILTIN_EXTENSIONS_DIR=/opt/code-server/lib/vscode/extensions
ARG CODE_SERVER_VERSION=4.16.1
ARG GIT_VERSION=2.42.0
ARG GIT_LFS_VERSION=3.4.0
ARG R_VERSION=4.4.0
ARG PANDOC_VERSION=3.1.1

FROM ${BUILD_ON_IMAGE}:${R_VERSION}${CUDA_IMAGE_FLAVOR:+-}${CUDA_IMAGE_FLAVOR} AS files

ARG NB_UID
ENV NB_GID=100

RUN mkdir /files

COPY conf/ipython /files
COPY conf/jupyter /files
COPY conf/jupyterlab /files
COPY conf/user /files
COPY scripts /files

RUN chown -R ${NB_UID}:${NB_GID} /files/var/backups/skel \
  ## Ensure file modes are correct when using CI
  ## Otherwise set to 777 in the target image
  && find /files -type d -exec chmod 755 {} \; \
  && find /files -type f -exec chmod 644 {} \; \
  && find /files/usr/local/bin -type f -exec chmod 755 {} \;

FROM glcr.b-data.ch/git/gsi/${GIT_VERSION}/${BASE_IMAGE}:${BASE_IMAGE_TAG} AS gsi
FROM glcr.b-data.ch/git-lfs/glfsi:${GIT_LFS_VERSION} AS glfsi

FROM ${BUILD_ON_IMAGE}:${R_VERSION}${CUDA_IMAGE_FLAVOR:+-}${CUDA_IMAGE_FLAVOR}

ARG NCPUS=1

ARG DEBIAN_FRONTEND=noninteractive

ARG BUILD_ON_IMAGE
ARG CUDA_IMAGE_FLAVOR
ARG NB_USER
ARG NB_UID
ARG JUPYTERHUB_VERSION
ARG JUPYTERLAB_VERSION
ARG JUPYTERLAB_LANG_PACK
ARG CODE_BUILTIN_EXTENSIONS_DIR
ARG CODE_SERVER_VERSION
ARG GIT_VERSION
ARG GIT_LFS_VERSION
ARG PANDOC_VERSION
ARG BUILD_START

ARG CODE_WORKDIR

ENV PARENT_IMAGE=${BUILD_ON_IMAGE}:${R_VERSION}${CUDA_IMAGE_FLAVOR:+-}${CUDA_IMAGE_FLAVOR} \
    NB_USER=${NB_USER} \
    NB_UID=${NB_UID} \
    JUPYTERHUB_VERSION=${JUPYTERHUB_VERSION} \
    JUPYTERLAB_VERSION=${JUPYTERLAB_VERSION} \
    CODE_SERVER_VERSION=${CODE_SERVER_VERSION} \
    GIT_VERSION=${GIT_VERSION} \
    GIT_LFS_VERSION=${GIT_LFS_VERSION} \
    PANDOC_VERSION=${PANDOC_VERSION} \
    BUILD_DATE=${BUILD_START}

ENV NB_GID=100

## Installing V8 on Linux, the alternative way
## https://ropensci.org/blog/2020/11/12/installing-v8
ENV DOWNLOAD_STATIC_LIBV8=1

## Disable prompt to install miniconda
ENV RETICULATE_MINICONDA_ENABLED=0

## Install Git
COPY --from=gsi /usr/local /usr/local
## Install Git LFS
COPY --from=glfsi /usr/local /usr/local

USER root

RUN dpkgArch="$(dpkg --print-architecture)" \
  ## Unminimise if the system has been minimised
  && if [ $(command -v unminimize) ]; then \
    yes | unminimize; \
  fi \
  && apt-get update \
  && apt-get -y install --no-install-recommends \
    bash-completion \
    build-essential \
    curl \
    file \
    fontconfig \
    g++ \
    gcc \
    gfortran \
    gnupg \
    htop \
    info \
    jq \
    libclang-dev \
    man-db \
    nano \
    procps \
    psmisc \
    screen \
    sudo \
    swig \
    tmux \
    vim-tiny \
    wget \
    unzip \
    ## Git: Additional runtime dependencies
    libcurl3-gnutls \
    liberror-perl \
    ## Git: Additional runtime recommendations
    less \
    ssh-client \
  ## Python: Additional dev dependencies
  && if [ -z "$PYTHON_VERSION" ]; then \
    apt-get -y install --no-install-recommends \
      python3-dev \
      ## Install Python package installer
      ## (dep: python3-distutils, python3-setuptools and python3-wheel)
      python3-pip \
      ## Install venv module for python3
      python3-venv; \
    ## make some useful symlinks that are expected to exist
    ## ("/usr/bin/python" and friends)
    for src in pydoc3 python3 python3-config; do \
      dst="$(echo "$src" | tr -d 3)"; \
      [ -s "/usr/bin/$src" ]; \
      [ ! -e "/usr/bin/$dst" ]; \
      ln -svT "$src" "/usr/bin/$dst"; \
    done; \
  else \
    ## Force update pip, setuptools and wheel
    curl -sLO https://bootstrap.pypa.io/get-pip.py; \
    python get-pip.py \
      pip \
      setuptools \
      wheel; \
    rm get-pip.py; \
  fi \
  ## Install font MesloLGS NF
  && mkdir -p /usr/share/fonts/truetype/meslo \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Regular.ttf \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Bold.ttf \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Italic.ttf \
  && curl -sL https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -o /usr/share/fonts/truetype/meslo/MesloLGS\ NF\ Bold\ Italic.ttf \
  && fc-cache -fsv \
  ## Git: Set default branch name to main
  && git config --system init.defaultBranch main \
  ## Git: Store passwords for one hour in memory
  && git config --system credential.helper "cache --timeout=3600" \
  ## Git: Merge the default branch from the default remote when "git pull" is run
  && git config --system pull.rebase false \
  ## Install pandoc
  && curl -sLO https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-1-${dpkgArch}.deb \
  && dpkg -i pandoc-${PANDOC_VERSION}-1-${dpkgArch}.deb \
  && rm pandoc-${PANDOC_VERSION}-1-${dpkgArch}.deb \
  ## Delete potential user with UID 1000
  && if $(grep -q 1000 /etc/passwd); then \
    userdel $(id -un 1000); \
  fi \
  ## Do not set user limits for sudo/sudo-i
  && sed -i 's/.*pam_limits.so/#&/g' /etc/pam.d/sudo \
  && if [ -f "/etc/pam.d/sudo-i" ]; then \
    sed -i 's/.*pam_limits.so/#&/g' /etc/pam.d/sudo-i; \
  fi \
  ## Add user
  && useradd -l -m -s $(which bash) -N -u ${NB_UID} ${NB_USER} \
  && mkdir -p /var/backups/skel \
  && chown ${NB_UID}:${NB_GID} /var/backups/skel \
  && chown ${NB_UID}:${NB_GID} /usr/local/lib/R/site-library \
  ## Install Tini
  && curl -sL https://github.com/krallin/tini/releases/download/v0.19.0/tini-${dpkgArch} -o /usr/local/bin/tini \
  && chmod +x /usr/local/bin/tini \
  ## install minio 
  && curl -sL https://dl.min.io/client/mc/release/linux-${dpkgArch}/mc -o /usr/local/bin/mc \
  && chmod +x /usr/local/bin/mc \
  ## Clean up
  && rm -rf /tmp/* \
  && rm -rf /var/lib/apt/lists/* \
    ${HOME}/.cache

ENV PATH=/opt/code-server/bin:$PATH \
    CS_DISABLE_GETTING_STARTED_OVERRIDE=1

## Install JupyterLab
RUN export PIP_BREAK_SYSTEM_PACKAGES=1 \
  && pip install \
    jupyter-server-proxy \
    jupyterhub==${JUPYTERHUB_VERSION} \
    jupyterlab==${JUPYTERLAB_VERSION} \
    jupyterlab-lsp==4.3.0 \
    sqlalchemy-trino \
    notebook \
    nbconvert \
    python-lsp-server[all] \
    jupyterlab-language-pack-ar-SA==${JUPYTERLAB_LANG_PACK} \
    jupyterlab-language-pack-fr-FR==${JUPYTERLAB_LANG_PACK} \
    jupyterlab-language-pack-vi-VN==${JUPYTERLAB_LANG_PACK} \
    jupyterlab-minio \
    jupyterlab-code-snippets \
    ipyflex \
    ipyvuetify \
    pandas \
    trino \
    pyreadstat \ 
    boto3 \
    pyspssio \
    minio \
    seaborn \
    plotly \
    jupyterlab-dash \
    jupyterlab-interactive-dashboard-editor \
    nltk \
    matplotlib \
    scipy \
    pyarrow \
    nbcelltests \
    fastavro \
    import-ipynb \
    ## add custom python packages here
  ## Clean up
  && rm -rf /tmp/* \
    ${HOME}/.cache

## Install R related stuff
RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    ## Current ZeroMQ library for R pbdZMQ
    libzmq3-dev \
    ## Required for R extension
    libcairo2-dev \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libssl-dev \
    libxml2-dev \
  ## Install radian
  && export PIP_BREAK_SYSTEM_PACKAGES=1 \
  && pip install radian \
  ## Provide NVBLAS-enabled radian_
  ## Enabled at runtime and only if nvidia-smi and at least one GPU are present
  && if [ ! -z "$CUDA_IMAGE" ]; then \
    nvblasLib="$(cd $CUDA_HOME/lib* && ls libnvblas.so* | head -n 1)"; \
    cp -a $(which radian) $(which radian)_; \
    echo '#!/bin/bash' > $(which radian)_; \
    echo "command -v nvidia-smi >/dev/null && nvidia-smi -L | grep 'GPU[[:space:]]\?[[:digit:]]\+' >/dev/null && export LD_PRELOAD=$nvblasLib" \
      >> $(which radian)_; \
    echo "$(which radian) \"\${@}\"" >> $(which radian)_; \
  fi \
  ## Install the R kernel for Jupyter, languageserver and httpgd
  && install2.r --error --deps TRUE --skipinstalled -n $NCPUS \
    IRkernel \
    languageserver \
    httpgd \
  && installGithub.r aristidetm/minio.s3@1.0 \
  && Rscript -e "IRkernel::installspec(user = FALSE, displayname = paste('R', Sys.getenv('R_VERSION')))" \
  ## Get rid of libcairo2-dev and its dependencies (incl. python3)
  && apt-get -y purge libcairo2-dev \
  && apt-get -y autoremove \
  ## IRkernel: Enable 'image/svg+xml' instead of 'image/png' for plot display
  ## IRkernel: Enable 'application/pdf' for PDF conversion
  && echo "options(jupyter.plot_mimetypes = c('text/plain', 'image/svg+xml', 'application/pdf'))" \
    >> $(R RHOME)/etc/Rprofile.site \
  ## IRkernel: Include user's private bin in PATH
  && echo "if (dir.exists(file.path(Sys.getenv('HOME'), 'bin')) &&" \
    >> $(R RHOME)/etc/Rprofile.site \
  && echo '  !grepl(file.path(Sys.getenv('\''HOME'\''), '\''bin'\''), Sys.getenv('\''PATH'\''))) {' \
    >> $(R RHOME)/etc/Rprofile.site \
  && echo "  Sys.setenv(PATH = paste(file.path(Sys.getenv('HOME'), 'bin'), Sys.getenv('PATH')," \
    >> $(R RHOME)/etc/Rprofile.site \
  && echo "    sep = .Platform\$path.sep))}" \
    >> $(R RHOME)/etc/Rprofile.site \
  && echo "if (dir.exists(file.path(Sys.getenv('HOME'), '.local', 'bin')) &&" \
    >> $(R RHOME)/etc/Rprofile.site \
  && echo '  !grepl(file.path(Sys.getenv('\''HOME'\''), '\''.local'\'', '\''bin'\''), Sys.getenv('\''PATH'\''))) {' \
    >> $(R RHOME)/etc/Rprofile.site \
  && echo "  Sys.setenv(PATH = paste(file.path(Sys.getenv('HOME'), '.local', 'bin'), Sys.getenv('PATH')," \
    >> $(R RHOME)/etc/Rprofile.site \
  && echo "    sep = .Platform\$path.sep))}" \
    >> $(R RHOME)/etc/Rprofile.site \
  ## REditorSupport.r: Disable help panel and revert to old behaviour
  && echo "options(vsc.helpPanel = FALSE)" >> $(R RHOME)/etc/Rprofile.site \
  ## Change ownership and permission of $(R RHOME)/etc/*.site
  && chown :"$NB_GID" "$(R RHOME)/etc" "$(R RHOME)/etc/"*.site \
  && chmod g+w "$(R RHOME)/etc" "$(R RHOME)/etc/"*.site \
  ## Strip libraries of binary packages installed from P3M
  && RLS=$(Rscript -e "cat(Sys.getenv('R_LIBS_SITE'))") \
  && strip ${RLS}/*/libs/*.so \
  ## install some R 
  && install2.r  \
    haven \
    RPresto \
    plotly \
  ## Clean up
  && rm -rf /tmp/* \
    /var/lib/apt/lists/* \
    ${HOME}/.cache \
    ${HOME}/.config \
    ${HOME}/.ipython \
    ${HOME}/.local

## Switch back to ${NB_USER} to avoid accidental container runs as root
USER ${NB_USER}

ENV HOME=/home/${NB_USER} \
    SHELL=/usr/bin/bash \
    TERM=xterm-256color

WORKDIR ${HOME}

# Install custom theme
RUN mkdir -p ${HOME}/.local/bin \
  ## Custom R library
  && mkdir -p ${HOME}/.R \
  && rm -rf ${HOME}/R \
  ## Create backup of home directory
  && cp -a ${HOME}/. /var/backups/skel

ENV R_LIBS_USER=${HOME}/.R 

## Copy files as late as possible to avoid cache busting
COPY --from=files /files /
COPY --from=files /files/var/backups/skel ${HOME}

EXPOSE 8888

## Configure container startup
ENTRYPOINT ["tini", "-g", "--", "start.sh"]
CMD ["start-notebook.sh"]