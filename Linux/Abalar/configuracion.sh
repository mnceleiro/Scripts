#!/bin/bash

## Este script está preparado para a versión lixeira (LXDE) do sistema operativo Abalar 11. Fai o seguinte:
# - Instala SeaMonkey e engadeo ao menu de inicio do sistema.
# - Arranca automaticamente SeaMonkey no boot e inicia coa URL da aula virtual
# - Arranca a wifi co inicio da sesion de LXDE

# TODO: preguntar o nome de usuario

# Instalacion de SeaMonkey (navegador web sinxelo)
echo "1. Descargando o navegador web Seamonkey..."
wget https://archive.mozilla.org/pub/seamonkey/releases/2.53.16/linux-i686/es-ES/seamonkey-2.53.16.es-ES.linux-i686.tar.bz2 > /dev/null

echo "2. Copiando Seamonkey en /opt..."
tar -jxvf seamonkey-2.53.16.es-ES.linux-i686.tar.bz2 -C /opt/ > /dev/null
rm seamonkey-2.53.16.es-ES.linux-i686.tar.bz2

echo "3. Engadindo Seamonkey ao escritorio LXDE do usuario..."
echo "
[Desktop Entry]
Name=Navegador web
GenericName=Navegador web
X-GNOME-FullName=SeaMonkey
Comment=Navegador web
Exec=/opt/seamonkey/seamonkey -url http://www.edu.xunta.gal/centros/iescosmelopez/aulavirtual/login/
Icon=/opt/seamonkey/chrome/icons/default/default64.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
" > /usr/share/applications/seamonkey.desktop

echo "4. Establecendo usuarios e permisos correctos para o navegador..."
chown -R usuario:usuario /opt/seamonkey
chmod -R 755 /opt/seamonkey

cp /usr/share/applications/seamonkey.desktop /etc/xdg/autostart

echo "5. Activando o arranque da wifi por defecto para o usuario na sesion..."
# Activamos a wifi no arranque de la sesion
grep -q "nmcli" /home/usuario/.config/lxsession/LXDE/autostart
if [ $? -eq 1 ] # Si no encuentra el comando de nmcli lo anhadimos
then
 echo "nmcli radio wifi on" >> /home/usuario/.config/lxsession/LXDE/autostart
fi

echo "6. Finalizadas tarefas: instalación de Seamonkey, arranque na aula virtual e activación da Wifi co arranque."

: '
# Activamos la wifi en el arranque
echo "
#!/bin/bash
nmcli radio wifi on

" > /root/startup-script.sh
# chown usuario:usuario /home/usuario/.config/autostart/startup-script.sh
#update-rc.d startup-script.sh defaults 

echo "[Unit]
Description=Startup Script
 
[Service]
ExecStart=/bin/bash /root/startup-script.sh
 
[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/startup-script.service
chmod 755 /etc/systemd/system/startup-script.service

systemctl enable startup-script.service
systemctl daemon-reload
systemctl start startup-script.service
'
