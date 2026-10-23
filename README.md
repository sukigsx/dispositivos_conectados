# DISPOSITIVOS_CONECTADOS

Este script en bash es una herramienta de administración para verificar el estado de dispositivos en una red.

## Opciones del Menú:

- Opción 0: Actualizar el Script
Llama a la función actualizar_script que probablemente se define en algún lugar del script.

- Opción 1: Incluir Dispositivos
Muestra una lista de dispositivos actuales.
Solicita al usuario ingresar el nombre y la dirección IP de un dispositivo.
Verifica la validez de la dirección IP y el nombre.
Agrega la entrada al archivo de configuración si la información es válida.

- Opción 2: Eliminar Dispositivos
Muestra una lista de dispositivos actuales.
Solicita al usuario ingresar el nombre del dispositivo a eliminar (puede ser múltiple).
Elimina las entradas correspondientes del archivo de configuración.

- Opción 3: Editar el Fichero de Configuración
Abre el editor nano para editar el archivo de configuración.

- Opción 4: Desinstalar
Pregunta al usuario si está seguro de desinstalar.
Elimina el archivo de configuración y el propio script si el usuario confirma.

- Opción 5: Escanear Dispositivos
Comprueba la existencia de un archivo de configuración.
Realiza un escaneo de dispositivos en la red utilizando el comando ping.
Muestra el estado de cada dispositivo (encendido o apagado).

- Opción 90: Ayuda
No hay detalles sobre lo que hace esta opción en el script proporcionado.

- Opción 99: Salir
Llama a la función ctrl_c y sale del script.

## Instalacion

Clonar repositorio con el siguiente comando:
```
git clone https://github.com/sukigsx/dispositivos_conectados.git
```
Descarga directa con WGET
```
wget -O dispositivos_conectados.sh https://raw.githubusercontent.com/sukigsx/dispositivos_conectados/refs/heads/main/dispositivos_conectados.sh && chmod +x dispositivos_conectados.sh
```
Tambien puedes utilizar mi script (ejecutar_escripts), en el cual puedes instalar todos mis script del repositorio.
```
git clone https://github.com/sukigsx/ejecutar_scripts.git
```
