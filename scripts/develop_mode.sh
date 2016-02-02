#!/bin/sh
cd common
python setup.py develop
cd ../client
python setup.py develop
cd ../server
python setup.py develop

echo "All dependencies were installed, except for LEAP libraries"
echo "In order to develop you will need the latest for each of them"
echo "On each folder there is a pkg/requirements-leap.pip declaring it."
echo "You can either clone them or use the ones from leapcode or pixelated."
echo "example: pip install -r server/pkg/requirements-latest.pip"
