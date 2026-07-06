export PKG_CONFIG_PATH="$(pwd)/libs/build_libs/lib/pkgconfig"

sudo update-alternatives --set gcc /usr/bin/gcc-8
sudo update-alternatives --set g++ /usr/bin/g++-8
sudo update-alternatives --set cpp /usr/bin/cpp-8

cd libs
make

sudo update-alternatives --auto gcc
sudo update-alternatives --auto g++
sudo update-alternatives --auto cpp

