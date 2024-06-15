#!/bin/bash
set -eu

#
=============================================================================
======= #
# VARIABLES
#
=============================================================================
======= #

TIMEZONE=America/New_York
USERNAME=greenlight

read -p "Enter password for greenlight DB user: " DB_PASSWORD

export LC_ALL=en_US.UTF-8

add-apt-repository --yes universe
apt update
apt --yes -o Dpkg::Options::="--force-confnew" upgrade