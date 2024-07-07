#!/bin/bash
# Title: Ubuntu Obsolete Repository Fixer and Upgrade Script
# Description: Fixes repository issues for obsolete Ubuntu versions and upgrades to a supported version

# Check the current version of Ubuntu
current_version=$(lsb_release -cs)

obsolete_versions=("kinetic")

modify_sources_list() {
  sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
  sudo sed -i 's|http://archive.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g' /etc/apt/sources.list
  sudo sed -i 's|http://security.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g' /etc/apt/sources.list
}

update_and_upgrade() {
  sudo apt update && sudo apt upgrade -y
}

do_release_upgrade() {
  sudo apt install -y update-manager-core
  sudo do-release-upgrade -d
}

fix_broken_install() {
  sudo apt --fix-broken install -y
}

if [[ " ${obsolete_versions[@]} " =~ " ${current_version} " ]]; then
  echo "Repairing..."
  echo "Modifying sources.list to use old-releases..."
  modify_sources_list

  echo "Updating..."
  update_and_upgrade

  echo "Upgrading..."
  do_release_upgrade
else
  echo "Updating..."
  update_and_upgrade
fi

echo "Fixing broken packages..."
fix_broken_install

echo "Finished."
