#! /bin/bash
DRIVER=535
DEBIAN_FRONTEND=noninteractive

# Clone Upstream
apt download nvidia-driver-"$DRIVER"
ar -x ./nvidia-driver-"$DRIVER"*.deb
mkdir -p ./nvidia-driver-"$DRIVER"/DEBIAN
tar -xf ./control.tar.* -C ./nvidia-driver-"$DRIVER"/DEBIAN/
tar -xf ./data.tar.* -C ./nvidia-driver-"$DRIVER"/
sed -i "s#nvidia-dkms-"$DRIVER"#nvidia-pika-kernel-module-"$DRIVER" | nvidia-dkms-"$DRIVER"#" ./nvidia-driver-"$DRIVER"/DEBIAN/control
sed -i "s#$(cat ./nvidia-driver-"$DRIVER"/DEBIAN/control | grep "Version: ")#$(cat ./nvidia-driver-"$DRIVER"/DEBIAN/control | grep "Version: ")-pika1.lunar#" ./nvidia-driver-"$DRIVER"/DEBIAN/control

apt install -y devscripts

# Build package
dpkg-deb --build ./nvidia-driver-"$DRIVER"/

# Move the debs to output
mkdir -p ./output
mv ./*.deb ./output/
