#!/bin/bash

function log()
{
	message=$1
	echo "$message"
	echo "$message" >> /var/log/sapconfigcreate
}


log "noop"


log "SUSE tril subscription"
SUSEConnect --url=https://scc.suse.com -e mazhar@spektrasystems.com -r 868E7EFC8D8DB8
sleep 10

log "creating PVs"
pvcreate /dev/sdc
pvcreate /dev/sdd
pvcreate /dev/sde
pvcreate /dev/sdf

log "Creating VGs"
vgcreate vg_hana_shared /dev/sdc
vgcreate vg_hana_data /dev/sdd /dev/sde
vgcreate vg_hana_log /dev/sdf

log "creating LVs"
lvcreate -l 100%FREE -n hana_shared vg_hana_shared
lvcreate -l 100%FREE -n hana_data vg_hana_data
lvcreate -l 100%FREE -n hana_log vg_hana_log

log "Formating Lvs to xfs"
mkfs.xfs /dev/vg_hana_shared/hana_shared
mkfs.xfs /dev/vg_hana_data/hana_data
mkfs.xfs /dev/vg_hana_log/hana_log

log "creating Directories to mount formated LVs"
mkdir -p /hana/shared
mkdir -p /hana/data
mkdir -p /hana/log

log "Adding partitions to fstab to mount on reboot"
echo "/dev/mapper/vg_hana_shared-hana_shared     /hana/shared    xfs   defaults,nofail   0 2" >> /etc/fstab
echo "/dev/mapper/vg_hana_data-hana_data     /hana/data    xfs   defaults,nofail   0 2" >> /etc/fstab
echo "/dev/mapper/vg_hana_log-hana_log     /hana/log    xfs   defaults,nofail   0 2" >> /etc/fstab

log "Mounting newly created partition using fstab file"
mount -a

log "Creating media directory"
mkdir -m 777 /hana/shared/media

log "Adding host entried to resolve by name in hosts file"
echo "172.17.1.10    s03-db-0" >> /etc/hosts
echo "172.17.1.11    s03-db-1" >> /etc/hosts

log "enable root login for cluster level root access across nodes"
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config

#log "configureing root password"
#echo "root:6fhTyhkm6M7S66Fc" | chpasswd

log "downloading ssh key pair"
mkdir /root/.ssh
wget https://spektraazurelabs.blob.core.windows.net/saplabs/id_rsa -O /root/.ssh/id_rsa
wget https://spektraazurelabs.blob.core.windows.net/saplabs/id-rsa.pub -O /root/.ssh/id_rsa.pub 
wget https://spektraazurelabs.blob.core.windows.net/saplabs/id-rsa.pub -O /root/.ssh/authorized_keys

log "configure permission for ssh key pair"
chown -R root:root /root/.ssh
chmod 700 /root/.ssh
chmod 600 /root/.ssh/id_rsa
chmod 644 /root/.ssh/id_rsa.pub
chmod 600 /root/.ssh/authorized_keys

log "download SAP media"
wget https://saphanalabs${1}.blob.core.windows.net/saplabs/SAP.zip -O /hana/shared/media/SAP.zip
unzip /hana/shared/media/SAP.zip -d /hana/shared/media/
mv /hana/shared/media/SAP/* /hana/shared/media/
chmod -R +x /hana/shared/media/SAP-Media/
#rm /SAPMedia/SAP.zip

log "restart SSH service"
systemctl restart sshd

