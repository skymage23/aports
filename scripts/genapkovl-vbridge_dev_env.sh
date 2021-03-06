#!/bin/sh -e

HOSTNAME="vbridge"
if [ -z "$HOSTNAME" ]; then
	echo "usage: $0 hostname"
	exit 1
fi

cleanup() {
	rm -rf "$tmp"
}

makefile() {
	OWNER="$1"
	PERMS="$2"
	FILENAME="$3"
	cat > "$FILENAME"
	chown "$OWNER" "$FILENAME"
	chmod "$PERMS" "$FILENAME"
}

rc_add() {
	mkdir -p "$tmp"/etc/runlevels/"$2"
	ln -sf /etc/init.d/"$1" "$tmp"/etc/runlevels/"$2"/"$1"
}

tmp="$(mktemp -d)"
trap cleanup EXIT

mkdir -p "$tmp"/etc
makefile root:root 0644 "$tmp"/etc/hostname <<EOF
$HOSTNAME
EOF

makefile root:root 0644 "$tmp"/etc/modules <<EOF
nfs
EOF

mkdir -p "$tmp"/etc/network
makefile root:root 0644 "$tmp"/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback
iface eth0 inet dhcp
EOF

mkdir -p "$tmp"/etc/apk

makefile root:root 0644 "$tmp"/etc/apk/world <<EOF
busybox
kbd-bkeymaps
chrony
dhcpcd
e2fsprogs
haveged
openntpd
openssl
openssh
tzdata
wget
vim
python3
screen
tmux
EOF

makefile root:root 0644 "$tmp"/etc/motd <<EOF
############################################################
# Welcome to the vBridge Development and Test Environment. #
############################################################

This is a small image based on Alpine Linux 3.15.0
By default, it has no way to connect to your
host computer's outer network infrastructure,
(although networking with the host directly is allowed).

However, you do have Vim, GNU Screen, Tmux, and Python3.
EOF

rc_add devfs sysinit
rc_add dmesg sysinit
rc_add udev sysinit

rc_add hwclock boot
rc_add modules boot
rc_add sysctl boot
rc_add hostname boot
rc_add bootmisc boot
rc_add syslog boot

rc_add udev-postmount default
rc_add mount-ro shutdown
rc_add killprocs shutdown
rc_add savecache shutdown

rc_add networking default
rc_add sshd default

tar -c -C "$tmp" etc | gzip -9n > $HOSTNAME.apkovl.tar.gz
