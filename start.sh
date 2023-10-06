#!/bin/bash

echo ""
echo "1. [ SET RUNTIME DIR ]"
export XDG_RUNTIME_DIR=${TMPDIR}
echo "DONE"

sleep 1

echo ""
echo "2. [ SET PULSE AUDIO ]"
pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
echo "DONE"

sleep 1
echo ""
echo "3. [ START termux-x11 ]"
termux-x11 > /dev/null &
echo "DONE"
echo ""

sleep 6

echo ""
echo "4. [ DISTRO LOGIN && START X-11 ]"
echo ""
proot-distro login ubuntu --shared-tmp -- runuser -l con -c 'DISPLAY=:0 xfce4-session'
echo ""
echo "DONE"
echo ""

exit 0
