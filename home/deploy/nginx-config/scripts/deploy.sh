#!/bin/bash

echo "=== Deploy gestart op $(date) ===" >> /var/log/deploy.log

# Stap 1: Navigeer naar project
cd /home/deploy/resrv || exit

# Stap 2: Haal laatste versie van de repository op
git pull origin main >> /var/log/deploy.log

# Stap 3: Verwerk alle .conf bestanden
for conf in home/deploy/nginx-config/domains/*.conf; do
  confname=$(basename "$conf")
  cp "$conf" "/etc/nginx/sites-available/$confname"
  ln -sf "/etc/nginx/sites-available/$confname" "/etc/nginx/sites-enabled/$confname"
done

# Stap 4: Controleer en herstart NGINX
nginx -t && systemctl reload nginx

echo "=== Deploy voltooid op $(date) ===" >> /var/log/deploy.log
