#!/bin/bash

# Crear el script saludo.sh
echo "Creando el script saludo.sh..."
cat <<EOL > /usr/local/bin/saludo.sh
#!/bin/bash
while true; do
  echo "¡Hola! La fecha actual es: \$(date)"
  sleep 1
done
EOL

# Dar permisos de ejecución al script
echo "Dando permisos de ejecución al script..."
chmod +x /usr/local/bin/saludo.sh

# Crear el archivo de servicio systemd
echo "Creando el archivo de servicio systemd..."
cat <<EOL > /etc/systemd/system/saludo.service
[Unit]
Description=Servicio que imprime un saludo y la fecha actual cada segundo

[Service]
ExecStart=/usr/local/bin/saludo.sh
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOL

# Recargar el daemon de systemd
echo "Recargando systemd daemon..."
systemctl daemon-reload

# Habilitar el servicio para que inicie automáticamente con el sistema
echo "Habilitando el servicio para inicio automático..."
systemctl enable saludo.service

# Iniciar el servicio manualmente
echo "Iniciando el servicio..."
systemctl start saludo.service

# Mostrar el estado del servicio
echo "Estado del servicio:"
systemctl status saludo.service

# Mostrar logs del servicio
echo "Mostrando logs del servicio:"
journalctl -u saludo.service -f

# Guarda el script en un archivo llamado setup_saludo_service.sh en tu máquina:
sudo nano setup_saludo_service.sh

# Dale permisos de ejecución al script:
sudo chmod +x setup_saludo_service.sh

# Ejecuta el script:
sudo ./setup_saludo_service.sh


