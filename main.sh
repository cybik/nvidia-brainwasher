#! /bin/bash
DRIVER=535
DEBIAN_FRONTEND=noninteractive

# Clone Upstream
#apt download nvidia-driver-"$DRIVER"
https://ppa.pika-os.com/pool/main/n/nvidia-graphics-drivers-535/nvidia-driver-535.deb
ar -x ./nvidia-driver-"$DRIVER"*.deb
mkdir -p ./nvidia-driver-"$DRIVER"/DEBIAN
tar -xf ./control.tar.* -C ./nvidia-driver-"$DRIVER"/DEBIAN/
tar -xf ./data.tar.* -C ./nvidia-driver-"$DRIVER"/
sed -i "s#nvidia-dkms-"$DRIVER"#nvidia-pika-kernel-module-"$DRIVER" | nvidia-dkms-"$DRIVER"#" ./nvidia-driver-"$DRIVER"/DEBIAN/control
sed -i "s#$(cat ./nvidia-driver-"$DRIVER"/DEBIAN/control | grep "Version: ")#$(cat ./nvidia-driver-"$DRIVER"/DEBIAN/control | grep "Version: ")-pika2#" ./nvidia-driver-"$DRIVER"/DEBIAN/control

apt install -y devscripts

# Build package
dpkg-deb --build ./nvidia-driver-"$DRIVER"/

# Move the debs to output
mkdir -p ./output
for i in ./*.deb
do
  mv $i ./output/$i-"$(apt-cache show nvidia-kernel-source-$DRIVER | grep Version: | head -n1 | cut -f2 -d":" | tr -d ' ')".deb
fi
