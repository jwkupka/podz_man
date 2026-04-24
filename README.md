# podz_man
RHEL podman quadlet configs

## Prepare host system

### Unprivileged port range
Down to 25 for mail
```
sudo echo net.ipv4.ip_unprivileged_port_start = 80 | sudo tee /etc/sysctl.d/90-unprivileged_port_start.conf                                                                                                
sudo sysctl --system     
```
### firewall
`sudo firewall-cmd --add-service={http,http3,https} --permanent`

`sudo firewall-cmd --add-port=8080/tcp` # Temporary for Stalwart initial config

#### Insecure mail ports
`sudo firewall-cmd --add-service={smtp,imap,pop3} --permanent`

#### Secure mail ports
`sudo firewall-cmd --add-service={smtp,smtp-submission,imaps,pop3s} --add-port=4190/tcp --permanent `

#### Minimal
`sudo firewall-cmd --add-service={smtp,smtp-submission,imaps} --permanent`

#### Sieve thingy
`sudo firewall-cmd --add-service={smtp,smtp-submission,imaps,pop3s} --add-port=4190/tcp --permanent `


### Account to run podz
```                                                                         
sudo useradd --create-home podz_man                                                                 
sudo machinectl shell --uid=podz_man   
```

## Source configure

### deploy keys

`ssh-keygen -t ed25519 -C "podz deploy man"`

`cat .ssh/id_ed25519.pub`

Put that in [Deploy keys](https://github.com/jwkupka/podz_man/settings/keys)

```
sudo apt install git                        
```

```
git init
git remote add origin git@github.com:jwkupka/podz_man.git
git fetch
git reset --hard origin/main
```

``` Or ...
git clone git@github.com:jwkupka/podz_man.git
```

``` Enable linger
loginctl enable-linger $USER
loginctl show-user $USER --property=Linger
```

#### If different location
I haven't tested this
`export XDG_CONFIG_HOME=/home/wcrusher/podz_man`

## Podz, man

### Use podman secrets, it's easy
`printf "souper-secret" | podman secret create your_secret_variable -`

### SystemD

``` Common commands
systemctl --user daemon-reload
systemctl --user reset-failed 
```

## Other notes

### Stalwart

Run through the config with no TLS/DKIM/DNS, especially if using subdomain or anything else. The full config UI has way more options to accomodate less 'standard' scenarios.

Proxy Protocol. It's important if you're using a reverse proxy, like caddy.

### LetsEncrypt
Please use [staging](https://acme-staging-v02.api.letsencrypt.org/directory) to save your sanity
