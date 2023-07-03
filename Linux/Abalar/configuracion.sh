#!/bin/bash

## Este script:
# - Instala SeaMonkey e engadeo ao menu de inicio do sistema.
# - Arranca automaticamente SeaMonkey no boot

# TODO: preguntar o nome de usuario

# Instalacion de SeaMonkey (navegador web sinxelo)
wget https://archive.mozilla.org/pub/seamonkey/releases/2.53.16/linux-i686/es-ES/seamonkey-2.53.16.es-ES.linux-i686.tar.bz2
tar -jxvf seamonkey-2.53.16.es-ES.linux-i686.tar.bz2 -C /opt/
rm seamonkey-2.53.16.es-ES.linux-i686.tar.bz2

echo "
[Desktop Entry]
Name=Navegador web
GenericName=Navegador web
X-GNOME-FullName=SeaMonkey
Comment=Navegador web
Exec=/opt/seamonkey/seamonkey
Icon=/opt/seamonkey/chrome/icons/default/default64.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
" > /usr/share/applications/seamonkey.desktop

chown -R usuario:usuario /opt/seamonkey
chmod -R 755 /opt/seamonkey
echo "Añadido SeaMonkey como navegador web."
cp /usr/share/applications/seamonkey.desktop /etc/xdg/autostart

# Activamos la wifi en el arranque
echo "
#!/bin/bash
nmcli radio wifi on

" > /home/usuario/.config/autostart/startup-script.sh
chown usuario:usuario /home/usuario/.config/autostart/startup-script.sh
: '
echo "
[Unit]
Description=Custom Startup Script
 
[Service]
ExecStart=bash /root/StartServices.sh
 
[Install]
WantedBy=default.target
" > /etc/systemd/system/StartServices.service
chmod 644 /etc/systemd/system/StartServices.service

systemctl enable StartServices.service
'
