# podz_man
RHEL podman quadlet configs

## Prepare host system

### Unprivileged port range
```
sudo echo net.ipv4.ip_unprivileged_port_start = 80 | sudo tee /etc/sysctl.d/90-unprivileged_port_start.conf                                                                                                
sudo sysctl --system     
```
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
`Linger=yes`

#### If different location
`export XDG_CONFIG_HOME=/home/wcrusher/podz_man`


## Podz, man

`printf "souper-secret" | podman secret create your_secret_variable -`


### SystemD

``` Common commands
systemctl --user daemon-reload
systemctl --user reset-failed 
```