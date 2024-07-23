#!/bin/bash
# Copyright (c) 2020 b-data GmbH.
# Distributed under the terms of the MIT License.

set -e

if [ ! -f /home/d4now/.populated ]; then
  # Create list of missing files (top level only)
  fd="$(comm -13 <(cd /home/d4now; ls -A) <(cd /var/backups/skel; ls -A) \
    | paste -sd ',' -)"
  # Handle case when only marker is missing
  if [[ "${fd}" == ".populated" ]]; then
    sf="${fd}"
  else
    sf="{${fd}}"
  fi

  if [ -z "${fd}" ]; then
    _log "Nothing to populate"
  else 
    _log "Populating home dir: /home/d4now"
    _log "Copying files/directories (recursively):"
    _log "- ${fd}"
    if eval "cp -a /var/backups/skel/${sf} /home/d4now"; then
      date -uIseconds > /home/d4now/.populated
      _log "Done populating home dir"
    else
      _log "ERROR: Failed to copy data from /var/backups/skel to /home/d4now!"
      exit 1
    fi
  fi
fi
