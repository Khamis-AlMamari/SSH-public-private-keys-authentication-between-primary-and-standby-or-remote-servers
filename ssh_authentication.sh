#!/bin/bash -
# Title         : ssh_authentication.sh
# Description   : This Script can do the automate setup of ssh-public/private-key authentication automatically for password-less between the primary and standby or remote servers for root and any users 
# Author        : Khamis Al Mamari
# Date          : 29/07/2024
# Version       : V1
# Account       : https://www.linkedin.com/in/khamis-almamari-7092a3215/
#============================================================================

generateSSH () {

typeset standbyIp=$1

cd /root/.ssh/
rm -f authorized_keys i*

echo -e "\n\n\n" | ssh-keygen -t rsa -N "" &>/dev/null
echo -e "\n\n\n" | ssh-keygen -t rsa1 -N "" &>/dev/null 
echo -e "\n\n\n" | ssh-keygen -t dsa -N "" &>/dev/null

cat id_dsa.pub>> authorized_keys
cat id_rsa.pub>> authorized_keys
cat identity.pub>> authorized_keys

echo ""
scp authorized_keys  root@${standbyIp}:/etc/ssh

cp *.pub /etc/ssh/
cp id* /home/oracle/.ssh/
cd  /home/oracle/.ssh/
chown oracle.dba id*

}

checkPath() {

cd /etc/ssh/

if grep  -R  "/etc/ssh/authorized_keys" /etc/ssh/sshd_config ; then
   echo ""
   echo -e "\033[1;92mThe Value is correct: No need to change\033[0m"

else
        sed -i -e "47d" /etc/ssh/sshd_config
        sed -i -e "47i AuthorizedKeysFile      /etc/ssh/authorized_keys" /etc/ssh/sshd_config

        if [ $? -ne 0 ]; then

        echo -e "\033[1;91mERROR: failed to modify the path of AuthorizedKeysFile\033[0m"
        echo -e "\033[1;91mPlease change it manulay\033[0m"

        else
        echo -e "\033[1;92mThe Path of AuthorizedKeysFile is change it correctly\033[0m"

        echo ""
        grep  -R  "/etc/ssh/authorized_keys" /etc/ssh/sshd_config
   fi
fi

service sshd restart &>/dev/null 

}



checkStdPath() {

typeset standbyIp=$1
ssh root@${standbyIp} 'sed -i -e "47d" /etc/ssh/sshd_config; sed -i -e "47i AuthorizedKeysFile      /etc/ssh/authorized_keys" /etc/ssh/sshd_config; service sshd restart &>/dev/null'

}

checkOracle_user () {
id oracle &>/dev/null
if [[ $? -ne 0 ]]; then
groupadd -g 400 dba
useradd -g 400 -u 400 -d /home/oracle oracle
echo "oracle:ora123"|chpasswd
fi 
} 

checkSSH_directory () {
if [ ! -d /home/oracle/.ssh ]; then
  mkdir /home/oracle/.ssh
fi

if [ ! -e /home/oracle/.Xauthority ]; then
  touch /home/oracle/.Xauthority
fi

} 


if [[ $UID -ne 0 ]]; then

  echo "******************************************************************************"
  echo -e "\033[1;93mThis script must be run as root \033[0m"
  echo "******************************************************************************"
  exit 1
fi

checkOracle_user
checkSSH_directory

echo ""
echo "******************************************************************************"
echo -e "\033[1;93mKindly Input the Standby IP \033[0m"
echo "******************************************************************************"
read standbyIp 

generateSSH "${standbyIp}"

echo ""
echo "******************************************************************************"
echo -e "\033[1;93mCheck the current path of AuthorizedKeysFile \033[0m"
echo "******************************************************************************"
echo ""

checkPath 

echo ""
echo "******************************************************************************"
echo -e "\033[1;93mModify the path of Standby AuthorizedKeysFile \033[0m"
echo "******************************************************************************"
echo ""

 if [ $? -ne 0 ]; then
        echo -e "\033[1;91mERROR: failed to modify the path of Standby AuthorizedKeysFile\033[0m"
        echo -e "\033[1;91mPlease change it manulay\033[0m"

        else
          echo -e "\033[1;92mDone\033[0m"
      checkStdPath "${standbyIp}"
        echo ""
fi


echo  ""
echo "******************************************************************************"
echo -e "\033[1;93mScript End: Check SSH connectivity \033[0m"
echo "******************************************************************************"
echo ""
