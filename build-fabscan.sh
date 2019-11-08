#!/bin/bash

# get pi-gen sources
git clone https://github.com/RPi-Distro/pi-gen
cd pi-gen
git fetch && git fetch --tags
git checkout 2019-07-10-raspbian-buster
cd ..

touch pi-gen/stage5/SKIP_IMAGES
touch pi-gen/stage5/SKIP

touch pi-gen/stage4/SKIP_IMAGES
touch pi-gen/stage4/SKIP

# modifiy orignal build script
#${ echo -n 'export FABSCANPI_STAGE="\$\{FABSCANPI_STAGE:-testing\}"\n export ENABLE_SWAPPING="\$\{ENABLE_SWAPPING:-1\}"\n'; cat build.sh; } > pi-gen/build.sh
export FABSCANPI_STAGE="${FABSCANPI_STAGE:-testing}"
export ENABLE_SWAPPING="${ENABLE_SWAPPING:-1}"

#copy config
cp config pi-gen/config

# copy fabscan stage
cp -R stage-fabscan pi-gen/stage-fabscan


case "$OSTYPE" in
  darwin*)  
	echo "Preparing sed to work with OSX"
	sed -i -e 's/sed -r/sed -E/g' pi-gen/build-docker.sh
	;; 
esac

echo "Running build...."
cd pi-gen
#./build-docker.sh
./build.sh
