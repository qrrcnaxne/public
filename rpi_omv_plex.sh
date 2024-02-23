apt update 
apt upgrade -y
wget -O - https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/installScript/master/install | bash
apt install apt-transport-https
rm -f PlexSign.key
wget https://downloads.plex.tv/plex-keys/PlexSign.key
key_type=$(file PlexSign.key)
if [[ $key_type != 'PlexSign.key: PGP public key block Public-Key (old)' ]]; then
   echo "Key type is not correct"
   exit 1
fi
md5=$(md5sum PlexSign.key | awk '{print $1}')
if [[ $md5 != '19930ce0357f723e590210e3101321a3' ]]; then
    echo "MD5 is not correct"
    exit 1
fi
mkdir -p /etc/apt/keyrings
mv PlexSign.key /etc/apt/keyrings
echo "deb [signed-by=/etc/apt/keyrings/PlexSign.key] https://downloads.plex.tv/repo/deb public main" > /etc/apt/sources.list.d/plexmediaserver.list
apt update
apt install plexmediaserver -y
