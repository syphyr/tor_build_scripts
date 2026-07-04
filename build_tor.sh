export PKG_CONFIG_PATH="$(pwd)/libs/build_libs/lib/pkgconfig:$(pwd)/libs/build_libs/lib64/pkgconfig"

sudo update-alternatives --set gcc /usr/bin/gcc-8
sudo update-alternatives --set g++ /usr/bin/g++-8
sudo update-alternatives --set cpp /usr/bin/cpp-8

cd tor
#fakeroot dpkg-buildpackage -tc
# fakeroot causes seccomp permission errors on test
#dpkg-buildpackage -tc
dpkg-buildpackage -uc -us -b -tc

sudo update-alternatives --auto gcc
sudo update-alternatives --auto g++
sudo update-alternatives --auto cpp
