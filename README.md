## Ansible script backup for linux-user

**Just add/edit users you want to backup in backup.sh in place of usr1 usr2 and run ansible-playbook with root user**

### Script for backing up user directory.

```
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
```

### backup.yaml

```
---
- hosts: all
  gather_facts : no
  become: yes
  tasks:
    - name: create file
      file:
        dest: .txt
        state: touch
      delegate_to: localhost

    - name: Copy and Run Script
      script: backup.sh --creates /tmp
      register: op
      become: yes

    - name: append
      lineinfile:
        dest: output.txt
        line: "{{ op.stdout }}"
        insertafter: EOF
      delegate_to: localhost

    - name: Remove script from the server
      file:
        state: absent
        path: /tmp/backup.sh

    - name: Fetch all the file on local
      fetch:
        src: /tmp/backup.tar.gz
        dest: /tmp/backup/*
        flat: yes

    - name: Remove all the backup folder
      shell: rm -rf /tmp/backup*
```

```
ansible-playbook -i <inventory_file> backup.yaml -u root -k
```

