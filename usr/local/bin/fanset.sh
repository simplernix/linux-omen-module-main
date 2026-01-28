#!/bin/bash
set -e  # Exit on any error

# Ask for sudo password once
if [ "$EUID" -ne 0 ]; then
    exec sudo bash "$0" "$@"
fi

echo "[*] Navigating to source directory..."
cd /home/saurabh/Downloads/linux-omen-module-main || {
    echo "[-] Source directory not found! Exiting."
    exit 1
}

echo "[*] Building kernel module..."
make

echo "[*] Reloading hp_wmi module..."
if lsmod | grep -q hp_wmi; then
    rmmod hp_wmi
fi
insmod hp-wmi.ko

echo "[*] Copying binaries to /usr/local/bin..."
for f in usr/local/bin/*; do
  [ "$(basename "$f")" = "fanset.sh" ] && continue
  cp -v "$f" /usr/local/bin/
done


echo "[*] Installing systemd service and timer files..."
cp -v etc/systemd/system/* /etc/systemd/system/

echo "[*] Installing udev rules..."
cp -v etc/udev/rules.d/* /etc/udev/rules.d/

echo "[*] Reloading systemd manager configuration..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

echo "[*] Enabling and starting services..."

sudo systemctl enable --now fan_auto.service
sudo systemctl enable --now fan_auto.timer

sudo systemctl enable --now Omenfan.service
sudo systemctl enable --now Omenhsaclient.service
sudo systemctl enable --now Omenhsaclient.timer
echo "[*] Restarting Omenfan service..."
systemctl daemon-reload
systemctl restart Omenfan.service

echo "[*] Setting fan to auto..."
if command -v fan_speed &> /dev/null; then
    fan_auto
else
    echo "[-] fan_speed command not found. Make sure it's installed and in PATH."
fi

echo "[✓] Setup completed successfully!"
