#!/bin/bash
#
# Installs Redash with some customizations specific to the overall project.
#
# Note: Generally follows guidelines at https://web.archive.org/web/20170701145736/https://google.github.io/styleguide/shell.xml.
#

set -e

# check_prerequisites - exits if distro is not supported.
#
# Parameters:
#     None.
function check_prerequisites() {
  local distro
  if [[ -f "/etc/lsb-release" ]]; then
    distro="Ubuntu"
  fi

  if [[ -z "${distro}" ]]; then
    log "Unsupported platform. Exiting..."
    exit 1
  fi
}

# install_dependencies - installs dependencies
#
# Parameters:
#     $1: the name of the distribution.
function install_dependencies() {
  log "Updating package index..."
  apt-get -qq update
  log "Upgrading existing packages"
  apt-get -qq upgrade
  log "Installing prerequisites..."
  apt-get -qq --no-install-recommends install \
    wget
}

# check_arguments - exits if prerequisites are NOT satisfied
#
# Parameters:
#     $1: the version of redash
function check_arguments() {
  local -r version_redash=${1}

  if [[ -z "${version_redash}" ]]; then
    log "No Redash version provided. Exiting..."
    exit 1
  fi

}

# install - downloads and installs the specified tool and version
#
# Parameters:
#     $1: the version of redash
function install_redash() {
  local -r version_redash=${1}

  local -r path_file="redash_bootstrap.sh"

  log "Downloading Redash install script..."
  wget -q -O ${path_file} "https://raw.githubusercontent.com/getredash/redash/master/setup/ubuntu/bootstrap.sh"

  log "Installing Redash ${version_redash}..."
  REDASH_VERSION=${version_redash} sh ${path_file}

}

# log - prints an informational message
#
# Parameters:
#     $1: the message
function log() {
  local -r message=${1}
  local -r script_name=$(basename ${0})
  echo -e "==> ${script_name}: ${message}"
}

# main
function main() {
  check_prerequisites

  local -r arg_version_redash=$(mdata-get 'version_redash')
  check_arguments \
    ${arg_version_redash}

  install_dependencies
  install_redash \
    ${arg_version_redash}

  log "Done."
}

main
