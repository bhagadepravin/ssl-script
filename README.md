## Setup Internal CA Certificates

```bash
yum install git -y
git clone https://github.com/bhagadepravin/ssl-script.git
cd ssl-script
bash create_root.sh
bash create_intermediate.sh intermediate
bash create_server.sh `hostname -f`
./export.sh -i intermediate -c `hostname -f` -d /home -k
```

### Update SAN Entries in intermediate.openssl.cnf
```
By default we have 
subjectAltName=DNS:*.acceldata.dev, DNS:.centos7.adsre, DNS:*.adsre.com
```
