#!/bin/bash
REPO_TAG="exoscale/cli"

gh_get_exo_release () {
    # like awk but for JSON
    # from https://stackoverflow.com/questions/67688662/how-can-i-get-the-latest-pre-release-release-for-my-github-repo-bash
    jq -r 'first | .tag_name' \
      <<< $(curl --silent https://api.github.com/repos/${REPO_TAG}/releases)
}

EXO_VERSION=$(gh_get_exo_release)
EXO_VERSION_num="${EXO_VERSION//v}"

echo "Grabbing exo CLI tag ${EXO_VERSION_num}"

# check platform
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

if [ "${machine}" = "Linux" ]; then
  if [ -f /etc/os-release ]; then
      # freedesktop.org and systemd
      . /etc/os-release
      OS=$ID
      VER=$VERSION_ID
  elif type lsb_release >/dev/null 2>&1; then
      # linuxbase.org
      OS=$(lsb_release -si)
      VER=$(lsb_release -sr)
  elif [ -f /etc/lsb-release ]; then
      # For some versions of Debian/Ubuntu without lsb_release command
      . /etc/lsb-release
      OS=$DISTRIB_ID
      VER=$DISTRIB_RELEASE
  elif [ -f /etc/debian_version ]; then
      # Older Debian/Ubuntu/etc.
      OS=Debian
      VER=$(cat /etc/debian_version)
  elif [ -f /etc/SuSe-release ]; then
      # Older SuSE/etc.
      ...
  elif [ -f /etc/redhat-release ]; then
      # Older Red Hat, CentOS, etc.
      ...
  else
      # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
      OS=$(uname -s)
      VER=$(uname -r)
  fi
fi

# then download according to installation instructions on
# https://community.exoscale.com/documentation/tools/exoscale-command-line-interface/

# Red Hat / CentOS / Rocky
## Download cli_$VERSION_linux_amd64.rpm
## Run sudo rpm -i cli_$VERSION_linux_amd64.rpm

# Debian / Ubuntu
## Download cli_$VERSION_linux_amd64.deb
## Run $ sudo dpkg -i cli_$VERSION_linux_amd64.deb

# https://github.com/exoscale/cli/releases/download/v1.60.0/exoscale-cli_1.60.0_linux_amd64.rpm

echo "distro ID: ${ID}"

case $OS in
  debian | ubuntu)
    echo "Grasping last exo CLI version for Debian family"
    curl -o "exo-cli.deb" -L \
      "https://github.com/${REPO_TAG}/releases/download/v${EXO_VERSION_num}/exoscale-cli_${EXO_VERSION_num}_linux_amd64.deb"
    sudo dpkg -i "exo-cli.deb"
    rm "exo-cli.deb"
    echo "Cleanup download."
    echo "You have now:"
    echo $(exo version)
    ;;
  centos | rhel | fedora | rocky)
    echo "Grasping last exo CLI version for RHEL family"
    curl -o "exo-cli.rpm" -L \
      "https://github.com/${REPO_TAG}/releases/download/v${EXO_VERSION_num}/exoscale-cli_${EXO_VERSION_num}_linux_amd64.rpm"
    sudo rpm -i "exo-cli.rpm"
    rm "exo-cli.rpm"
    echo "Cleanup download."
    echo "You have now:"
    echo $(exo version)
    ;;
esac
  # # other linux distros
  # sudo mkdir -p /opt/exo/${EXO_VERSION_num}
  # sudo tar -zxvf exo-cli.tar.gz \
  #     -C "/opt/exo/${EXO_VERSION_num}" \
  #     --strip-components=1
  # # force link, so any currently possibly symliked versions are removed
  # sudo ln -sf \
  #     /opt/exo/${EXO_VERSION_num}/bin/exo \
  #     /usr/local/bin/exo
  # echo "Successfully extracted and linked the exo binary"
