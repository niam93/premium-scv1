#!/bin/bash
# Color Validation
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
CYAN='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
CYAN='\e[36m'
LIGHT='\033[0;37m'
MYIP=$(curl -s https://icanhazip.com);
echo "Checking VPS"
cek=$( curl -sS https://raw.githubusercontent.com/vpnlegasi/client-ip/main/access | awk '{print $2}'  | grep $MYIP )
if [ $cek = $MYIP ]; then
echo -e "${green}Permission Accepted...${NC}"
else
echo -e "${red}Permission Denied!${NC}";
echo "Your IP NOT REGISTER / EXPIRED | Contact me at Telegram @vpnlegasi to Unlock"
exit 0
fi
clear

clear
#Open HTTP Puncher By VPN Legasi
#Direct Proxy Squid For OpenVPN TCP

RED='\e[1;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m'
MYIP=$(wget -qO- https://icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
sqd1="$(cat ~/log-install.txt | grep -w "OHP" | cut -d: -f2)"

#Update Repository VPS
clear
apt update 
apt-get -y upgrade

#Port Server
#Jika Ingiin Mengubah Port Silahkan Sesuaikan Dengan Port Yang Ada Di VPS Mu
Port_OpenVPN_TCP='1194';
Port_Squid='3128';
Port_OHP='8181';

#Installing ohp Server
cd 
wget -O /usr/local/bin/ohp "https://raw.githubusercontent.com/vpnlegasi/script/main/ohp"
chmod +x /usr/local/bin/ohp

#Buat File OpenVPN TCP OHP
cat > /etc/openvpn/tcp-ohp.ovpn <<END
setenv FRIENDLY_NAME "OHP VPN LEGASI"
setenv CLIENT_CERT 0
client
dev tun
proto tcp
remote "bug.com" 465
http-proxy-retry 
http-proxy xxxxxxxxx 8000
http-proxy-option CUSTOM-HEADER "X-Forwarded-Host bug.com"
resolv-retry infinite
route-method exe
nobind
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/tcp-ohp.ovpn;

# masukkan certificatenya ke dalam config client TCP OHP 1194
echo '<ca>' >> /etc/openvpn/tcp-ohp.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/tcp-ohp.ovpn
echo '</ca>' >> /etc/openvpn/tcp-ohp.ovpn
cp /etc/openvpn/tcp-ohp.ovpn /home/vps/public_html/tcp-ohp.ovpn
clear
cd 

#Buat Service Untuk OHP
cat > /etc/systemd/system/ohp.service <<END
[Unit]
Description=Direct Squid Proxy For OpenVPN TCP By VPN Legasi
Documentation=https://vpnlegasi.my
Documentation=https://t.me/vpnlegasi
Wants=network.target
After=network.target

[Service]
ExecStart=/usr/local/bin/ohp -port 8181 -proxy 127.0.0.1:8000 -tunnel 127.0.0.1:1194
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ohp
systemctl restart ohp
echo ""
echo -e "${GREEN}Done Installing OHP Server${NC}"
echo -e "Port OVPN OHP TCP: 8181"
echo -e "Link Download OVPN OHP: http://$MYIP/tcp-ohp.ovpn"
echo -e "Script By VPN Legasi"
