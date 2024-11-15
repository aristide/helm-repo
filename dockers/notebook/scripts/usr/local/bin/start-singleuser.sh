#!/bin/bash
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

set -e

# Check if the environment variable is set
if [ -n "$PYTHON_PACKAGES" ]; then
  echo "Installing additional Python packages..."
  echo "$PYTHON_PACKAGES" | xargs -n 1 pip install
else
  echo "No additional Python packages to install."
fi

# Check if the environment variable is set
if [ -n "$R_PACKAGES" ]; then
  echo "Installing additional R packages..."
  echo "$R_PACKAGES" | xargs -n 1 install2.r --error
else
  echo "No additional R packages to install."
fi

# Check if RUN_SCRIPT is set and not empty
if [ ! -z "$RUN_SCRIPT" ]; then
  echo "Running script from RUN_SCRIPT environment variable:"
  echo "$RUN_SCRIPT" > /tmp/script.sh
  chmod +x /tmp/script.sh
  bash /tmp/script.sh
  rm /tmp/script.sh
fi

# set default ip to 0.0.0.0
if [[ "${NOTEBOOK_ARGS} $*" != *"--ip="* ]]; then
    NOTEBOOK_ARGS="--ip=0.0.0.0 ${NOTEBOOK_ARGS}"
fi

echo "Executing: jupyterhub-singleuser" "${NOTEBOOK_ARGS}" "$@"
# shellcheck disable=SC1091,SC2086
exec jupyterhub-singleuser ${NOTEBOOK_ARGS} "$@"
