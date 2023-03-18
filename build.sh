nix-env -iA nixpkgs.wget
mkdir build
cd build
wget https://github.com/sxbai/wordpress-zh_CN-on-replit/raw/main/php.zip
nix-env -iA nixpkgs.unzip
unzip php.zip
cd ..
wget -O install.sh https://github.com/sxbai/wordpress-zh_CN-on-replit/raw/main/install.sh
cp -r build/.replit . && cp -r build/replit.nix .
cp -r build/.cache .cache
rm -rf build/
rm -rf README.md && bash install.sh
