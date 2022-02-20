profile_vbridge_dev_env() {
        profile_standard
        kernel_cmdline="${kernel_cmdline} unionfs_size=512M console=tty0 console=ttyS0,115200"
        syslinux_serial="0 115200"
        apks="$apks syslinux util-linux python3 vim screen tmux"
        local _k _a
        for _k in $kernel_flavors; do
                apks="$apks linux-$_k"
                for _a in $kernel_addons; do
                        apks="$apks $_a-$_k"
                done
        done
        apks="$apks linux-firmware"
	apkovl="./genapkovl-vbridge_dev_env.sh"
}
