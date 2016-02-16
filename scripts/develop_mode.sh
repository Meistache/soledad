#!/bin/bash

CHECK_VENV="1"
PIP="pip --no-cache-dir"

usage() { echo "Usage: $0 [-n] [<leap|pixelated>]" 1>&2; exit 1; }

function install_requirements_for() {
  local REQUIREMENTS_MODE=$1

  # upgrade pip and setuptools to the latest version
  set -e
  $PIP install --upgrade pip
  $PIP install --upgrade setuptools

  for MODULE in client server common ; do
    echo "Installing dependencies for ${MODULE}"
    pushd $MODULE
    $PIP install -r "pkg/requirements-${REQUIREMENTS_MODE}.pip"
    popd
  done

  # install testing dependendies (only in common)
  pushd common
  # install testing dependendies (only in common)
  $PIP install -r pkg/requirements-testing.pip
  popd

  # reinstall scrypt
  pip uninstall -y scrypt || true
  $PIP install scrypt

  echo -e "\n\n"
  echo "To run the tests execute:"
  echo "trial leap.soledad.common.tests"
  echo
}

while getopts "hn" OPT; do
	case $OPT in
		n)
			CHECK_VENV=
			;;
		h)
			usage
			exit 0
			;;
		*)
			usage
			exit 1
			;;
	esac
done
shift $((OPTIND-1))

if [ -z "$VIRTUAL_ENV" -a -n "$CHECK_VENV" ] ; then
	echo "You did not activate a python virtualenv"
	exit 1
fi

if [ $# -gt 1 ] ; then
	echo "Unexpected number of arguments: $#"
	usage
	exit 1
fi


REQUIREMENTS_MODE=$1
if [ -n "$REQUIREMENTS_MODE" ] ; then
	install_requirements_for $REQUIREMENTS_MODE
else
	cd common
	python setup.py develop
	cd ../client
	python setup.py develop
	cd ../server
	python setup.py develop
fi

exit 0

