mkdir -p docker-volumes/nginx_logs docker-volumes/postgres_data

cd odoo
docker build --no-cache -t odoo:latest -f odoo.Dockerfile.dev .
cd ..