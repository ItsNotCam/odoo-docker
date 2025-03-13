mkdir -p \
  docker-volumes/nginx_logs    \
	docker-volumes/postgres_data \
	docker-volumes/odoo_addons

read -sp "Enter root password for odoo: " ROOT_PWD
echo $ROOT_PWD > pwd.tmp
echo

read -p "Do you want to encrypt this password file? (y/n): " DO_ENCRYPT
if [[ $DO_ENCRYPT == "y" ]]; then
	read -sp "Enter the password to your user account: " USER_PWD
	echo
	openssl enc -aes-256 -iter 100000 -salt -in pwd.tmp -out odoo/odoo_root_pwd.txt -pass pass:$USER_PWD
	rm pwd.tmp
else
	mv pwd.tmp odoo/odoo_root_pwd.txt
fi
echo

cd odoo
docker build \
	--build-arg ROOT_PASSWORD=$ROOT_PWD \
	--no-cache \
	-t odoo:latest \
	-f odoo.Dockerfile.dev .
cd ..

# Cleanup
unset ROOT_PWD
unset USER_PWD
unset DO_ENCRYPT