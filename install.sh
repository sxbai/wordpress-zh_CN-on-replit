#!/bin/bash
# Install WordPress 中文版 on Repl.it
# Copyright © by 舒夏 All Rights Reserved.
# 2022/12/6 12:27
# 1. Create a new Repl.it as a PHP Web Server 
# 2. Update the replit.nix file to include the code in this repo
# 3. Restart the Repl
# 4. Run this command from the Replit shell:
#    bash <(curl -s https://raw.githubusercontent.com/sxbai/wordpress-zh_CN-on-replit/main/build.sh)

echo "准备在您的 Replit 中安装 Wordpress"

read -p "继续?输入Y安装输入N退出 <Y/n> " prompt
if [[ $prompt == "N" || $prompt == "n" || $prompt == "No" || $prompt == "no" ]]; then
  exit 0
fi

#Make sure steps 1-3 are completed before installing Wordpress
if ! [ -x "$(command -v less)" ]; then
  echo 'Error: less is not installed. Please make sure you have updated the replit.nix file and restarted the Repl.' >&2
  exit 1
fi

if ! [ -x "$(command -v wp)" ]; then
  echo 'Error: wp-cli is not installed. Please make sure you have updated the replit.nix file and restarted the Repl.' >&2
  exit 1
fi

#Make sure we're in the right place!
cd ~/$REPL_SLUG

#remove default repl.it code file
rm ~/$REPL_SLUG/index.php

#Download Wordpress!
wp core download --locale=zh_CN

#SQLITE Plugin: Download, extract and cleanup sqlite plugin for WP
curl -LG https://raw.githubusercontent.com/sxbai/wordpress-zh_CN-on-replit/main/db.php > ./wp-content/db.php

#Create dummy config to be overruled by sqlite plugin
wp config create --skip-check --dbname=wp --dbuser=wp --dbpass=pass --extra-php <<PHP
\$_SERVER[ "HTTPS" ] = "on";
define( 'WP_HOME', 'https://$REPL_SLUG.$REPL_OWNER.repl.co' );
define( 'WP_SITEURL', 'https://$REPL_SLUG.$REPL_OWNER.repl.co' );
define ('FS_METHOD', 'direct');
define('FORCE_SSL_ADMIN', true);
PHP

# Get info for WP install
read -p "输入 Wordpress 用户名: " username
while true; do
  read -s -p "输入 Wordpress 密码: " password
  echo
  read -s -p "再次输入Wordpress 密码: " password2
  echo
  [ "$password" = "$password2" ] && break
  echo "请重新尝试！"
done

read -p "请输入 Wordpress Email: " email
read -p "请输入 Wordpress 站点标题: " title

REPL_URL=$REPL_SLUG.$REPL_OWNER.repl.co

# Install Wordpress
wp core install --url=$REPL_URL --title=$title --admin_user=$username --admin_password=$password --admin_email=$email

echo "恭喜!!!"
echo "您的新WordPress网站现已设置完成! "
echo "网页地址: https://$REPL_URL"
echo "管理员地址: https://$REPL_URL/wp-admin"
echo "管理员账号: $username"
echo "管理员密码: $password"
rm -rf install.sh
