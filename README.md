# FabScanPi-gen
_Tool used to create the fabscan.org Raspbian images. Based on raspberrypi.org Raspbian images_
This build script uses the official Raspbian build script  (https://github.com/RPi-Distro/pi-gen). 

It adds a fabscan stage to the default Raspbian image build. 

## Build the Image
Be sure that you have installed Docker on yout System. You will also need a git client installed.
Just start the script by calling: 

  ./build-fabscan.sh

## Clean up
For cleaning up the workspace just call 

  sudo ./clean.sh

## Build folder. 
The build will be placed in the folder ```deploy```



