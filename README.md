# SSH-public-private-keys-authentication-between-primary-and-standby-or-remote-servers
This Script can do the automate setup of ssh-public/private-key authentication automatically for password-less between the primary and standby or remote servers for root and any users

## Why Should You Set Up SSH Keys?
You can connect to your application using the username and password, which is the traditional and commonly used method. 
Alternatively, you can also connect to your application using the SSH keys, also known as Password-less SSH.
SSH key pairs offer a more secure way of logging into your server than a password that can easily be cracked with a dictionary and brute force attacks. 
SSH keys are very hard to decipher with these attacks.

## Usage

```bash
git clone https://github.com/Khamis-AlMamari/SSH-public-private-keys-authentication-between-primary-and-standby-or-remote-servers
cd SSH-public-private-keys-authentication-between-primary-and-standby-or-remote-servers
chmod +x ssh_authentication.sh 
./ssh_authentication.sh 
```
You need to run the script by the root user

It will prompt you to enter the remote server root password, just write it. 



## Enjoy
Now you should be able to connect to the remote server via ssh without a password. 
Try ssh between the remote server ands check SSH connectivity
```bash
ssh remoteServerIP 
```

## Notes
In my example-code I have used oracle user and dba group.

You can modify them according to your server requirements 


## Authors

- [@Khamis Al Mamari](https://www.linkedin.com/in/khamis-almamari-7092a3215/)
