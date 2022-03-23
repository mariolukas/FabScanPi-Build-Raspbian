#!/bin/bash
# get pi-gen sources
git clone https://github.com/RPi-Distro/pi-gen
cd pi-gen
git fetch && git fetch --tags
#git checkout 2022-01-28-raspios-bullseye
git checkout 5d044ba71b7eba33860fdbf222a9a29ae42691e9

cd ..

touch pi-gen/stage5/SKIP_IMAGES
touch pi-gen/stage5/SKIP

touch pi-gen/stage4/SKIP_IMAGES
touch pi-gen/stage4/SKIP

# modifiy orignal build script
#${ echo -n 'export FABSCANPI_STAGE="\$\{FABSCANPI_STAGE:-testing\}"\n export ENABLE_SWAPPING="\$\{ENABLE_SWAPPING:-1\}"\n'; cat build.sh; } > pi-gen/build.sh



#copy config
cp config pi-gen/config

# copy fabscan stage
cp -R stage-fabscan pi-gen/stage-fabscan

echo $OSTYPE

case "$OSTYPE" in
darwin*)
echo "Preparing sed to work with OSX"
sed -i '' 's/setarch linux32//g' pi-gen/scripts/common

sed -i '' '228i\
export FABSCANPI_STAGE=${FABSCANPI_STAGE:-testing}
' pi-gen/build.sh

sed -i '' '228i\
export ENABLE_SWAPPING=${ENABLE_SWAPPING:-1}
' pi-gen/build.sh

;;
*)
sed -i '228i\
export FABSCANPI_STAGE=${FABSCANPI_STAGE:-testing}
' pi-gen/build.sh

sed -i '228i\
export ENABLE_SWAPPING=${ENABLE_SWAPPING:-1}
' pi-gen/build.sh
;;
esac

echo "Running build...."
cd pi-gen
./build-docker.sh
