#!/bin/bash

#check whiptail 
printf "\033c"

versionPHP=("7.4" "8.0" "8.1" "8.2")
 


function checkError(){

exitstatus=$?
message=$1 || "-"
if [ ! $exitstatus  -eq 0 ]; then
 echo -e "\n\e[0;41mFail to complete a task [${message}]  \e[0m\n"
 exit 1
fi

}

function message(){

exitstatus=$?
message=$1
if [ $exitstatus  -eq 0 ]; then
echo -e "\n\e[1;42m ${message} done   \e[0m\n"
else
 echo -e "\n\e[0;41mFail to complete a task  \e[0m\n"
 exit 1
fi

}


function updateSys()
{  
sudo rm /var/lib/dpkg/lock 2>/dev/null
sudo rm /var/lib/apt/lists/lock 2>/dev/null
sudo rm /var/cache/apt/archives/lock 2>/dev/null
#sudo dpkg --configure -a
sudo apt-get update 
}


#-------------------------------------------------
function  clear()
{
    printf "\033c"
}

function inArray()
{
  hasValue=$1  

if [[ " ${versionPHP[*]} " =~ " ${hasValue} " ]]; then
 result=true
else 
 checkError "PHP Version Not support"
fi

}


 
function setupPHP()
{

 read -p "Enter PHP Version [7.4 , 8.0 , 8.1 , 8.2 ] ? " verPHP
inArray $verPHP
 
if [[ $result == true ]]
then
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
updateSys
 
 sudo apt install php${verPHP}-common \
    php${verPHP}-mysql \
    php${verPHP}-xml \
    php${verPHP}-xmlrpc \
    php${verPHP}-curl \
    php${verPHP}-gd \
    php${verPHP}-imagick \
    php${verPHP}-cli \
    php${verPHP}-gettext \
    php${verPHP}-dev \
    php${verPHP}-imap \
    php${verPHP}-fpm \
    php${verPHP}-mbstring \
    php${verPHP}-opcache \
    php${verPHP}-soap \
    php${verPHP}-zip \
    php${verPHP}-bcmath \
    libapache2-mod-php \
    php${verPHP}-intl -y

 checkError "PHP Version "
    message " php Install Please read file readme-php.md"
fi

 


}










function setupComposer(){


if [[ ! $(which php)  ]]; then
updateSys
sudo apt install php-cli unzip
sudo apt install php-mbstring
sudo apt install curl unzip
sudo apt install php php-curl
checkError "php "
fi


if [[ ! $(which composer)  ]]; then

updateSys
curl -sS https://getcomposer.org/installer -o composer-setup.php
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
checkError "composer "
fi 


}

function  setupMysql()
{
updateSys
    sudo apt install mysql-server
    checkError
      message " Mysql Install Please read file readme-mysql.md"
}


function setupMail()
{
    
if [[ ! $(which maildev)  ]]; then
npm install maildev -g
maildev
  else 
maildev
  fi  
checkError "Mail Dev"
 
}


function setupPHPMyadmin()
{

if [[ ! $(which mysql)  ]]; then
 checkError "Mysql not install"
fi
sudo apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y
checkError


 message " PHPMyadmin Install Please read file readme-phpmyadmin.md"
#generate help
#https://localhost/phpmyadmin



}






function setupApache2()
{
updateSys
sudo apt upgrade
sudo apt install  ca-certificates apt-transport-https software-properties-common -y
sudo apt install apache2 -y
sudo systemctl enable apache2
sudo systemctl start apache2 
checkError
sleep .25

}






function setupNginx()
{
updateSys
# sudo apt upgrade
sudo apt install  ca-certificates apt-transport-https software-properties-common
sudo apt install nginx-full -y
sudo systemctl enable nginx
sudo systemctl start nginx 
sudo nginx -t
checkError
sleep .25

}


function setupNodeJs()
{
    # sudo apt install nodejs
    # sudo apt install npm
    # echo "nodejs"
 
Nodeoptions=("NodeJS" "NVM Node Version Manager"  "Exit")

select opt_node in "${Nodeoptions[@]}"
do
    case $opt_node in

        "NodeJS")
            echo -e "\e[0;32m -> Install Nginx...\e[0m"
            updateSys
                sudo apt install nodejs
                sudo apt install npm
           message "NodeJS Install"
            ;;

        "NVM Node Version Manager")
            echo -e "\e[0;32m -> Install NVM Node Version Manager...\e[0m"
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
            #source ~/.zshrc
            checkError "node nvm"
           #nvm use --lts
           message " NVM Install Please read file readme-node.md "
            ;;

        "Exit")
            exit
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


#end

}



function handleServices()
{
   sudo service --status-all 
   #sudo systemctl list-unit-files --type=service

}


function setupKeygen(){
read -p "Enter Email ? " email
[ ! -z "$email" ] || checkError "Invalid Port"
ssh-keygen -t ed25519 -C "$email"
checkError
sleep .25
}




function createDomain()
{
#currentUSER=$(whoami)    
#USER="$(id -u -n)"
siteDir=/var/www/html/$webName
  mkdir -p  $siteDir/public_html/
  chmod -R 777 $siteDir/public_html/
  chown -R $USER:$USER $siteDir/public_html/
 checkError "Create domain "
  echo -e "\e[0;32m -> Directory Created  \e[0m"
}


function handelHost()
{

hostoptions=("Nginx" "Apache2"  "Exit")
 
select opt_host in "${hostoptions[@]}"
do
    case $opt_host in

        "Nginx")
            echo -e "\e[0;32m -> Create Virtual Host For Nginx...\e[0m"
          read -p "Enter HostName ? " webName
         createDomain $webName
       
          sudo ./virtualhost-nginx.sh create $webName $siteDir/public_html/
        checkError "Virtual Host For Nginx "
        echo -e "\e[0;32m -> Virtual HostCreated  \e[0m"
          sudo nginx -t
        sudo systemctl restart nginx
        echo -e "\e[0;32m -> restart nginx  \e[0m"
          message "Virtual Host For Nginx $webName"
            ;;

        "Apache2")
           echo -e "\e[0;32m -> Create Virtual Host For Apache2...\e[0m"
                  read -p "Enter HostName ? " webName
         createDomain $webName
         sudo ./virtualhost-apache.sh create $webName $siteDir/public_html/
         checkError "Virtual Host For apache  "
          echo -e "\e[0;32m -> Virtual Host Created  \e[0m"
         sudo apache2ctl configtest
         sudo systemctl restart apache2 
                 echo -e "\e[0;32m -> restart apache2  \e[0m"
         message "Virtual Host For Nginx $webName"
            ;;

        "Exit")
            exit
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


 #end
}


function handelSSH()
{

 

if [[ ! $(which ssh) ]]; then
updateSys
sudo apt install openssh-server
sudo apt install openssh-client
sudo systemctl enable ssh
#sudo systemctl enable ssh --now
sudo systemctl start ssh
#sudo ufw allow ssh
#sudo ufw delete allow ssh
checkError "ssh "
fi

#check file

if [ -e "remote.ini" ]; then 
 
read -p "Enter Server [Name]  ? " serverName
[ ! -z "$serverName" ] || checkError "serverName"

user=$( sed -nr "/^\[${serverName}\]/ { :l /^user[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ./remote.ini)
host=$( sed -nr "/^\[${serverName}\]/ { :l /^host[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ./remote.ini)
key=$( sed -nr "/^\[${serverName}\]/ { :l /^key[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ./remote.ini)
port=$( sed -nr "/^\[${serverName}\]/ { :l /^port[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ./remote.ini)


[ ! -z "$user" ] || checkError "SSH user missing"
[ ! -z "$host" ] || checkError "SSH host missing"
[ ! -z "$key" ] || checkError "SSH key missing"
[ ! -z "$port" ] || checkError "SSH port missing"



ssh -i  ${key} ${user}@${host} -p ${port} 
checkError "ssh unable to connect server"
#echo -o ConnectTimeout=30 ${key} ${user}@${host}  ${port}
# echo "ssh -i  ${key} ${user}@${host} -p ${port}"
#exec ssh  -i  ${key} ${user}@${host} -p ${port} 
 #checkError "ssh unable to connect server  2> /dev/null "

 

else
checkError "remote.ini file not found"
fi





}
 



while [ 1 ]
do
echo -e "+ \e[0;44m Choose from the list to install \e[0m\t\t "  
echo ""  
#Menu Select
options=("Nginx Server" "Apache2 Server"  "PHP Version" "Mysql Database" "PhpmyAdmin" "Composer" "MailDev(Testing)" "Virtual Host"
"NodeJs" "SSH connection" "Services" "Generate keygen" "Show Menu" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Nginx Server")
            echo -e "\e[0;32m -> Install Nginx...\e[0m"
           setupNginx
           message "Install Nginx"
            ;;

        "Apache2 Server")
            echo -e "\e[0;32m -> Install Apache2...\e[0m"
           setupApache2
           message "Install Apache2"
            ;;

        "Mysql Database")
            echo -e "\e[0;32m -> Install Mysql...\e[0m"
           setupMysql
           message "Mysql Install "
            ;;
       "PhpmyAdmin")
            echo -e "\e[0;32m -> Install PhpmyAdmin...\e[0m"
           setupPHPMyadmin
           message "PhpmyAdmin Install "
            ;;

      "PHP Version")
            echo -e "\e[0;32m -> Install PHP...\e[0m"
           setupPHP
           message "PHP Install"
            ;;

     "NodeJs") 
        echo -e "\e[0;33m -> Select Type Of Node Install...\e[0m"
     
           setupNodeJs
            ;;

       "Composer")
            echo -e "\e[0;32m -> Install Composer...\e[0m"
           setupComposer
           message "Composer Install "
            ;;


      "MailDev(Testing)")
            echo -e "\e[0;32m -> MailDev Testing...\e[0m"
           setupMail
           message "MailDev Install "
            ;;

     "Generate keygen")
            echo -e "\e[0;32m -> Generate keygen...\e[0m"
           setupKeygen
           message "Generate Key"
            ;;

    "Virtual Host")
            echo -e "\e[0;32m ->Create Virtual Host...\e[0m"
           handelHost
     
            ;;

   "Services")
            echo -e "\e[0;32m ->Services Runing ...\e[0m"
           handleServices
           message "Services Runing"
            ;;

   "SSH connection")
            echo -e "\e[0;32m ->Use SSH to Connect to a Remote Server ...\e[0m"
           handelSSH
        
            ;;

 



      "Show Menu")
            break
            ;;

        "Quit")
            exit 1
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
done

