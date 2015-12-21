#!/bin/sh

machine=`uname -m`
if [ "${machine}" != "armv7l" ]; then
  echo "This script will be executed at mounted raspbian enviroment (armv7l). Current environment is ${machine}."
  exit 1
fi

echo "Please check environment variables etc, this script can be executed ONLY within RPI environment!"
echo "When tasks done, type \"exit\" to return"
echo ""
wget http://archive.fabscan.org/fabscan.public.key -O - | gpg --import -

cp /usr/src/delivery/firstboot.sh /root/firstboot.sh
cat << EOF > /etc/rc.local
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing

if [ ! -e /root/firstboot_done ]; then
        touch /root/firstboot_done
        if [ -e /root/firstboot.sh ]; then
                /root/firstboot.sh
        fi
fi

exit 0
EOF
