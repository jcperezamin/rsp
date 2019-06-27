#!/bin/bash

domain=$1
internalip=$2
block="/etc/nginx/sites-available/$domain"

sudo tee $block > /dev/null <<EOF
server {
  server_name $domain;
  listen 48080 ssl;
  access_log /var/log/nginx/ifs-proxy-mws-access.log;
  error_log /var/log/nginx/ifs-proxy-mws-error.log;

  proxy_ssl_verify off;

  ssl_protocols TLSv1.1 TLSv1.2;
  ssl_ciphers ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA256:AES256-GCM-SHA384:AES256-SHA256:AES128-GCM-SHA256:AES128-SHA;

  # custom error page
  error_page 400 401 402 403 404 500 501 502 503 504 /oops.html;
  location = /oops.html {
    root /usr/share/nginx/html;
    allow all;
    internal;
  }

  # landing page
  location / {
    proxy_pass https://$internalip:48080;

  }

  location /ifs.css {
    proxy_pass https://$internalip:48080;

  }

  location /documentation.html {
    proxy_pass https://$internalip:48080;

  }

  location /scripts/ {
    proxy_pass https://$internalip:48080;

  }

  location /images/ {
    proxy_pass https://$internalip:48080;

  }

  location /ifsdoc/ {
    proxy_pass https://$internalip:48080;

  }


  # ee client
  location /main/default/ {
    proxy_pass https://$internalip:48080;

  }

  location /int/default/ {
    proxy_pass https://$internalip:48080;

  }

  location /websocket {
    proxy_pass https://$internalip:48080;

  }

  location /client/runtime/ {
    proxy_pass https://$internalip:48080;

  }

  location /ifsfileservice/ {
    proxy_pass https://$internalip:48080;

  }

  location /add-on/ {
    proxy_pass https://$internalip:48080;

  }

  location /add-on.html {
    proxy_pass https://$internalip:48080;

  }


  # ee admin
  location /admin {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;

  }

  location /index_admin.html {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;

  }

  location /main/admin/ {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;


  }

  location /int/admin/ {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;


  }


  # aurena
  location /main/ifsapplications/ {
    proxy_pass https://$internalip:48080;

  }


  # aurena b2b
  location /b2b/ifsapplications/ {
    proxy_pass https://$internalip:48080;

  }

  # integration
  location /interfacebrowser {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;


  }

  location /webservices {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;


  }

  location /int/soapgateway {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;


  }

  location /int/ifsapplications/ {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;


  }


  # legacy access provider
  location /main/compatibility/ {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;


  }

  location /int/compatibility/ {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;


  }


  # db identity provider
  location /openid-connect-provider/ {
    proxy_pass https://$internalip:48080;

  }

  # plsql access provider
  location /main/soapgateway {

  }

  # third party product endpoints
  location /gisint {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;


  }

  location /appsrv {
    proxy_pass https://$internalip:48080;

    include /etc/nginx/includes/customer_whitelist;
    include /etc/nginx/includes/ifs_whitelist;

  }

}

EOF

# Link to make it available
sudo ln -s $block /etc/nginx/sites-enabled/

# Test configuration and reload if successful
sudo nginx -t && sudo service nginx reload
