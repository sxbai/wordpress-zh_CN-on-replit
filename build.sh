git clone https://github.com/sxbai/wordpress-zh_CN-on-replit.git
cp -r wordpress-zh_CN-on-replit/replit.nix replit.nix && mv wordpress-zh_CN-on-replit/* .
rm -rf wordpress-zh_CN-on-replit/ && rm db.php
bash install.sh
