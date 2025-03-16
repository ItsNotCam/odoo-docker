export DOCKER_BUILDKIT=1

# Variables
DIR=$(pwd)
ODOO_ROOT_PWD_FILE=$DIR/odoo/odoo_root_pwd.txt
GIT_REPO=https://github.com/odoo/odoo.git
COMMIT_ID=b394204

# Create directories
mkdir -p $DIR/docker-volumes/{nginx_logs,postgres_data,odoo_addons}

# Create root password file if it doesn't exist
if [ ! -f "$ODOO_ROOT_PWD_FILE" ]; then
	read -sp "Enter root password for odoo: " ROOT_PWD
	echo
	echo $ROOT_PWD > $ODOO_ROOT_PWD_FILE
	chmod 644 $ODOO_ROOT_PWD_FILE
fi

# Build odoo image
docker build . \
	--no-cache \
	--secret id=root_password,src=$ODOO_ROOT_PWD_FILE \
	-t odoo:latest

# Cleanup
unset ROOT_PWD
unset USER_PWD
unset DO_ENCRYPT