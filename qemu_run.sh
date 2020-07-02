BIN=kernel.img
MONITOR_PORT=1235
ISO=kernel.iso
ARCH=x86_64

qemu-system-${ARCH} \
	-M q35 \
	-m 1024 \
	-no-reboot \
	-monitor telnet:127.0.0.1:${MONITOR_PORT},server,nowait \
	-curses \
	-cdrom ${ISO} \
	#-kernel ${BIN} \

