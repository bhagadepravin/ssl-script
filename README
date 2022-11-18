## Setup Internal CA Certificates
```bash
yum install git -y
git clone https://github.com/bhagadepravin/ssl-script.git
bash create_root.sh
bash create_intermediate.sh intermediate
bash create_server.sh intermediate `hostname -f`
./export.sh -i intermediate -c `hostname -f` -d /home -k
```
