# Latest Ubuntu LTS as of 03/13/2025
FROM ubuntu:24.04

# Environment variables
ENV ODOO_PATH="/odoo"
ENV GIT_REPO="https://github.com/odoo/odoo.git"
ENV COMMIT_ID="b394204"

# Install dependencies
RUN apt update && apt upgrade -y
RUN apt install -y   \
	git                \
	python3            \
	python3-pip        \
	postgresql         \
	postgresql-client

# Create user
# RUN useradd -M -s /bin/false odoo   <- NO SHELL
RUN useradd -s /bin/bash odoo

# Create directory for odoo and delegate ownership
RUN mkdir -p $ODOO_PATH
RUN chown odoo:odoo $ODOO_PATH

# Pull the repo but only the latest commit
RUN git clone --depth 1 $GIT_REPO $ODOO_PATH

# Install odoo and delegate ownership
RUN $ODOO_PATH/setup/debinstall.sh

# Set root password using command line secret
RUN --mount=type=secret,id=root_password \
	ROOT_PASSWORD=$(cat /run/secrets/root_password) && \
	echo "root:$ROOT_PASSWORD" | chpasswd

RUN mkdir -p /var/lib/odoo
RUN chown -R odoo:odoo /var/lib/odoo

# Expose volume for configuration file and addons
VOLUME ["/odoo/odoo.conf", "/odoo/addons"]

# Expose port
EXPOSE 8069

# Entry
USER odoo
WORKDIR $ODOO_PATH
ENTRYPOINT ["python3", "odoo-bin", "--addons-path=addons", "-d" , "/odoo", "-c", "/odoo/odoo.conf", "-i", "base"]
