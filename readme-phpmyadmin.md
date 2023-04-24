
### NGINX Configuration

sudo nano /etc/nginx/snippets/phpmyadmin.conf

```
    location /phpmyadmin {
           root /usr/share/;
           index index.php index.html index.htm;
           location ~ ^/phpmyadmin/(.+\.php)$ {
                   try_files $uri =404;
                   root /usr/share/;
                   fastcgi_pass unix:/run/php/php8.1-fpm.sock;
                   fastcgi_index index.php;
                   fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                   include /etc/nginx/fastcgi_params;
           }
           location ~* ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
                   root /usr/share/;
           }
    }
```
##### edit  /etc/nginx/sites-available/default

server {
    . . .

    include snippets/phpmyadmin.conf;

    . . .
}


---

### Apache2 Configuration

sudo phpenmod mbstring

sudo nano /etc/apache2/apache2.conf


#add the phpMyAdmin configuration in the file at the end
Include /etc/phpmyadmin/apache2.conf

sudo /etc/init.d/apache2 restart

- for Secure phpMyAdmin (Optional)
```
sudo nano /etc/apache2/conf-available/phpmyadmin.conf
<Directory /usr/share/phpmyadmin>
Options SymLinksIfOwnerMatch
DirectoryIndex index.php
AllowOverride All 
```

sudo systemctl restart apache2



#https://localhost/phpmyadmin