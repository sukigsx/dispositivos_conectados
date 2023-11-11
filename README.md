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

## FUNCIONAMIENTO DEL SCRIPT

- Inicio del Script
El script comienza con mensajes de bienvenida y una presentación del diseñador y contactos.

- Configuración Inicial
Muestra la configuración actual del script, incluyendo la configuración, la conexión a internet, el software necesario y si el script está actualizado.

- Mensajes y Colores
Utiliza comandos echo -e para imprimir mensajes en color.
Se utilizan variables como $verde, $rojo, $azul, etc., para definir códigos de color.

- Finalización del Script:
Si el usuario selecciona una opción no válida, muestra un mensaje de error y espera a que el usuario presione Enter.


### Funciones dentro del script
Hay funciones como validate_ip y validate_name que validan la entrada del usuario para direcciones IP y nombres respectivamente.

- Función ctrl_c
Esta función se ejecuta cuando se presiona Ctrl+C. Limpia la pantalla, muestra un mensaje de despedida y cierra el script.

- Función software_necesario
Comprueba la existencia de software necesario para la ejecución del script, como ping, figlet, git, y diff. Si no encuentra algún programa, intenta instalarlo hasta tres veces. Si no puede instalarlo después de tres intentos, muestra un mensaje de error y sale del script.

- Función conexion
Realiza una prueba de conectividad a Internet mediante un ping a google.com. Si la conexión es exitosa, establece la variable conexion a "SI", de lo contrario, a "NO".

- Función actualizar_script
Compara la versión local del script con la del repositorio en GitHub. Si hay diferencias, actualiza el script y muestra un mensaje indicando si se realizó la actualización correctamente.

- Función configurar
Crea un directorio y un archivo de configuración para almacenar información sobre dispositivos conectados. Solicita al usuario que introduzca nombres y direcciones IP para los dispositivos y los guarda en el archivo de configuración.

- Función validate_ip
Valida si una dirección IP tiene el formato correcto.

- Función validate_name
Valida si un nombre cumple con ciertos criterios.

- Función menu
Muestra un menú interactivo con diversas opciones, como actualizar el script, incluir o eliminar dispositivos, editar el archivo de configuración, desinstalar el script, escanear dispositivos, y mostrar ayuda.

### Sección principal
Realiza las siguientes acciones:

- Comprueba la conexión a Internet.
Si hay conexión, verifica el software necesario y actualiza el script.
Comprueba la existencia del archivo de configuración de dispositivos.
Si no existe, inicia el proceso de configuración.
Si se proporciona el argumento -m al ejecutar el script, se muestra el menú principal.

- Escaneo de dispositivos
Realiza un escaneo de los dispositivos definidos en el archivo de configuración, mostrando si están encendidos o apagados según su respuesta al comando de ping.

## En resumen
En resumen, el script es una herramienta interactiva para administrar una lista de dispositivos en una red, permitiendo agregar, eliminar, editar y escanear dispositivos, así como realizar otras acciones de administración.

## Instalacion

Clonar repositorio con el siguiente comando git clone https://github.com/sukigsx/dispositivos_conectados.git

# ESPERO OS GUSTE......
