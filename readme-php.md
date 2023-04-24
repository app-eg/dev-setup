
### NGINX Configuration

```
sudo ufw allow 'Nginx HTTP'

sudo apt install php-fpm php-mysql
sudo systemctl start|stop|status|enable php8.1-fpm

sudo mkdir -p /var/www/html/app.local/public_html
sudo chown -R $USER:$USER /var/www/html/app.local/public_html
sudo chmod -R 777 /var/www/html/app.local


sudo nano /etc/nginx/sites-available/app.local

sudo ln -s /etc/nginx/sites-available/app.local /etc/nginx/sites-enabled/
```
---
```
server {
  # Example PHP Nginx FPM config file
  listen 80 default_server;
  listen [::]:80 default_server;
  root /var/www/html;

  # Add index.php to setup Nginx, PHP & PHP-FPM config
  index index.php index.html index.htm index.nginx-debian.html;
  
    #add_header X-Frame-Options "SAMEORIGIN";
    #add_header X-XSS-Protection "1; mode=block";
    #add_header X-Content-Type-Options "nosniff";
  server_name _;

	location / {
	autoindex on;
		# First attempt to serve request as file, then
		# as directory, then fall back to displaying a 404.
		try_files $uri $uri/ =404;
        #for laravel use
        #try_files $uri $uri/ /index.php?$query_string; 
	}

  # pass PHP scripts on Nginx to FastCGI (PHP-FPM) server
location ~ \.php$ {
    try_files $uri =404;
    fastcgi_pass unix:/run/php/php8.1-fpm.sock;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
  }

  # deny access to Apache .htaccess on Nginx with PHP, 
  # if Apache and Nginx document roots concur
    location ~ /\.(?!well-known).* {
        deny all;
    }
} # End of PHP FPM Nginx config example
```

- sudo nginx -t
- sudo systemctl restart nginx


---

### Apache2 Configuration

```
sudo ufw allow in "Apache Full"

sudo apt install php libapache2-mod-php php-mysql


sudo mkdir -p /var/www/html/app.local/public_html
sudo chown -R $USER:$USER /var/www/html/app.local/public_html
sudo chown -R www-data:www-data /var/www/html/app.local/public_html

sudo chmod -R 755 /var/www/html/app.local/public_html


sudo nano /etc/apache2/sites-available/app.local.conf
or
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/app.local.conf
```

```
<VirtualHost *:80>
    ServerName app.local
    ServerAlias www.app.local
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/app.local
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>

```

- sudo a2ensite app.local
- sudo apache2ctl configtest
- sudo systemctl reload apache2



# switch php version

```
sudo a2dismod php* 
sudo a2enmod php8.1
sudo a2enmod actions fcgid alias proxy_fcgi
sudo systemctl restart apache2 
sudo update-alternatives --config php
```

#### apache multi version php

```
<VirtualHost *:80>
     ServerAdmin admin@site1.your_domain
     ServerName site1.your_domain
     DocumentRoot /var/www/site1.your_domain
     DirectoryIndex index.php

     <Directory /var/www/site1.your_domain>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
     </Directory>

    <FilesMatch \.php$>
        # From the Apache version 2.4.10 and above, use the SetHandler to run PHP as a fastCGI process server
         SetHandler "proxy:unix:/run/php/php7.2-fpm.sock|fcgi://localhost"
    </FilesMatch>

     ErrorLog ${APACHE_LOG_DIR}/site1.your_domain_error.log
     CustomLog ${APACHE_LOG_DIR}/site1.your_domain_access.log combined
</VirtualHost>
```

---
 
 ### firewall

- sudo ufw app list
- sudo ufw enable
- sudo ufw status
- sudo ufw reload

###  increase upload file size

```
php -ini | grep php.ini

upload_max_filesize = 128M
post_max_size = 128M
memory_limit = 256M


systemctl restart nginx		
systemctl restart apache2

```



