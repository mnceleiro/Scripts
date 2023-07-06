

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

URL_AV="edu.xunta.gal/centros/iescosmelopez/aulavirtual"
URL_AV_LOGIN=$URL_AV/login
DESKTOP_ENTRY="[Desktop Entry]
Name=Navegador web
GenericName=Navegador web
X-GNOME-FullName=SeaMonkey
Comment=Navegador web
Exec=/opt/seamonkey/seamonkey -url %s
Icon=/opt/seamonkey/chrome/icons/default/default64.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
"

DESKTOP_FILE_MAIN='/usr/share/applications/seamonkey.desktop'
DESKTOP_FILE_BOOT='/etc/xdg/autostart/seamonkey.desktop'

# Elimino os ficheiros de configuracion do seamonkey no escritorio (se os hai)
[ -e $DESKTOP_FILE_MAIN ] && rm $DESKTOP_FILE_MAIN
[ -e $DESKTOP_FILE_BOOT ] && rm $DESKTOP_FILE_BOOT

# Engado seamonkey ao inicio e fago que se execute no arranque do sistema
printf "$DESKTOP_ENTRY" $URL_AV > $DESKTOP_FILE_MAIN
printf "$DESKTOP_ENTRY" $URL_AV_LOGIN > $DESKTOP_FILE_BOOT

echo "4. Establecendo usuarios e permisos correctos para o navegador..."
chown -R usuario:usuario /opt/seamonkey
chmod -R 755 /opt/seamonkey

#cp /usr/share/applications/seamonkey.desktop /etc/xdg/autostart

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

This paste expires in <1 hour. Public IP access. Share whatever you see with others in seconds with Context. Terms of ServiceReport this
