

### check Mysql service

```bash
sudo systemctl status|stop|start|reload|restart|enable|disable mysql

```



### Connect Mysql

```bash
sudo mysql -u root

```
### Show databases and  Users 
```sql
show databases;
use mysql
SELECT User,Host,plugin FROM mysql.user;

```
### create new user
```
sudo mysql -p -u root
use mysql
CREATE USER 'work'@'%' IDENTIFIED WITH mysql_native_password BY 'pass';
GRANT ALL PRIVILEGES ON *.* TO 'work'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```


### new password for the root user

```sql
use mysql
ALTER USER  'root'@'localhost' IDENTIFIED BY 'pass';
FLUSH PRIVILEGES;
```


### Create User use plugin caching_sha2_password

```sql
CREATE USER 'user1'@'%' IDENTIFIED caching_sha2_password BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'user1'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

```

### GRANTS and PRIVILEGES 


```sql
SHOW GRANTS FOR 'user1'@'%';

GRANT ALL PRIVILEGES ON `dbname`.* TO 'phpmyadmin'@'localhost'

GRANT SELECT,INSERT,UPDATE,DELETE ON library.* TO 'librarymanager'@'localhost';

REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'user1'@'localhost';

                                            |
GRANT  ALL PRIVILEGES ON `dbname`.* FROM 'user1'@'localhost';


DROP USER 'user1'@'%';


```





