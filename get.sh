#git clone https://git.torproject.org/debian/tor.git
#git clone https://git.torproject.org/git/tor.git
#git clone https://github.com/syphyr/tor
#git clone https://gitlab.torproject.org/syphyr/tor.git 

if [ ! -d libs ]; then
	mkdir libs
fi

cd libs

if [ ! -d openssl ]; then
   git clone https://github.com/openssl/openssl.git
fi

cd openssl
git checkout openssl-3.5
git fetch
git rebase
git submodule update --init --recursive
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 origin/openssl-3.5
cd ..

if [ ! -d libevent ]; then
   git clone https://github.com/libevent/libevent.git
fi

cd libevent
git checkout 2.1.13-stable
git fetch
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 release-2.1.13-stable
cd ..

if [ ! -d xz ]; then
   git clone https://github.com/tukaani-project/xz
fi

cd xz
git checkout v5.4
git fetch
git rebase
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 origin/v5.4
cd ..

if [ ! -d zlib ]; then
   git clone https://github.com/madler/zlib
fi

cd zlib
git checkout v1.3.2-tag
git fetch
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 v1.3.2
cd ..

if [ ! -d zstd ]; then
   git clone https://github.com/facebook/zstd.git
fi

cd zstd
git checkout v1.5.7-tag
git fetch
git log --pretty="%C(yellow)%h %C(green)(%cr) %C(red)(%ar) %C(white)%s %C(blue)(%an)" -10 v1.5.7
cd ../..

if [ ! -d tor ]; then
   git clone https://gitlab.torproject.org/tpo/core/tor.git
   cd tor
   git remote add syphyr https://github.com/syphyr/tor
   git remote add gitlab https://gitlab.torproject.org/syphyr/tor.git
   git remote add debian https://gitlab.torproject.org/tpo/core/debian/tor.git
   cd ..
fi

cd tor

git checkout release-0.4.9
git fetch
git rebase
