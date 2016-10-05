#########################################################
#       Shell Script for creating Apache Vhost          #
#             With FTP user And Password                #
#                                   By Amal CP          #
#                                   itsamalcp@gmail.com #
#########################################################
#!/bin/bash
echo "Enter The domain Name :"
read -r domain
echo "Enter Your mail Address :"
read -r email
rootdir=/var/www/$domain
#====== Creating FTP User ======="
user=$(echo "$domain" | cut -d"." -f1)
username=w-$user

if ! [ -d $rootdir ]; then

                        mkdir -p $rootdir/httpdocs
                        ### give permission to root dir
                        chmod 755 $rootdir
                        ### write test file in the new domain dir
                        if ! echo "This Site is Live Now...!!! " > $rootdir/httpdocs/index.html
                        then
                                echo "ERROR: Not able to write in file $rootdir/index.html. Please check permissions"
                                exit 1
                        else
                                echo "\n<<===============Added Content==============>>"
                        fi
fi

# Creating password and setting permission

pass=$(makepasswd --chars 16)
rootdir=/var/www/$domain
/bin/mkdir -p "$rootdir/httpdocs"

# checking user esisting in passwd

if id "$username" >/dev/null 2>&1; then
        echo "Username exist. Aborting Shell...!!!"
        exit 1
else
        /usr/sbin/useradd -d "$rootdir" -p "$pass" "$username"
        cp -r /etc/vsftpd.userlist /etc/vsftpd.userlist.bak
        echo "$username" >> /etc/vsftpd.userlist
        chown -R "$username:$username" "$rootdir"
fi

###---- Creating Vhost ----###
if ! echo "<VirtualHost *:80>
        ServerName $domain
        ServerAlias www.$domain
        DocumentRoot $rootdir/httpdocs
        <Directory $rootdir/httpdocs>
                Options Indexes FollowSymLinks MultiViews
                AllowOverride ALL
                Order allow,deny
                allow from all
        </Directory>
        <IfModule mpm_itk_module>
                AssignUserId $username $username
        </IfModule>
</VirtualHost>" > /etc/apache2/sites-available/$domain.conf
                then
                        echo "There is an ERROR creating $domain file"
                        exit 1
                else
                        echo "\n<<=========New Virtual Host Created=========>>\n"
                fi
#echo "enabling site"
a2ensite $domain.conf

# "restarting apache"
service apache2 reload

#======= Disply The FTP Details  ====

echo "====================\nHost Name : $domain\nUser Name : $username\nPassword  : $pass\nPortNum   : 21\n===================="

# Send amil

echo "====================\nHost Name : $domain\nUser Name : $username\nPassword  : $pass\nPortNum   : 21\n====================" | mail -s "New FTP Site Created" -a "From: admin@xample.com" $email

####============================================= END OF THE SCRIPT =====================================================  #####
