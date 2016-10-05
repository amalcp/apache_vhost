#   Creating virtual Host with a FTP user 

Prerequisite :

1) A sudo user

2) VSFTPD server

- Install VsFTPD package
  
  $ apt-get update
  $ apt-get install vsftpd
  
- After installation touch a /etc/vsftpd.userlist file sore FTP users 
- Then open /etc/vsftpd.conf file and make changes as follows

  listen=YES
  
  anonymous_enable=NO
  
  local_enable=YES
  
  write_enable=YES
  
  chroot_local_user=YES
  
  pasv_min_port=6180
  
  pasv_max_port=6190
  
  userlist_enable=YES
  
  userlist_file=/etc/vsftpd.userlist
  
  userlist_deny=NO 
  pam_service_name=ftp


3) Makepasswd

  $ sudo apt-get install makepasswd	

4) chmod u+x Vhost.sh
