mkdir -p /tmp/backup
for user in usr1 usr2 usr3
do
	if [ -d "/home/$user" ]
	then	
		echo "$user exist "
		rm -rf backup*
		rm -rf *zip
		tar -zcvpf /home/$user.tar.gz /home/$user
	else 
		echo "$user directory does not exist"
	fi
done 
mv /home/*.tar.gz /tmp/backup
tar -zcvpf /tmp/backup.tar.gz /tmp/backup