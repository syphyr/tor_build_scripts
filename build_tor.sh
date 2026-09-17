# Base path
export TOR_LIBS_PATH="$(pwd)/libs/build_libs"

# Package configuration
export PKG_CONFIG_PATH="${TOR_LIBS_PATH}/lib/pkgconfig"

# LZMA settings
export LZMA_CFLAGS="-I${TOR_LIBS_PATH}/include -DLZMA_API_STATIC"
export LZMA_LIBS="-L${TOR_LIBS_PATH}/lib -llzma -pthread"

# ZSTD settings
export ZSTD_CFLAGS="-I${TOR_LIBS_PATH}/include"
export ZSTD_LIBS="-L${TOR_LIBS_PATH}/lib -lzstd -pthread"

# Tell the linker where to find libraries at runtime
export LD_LIBRARY_PATH=${TOR_LIBS_PATH}/lib:${LD_LIBRARY_PATH}

export CFLAGS="-I${TOR_LIBS_PATH}/include ${CFLAGS}"
export LDFLAGS="-L${TOR_LIBS_PATH}/lib ${LDFLAGS}"

export LIBS="-levent"

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
