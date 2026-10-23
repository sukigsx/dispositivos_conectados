#!/bin/bash

#VARIABLES PRINCIPALES
# con export son las variables necesarias para exportar al los siguientes script
#variables para el menu_info

export NombreScript="DispositivosConectados"
export DescripcionDelScript="Herramienta de administración para verificar el estado de dispositivos en una red"
export Correo="scripts@mbbsistemas.es"
export Web="https://repositorio.mbbsistemas.es"
export version="1.0"
conexion="Sin comprobar"
software="Sin comprobar"
actualizado="Sin comprobar"
paqueteria="No detectada"

# VARIABLE QUE RECOJEN LAS RUTAS
ruta_ejecucion=$(dirname "$(readlink -f "$0")") #es la ruta de ejecucion del script sin la / al final
ruta_escritorio=$(xdg-user-dir DESKTOP) #es la ruta de tu escritorio sin la / al final

# VARIABLES PARA LA ACTUALIZAION CON GITHUB
NombreScriptActualizar="dispositivos_conectados.sh" #contiene el nombre del script para poder actualizar desde github
DireccionGithub="https://github.com/sukigsx/dispositivos_conectados.git" #contiene la direccion de github para actualizar el script
nombre_carpeta_repositorio="dispositivos_conectados" #poner el nombre de la carpeta cuando se clona el repo para poder eliminarla

# VARIABLES DE SOFTWARE NECESARIO
# Asociamos comandos con los paquetes correspondientes.
# Formato si cambian: [comando]="paquete_debian / paquete_redhat / paquete_arch"
# Formato si son iguales: [comando]="paquete_unico"
declare -A requeridos
requeridos=(
    # Requeridos para poder actualizar
        [git]="git/git/git"
        [diff]="diffutils/diffutils/diffutils"
        [sudo]="sudo/sudo/sudo"
        [ping]="iputils-ping/iputils/iputils/"
        [xdg-user-dir]="xdg-user-dirs/xdg-user-dirs/xdg-user-dirs"

    # Requeridos para el script en si
    #[fzf]="fzf"
    #[awk]="gawk/gawk/gawk"
)
###########################
## FUNCIONES PRINCIPALES ##
###########################
#colores
rojo="\e[0;31m\033[1m" #rojo
verde="\e[;32m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
rosa="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
borra_colores="\033[0m\e[0m" #borra colores

#toma el control al pulsar control + c
trap ctrl_c INT
function ctrl_c()
{
clear
echo ""
echo -e "${azul} GRACIAS POR UTILIZAR MI SCRIPT${borra_colores}"
echo ""
sleep 1
exit
}

menu_info(){
# muestra el menu de sukigsx
echo ""
echo -e "${rosa}            _    _                  ${azul}   Nombre del script${borra_colores} $NombreScript"
echo -e "${rosa}  ___ _   _| | _(_) __ _ _____  __  ${azul}   Descripcion${borra_colores} $DescripcionDelScript"
echo -e "${rosa} / __| | | | |/ / |/ _\ / __\ \/ /  ${azul}   Version            =${borra_colores} $version"
echo -e "${rosa} \__ \ |_| |   <| | (_| \__ \>  <   ${azul}   Conexion Internet  =${borra_colores} $conexion"
echo -e "${rosa} |___/\__,_|_|\_\_|\__, |___/_/\_\  ${azul}   Software necesario =${borra_colores} $software"
echo -e "${rosa}                  |___/             ${azul}   Actualizado        =${borra_colores} $actualizado"
echo -e "${rosa}                                    ${azul}   Sistema paqueteria =${borra_colores} $paqueteria"
echo -e ""
echo -e "${azul} Contacto:${borra_colores} ( Correo${rosa} $Correo${borra_colores} ) ( Web${rosa} $Web${borra_colores} )${borra_colores}"
echo ""
}

#comprobar si hay actualizaciones y que lo marque en el menu_info y tambien pregunta si quieres actualizar
comprobar_actualizaciones(){

    git clone $DireccionGithub /tmp/comprobar >/dev/null 2>&1
    diff $ruta_ejecucion/$NombreScriptActualizar /tmp/comprobar/$NombreScriptActualizar >/dev/null 2>&1

    if [ $? = 0 ]
    then
        #esta actualizado, solo lo comprueba
        actualizado="SI"
        chmod -R +w /tmp/comprobar
        rm -R /tmp/comprobar
    else
        #hay que actualizar, comprueba y actualiza
        echo ""
        echo -e "${amarillo} Existe una actualizacion del script${borra_colores}"
        read -p " Quieres actualizar ? (S/n): " sino
        if [[ $sino == [sS] ]]; then
            actualizar_script
        else
            actualizado="NO"
        fi
        chmod -R +w /tmp/comprobar
        rm -R /tmp/comprobar
    fi
}

#funcion para actualizar el script
actualizar_script(){
    git clone $DireccionGithub /tmp/comprobar >/dev/null 2>&1

    cp -r /tmp/comprobar/* $ruta_ejecucion
    chmod -R +w /tmp/comprobar
    rm -R /tmp/comprobar
    echo ""
    echo -e "${amarillo} Sera necesario ejecutarlo de nuevo.${borra_colores}"

    printf " Actualizando... "
    for i in {1..20}; do
        printf "#"
        sleep 0.1
    done
    printf " [ \e[32mOK\e[0m ]\n"

    echo ""
    sleep 1
    exit
}

# Funcion para comprobar el software necesario
software_necesario(){
    # Detectamos la paqueteria y establecemos el idx_distro antes de evaluar la matriz
    paqueteria

    echo ""
    echo -e "${azul} Comprobando el software necesario.${borra_colores}"
    echo ""

    for comando in "${!requeridos[@]}"; do
        # Evaluamos si el valor de la matriz contiene variantes por barra '/'
        if [[ "${requeridos[$comando]}" == *"/"* ]]; then
            paquete_real=$(echo "${requeridos[$comando]}" | cut -d'/' -f$idx_distro)
        else
            paquete_real="${requeridos[$comando]}"
        fi

        command -v "$comando" &>/dev/null
        sino=$?
        contador=1
        while [ $sino -ne 0 ]; do
            if [ $contador -ge 4 ] || [ "$conexion" = "no" ]; then
                clear
                menu_info
                echo -e " ${amarillo}NO se puede ejecutar el script sin los paquetes necesarios ${rojo}$paquete_real${amarillo}.${borra_colores}"
                echo -e " ${amarillo}NO se ha podido instalar ${rojo}$paquete_real${amarillo}.${borra_colores}"
                echo -e " ${amarillo}Inténtelo usted con: (${borra_colores}$instalar $paquete_real${amarillo})${borra_colores}"
                echo ""
                echo -e "${azul} Listado de los paquetes necesarios para poder ejecutar el script:${borra_colores}"

                # Listar los nombres traducidos de los paquetes para comodidad del usuario
                for cmd_lista in "${!requeridos[@]}"; do
                    if [[ "${requeridos[$cmd_lista]}" == *"/"* ]]; then
                        echo -e "     $(echo "${requeridos[$cmd_lista]}" | cut -d'/' -f$idx_distro)"
                    else
                        echo -e "     ${requeridos[$cmd_lista]}"
                    fi
                done

                echo ""
                echo -e " ${rojo}No se puede ejecutar el script sin todo el software necesario.${borra_colores}"
                echo ""
                exit 1
            else
                echo -e "${amarillo} Se necesita instalar ${borra_colores}$comando${amarillo} para la ejecucion del script${borra_colores}"
                echo " Instalando $paquete_real. Intento $contador/3."

                # Ejecución de la instalación silenciosa
                $instalar "$paquete_real" &>/dev/null

                let "contador=contador+1"
                command -v "$comando" &>/dev/null
                sino=$?
            fi
        done
        echo -e " [${verde}ok${borra_colores}] $comando ($paquete_real)."
    done

    echo ""
    echo -e "${azul} Todo el software ${verde}OK${borra_colores}"
    software="SI"
}

# Función que comprueba si se ejecuta como root
check_root() {
    #clear
    #menu_info
  if [ "$EUID" -ne 0 ]; then
    #echo ""
    #echo -e "${amarillo} Se necesita privilegios de root ingresa la contraseña.${borra_colores}"

    # Pedir contraseña para sudo
    #echo -e ""

    # Validar contraseña mediante sudo -v (verifica sin ejecutar comando)
    if sudo -v; then
      echo ""
      echo -e "${verde} Autenticación correcta. Ejecutando como root...${borra_colores}"; sleep 2
      # Reejecuta el script como root
      #exec sudo "$0" "$@"
    else
      clear
      menu_info
      echo -e "${rojo} Contraseña incorrecta o acceso denegado. Saliendo del script.${borra_colores}"
      echo ""
      echo -e "${azul} Listado de los paquetes necesarios para poder ejecutar el script:${borra_colores}"
      for elemento in "${requeridos[@]}"; do
        echo -e "     $elemento"
      done
      echo ""
      echo -e "${azul} GRACIAS POR UTILIZAR MI SCRIPT${borra_colores}"
     echo ""; exit
    fi
  fi
}

# Funcion de detectar sistema de paquetado para instalar
paqueteria(){
    echo ""
    echo -e "${azul} Detectando sistema de paquetería...${borra_colores}"
    echo ""

    if command -v apt >/dev/null 2>&1; then
        echo -e "${verde} Sistema de paquetería detectado: APT (Debian, Ubuntu, Mint, etc.)${borra_colores}"
        instalar="sudo apt install -y"
        paqueteria="apt"
        idx_distro=1

    elif command -v dnf >/dev/null 2>&1; then
        echo -e "${verde} Sistema de paquetería detectado: DNF (Fedora, RHEL, Rocky, AlmaLinux)${borra_colores}"
        instalar="sudo dnf install -y"
        paqueteria="dnf"
        idx_distro=2

    elif command -v pacman >/dev/null 2>&1; then
        echo -e "${verde} Sistema de paquetería detectado: PACMAN (Arch Linux, Manjaro)${borra_colores}"
        instalar="sudo pacman -S --noconfirm"
        paqueteria="pacman"
        idx_distro=3

    else
        echo -e "${rojo} Sistema de paquetería no soportado automáticamente.${borra_colores}"
        paqueteria="No detectada"
        exit 1
    fi
}


#comprobar si se ejecuta en una terminal bash
terminal_bash() {

    shell_actual="$(ps -p $$ -o comm=)"

    if [ "$shell_actual" != "bash" ]; then
        echo -e "${amarillo} Este script ${rojo}NO${amarillo} se está ejecutando en Bash.${borra_colores}"
        echo -e "   Shell detectado: ${rojo}$shell_actual${borra_colores}"
        echo -e "   Puede ocasionar problemas ya que solo está pensado para bash."
        echo -e "   ${rojo}No${borra_colores} se procede con la instalación ni la ejecución."
        echo ""
        echo -e "${azul} GRACIAS POR UTILIZAR MI SCRIPT${borra_colores}"
        echo ""
        exit 1
    fi
}

conexion(){
#funcion de comprobar conexion a internet
#para que funciones necesita:
#   conexion ainternet
#   la paleta de colores
#   software: ping

if ping -c1 -W1 8.8.8.8 &>/dev/null
then
    conexion="SI"
    echo ""
    echo -e " Conexion a internet = ${verde}SI${borra_colores}"
else
    conexion="NO"
    echo ""
    echo -e " Conexion a internet = ${rojo}NO${borra_colores}"
fi
}














#Funciones del script

#configurar el fichero de dispositivos
configurar(){
mkdir /home/$(whoami)/.config/dispositivos_conectados > /dev/null 2>&1
echo "declare -A equipos" >> /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config
vacio="si"
while true
do
    clear
    menu_info
    echo ""
    echo -e "${amarillo} - CONFIGURACION INICIAL -${borra_colores}"
    echo ""
    echo -e "${verde}- Listado de tus dispositivos actuales -${borra_colores}"

    if [[ "$vacio" == "si" ]]; then
        echo ""
        echo -e "${rojo} - NO EXISTE NINGUN DISPOSITOVO -${borra_colores}"
        echo ""
    else
        echo ""
        tail -n +2 /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config | awk -F'[][]=+' '{print "\033[32m" $3 "\033[0m =", "\033[32m" $2 "\033[0m"}' | column -t
        echo ""
        echo -e "${verde} - Listado finalizado -${borra_colores}"
        echo ""
    fi

    # Función para validar una dirección IP
    validate_ip() {
    local ip=$1
    local valid_ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

    if [[ $ip =~ $valid_ip_regex ]]; then
        ip_correpto="si"
    else
        echo -e "${amarillo} Error: Dirección IP no válida.${borra_colores}"
        ip_correpto="no"
    fi
    }

    # Función para validar un nombre sin caracteres especiales ni en blanco
    validate_name() {
    local name=$1
    local valid_name_regex="^[a-zA-Z0-9_]+$"

    if [[ $name =~ $valid_name_regex && ! -z $name ]]; then
        nombre_correpto="si"
    else
        echo -e "${amarillo} Error: Nombre no válido. Debe contener solo letras, números y guiones bajos, y no puede estar en blanco.${borra_colores}"
        nombre_correpto="no"
    fi
    }

    # Solicitar y validar la dirección IP
    echo -e "${azul} Introduce ( s para salir ), ( Ej. router 192.168.1.1 ).${borra_colores}"
    read -p " Dime un Nombre Dispositivo espacio y su dirección IP -> " name ip
    echo ""
    if  [ "$name" == "s" ]; then
        configurar="SI"
        break
    fi

    validate_ip "$ip"
    validate_name "$name"

    # Verifica si se debe salir del bucle

    # Agrega la entrada al archivo como un nuevo elemento del array
    if [[ "$ip_correpto" == "si" ]] && [[ "$nombre_correpto" == "si" ]]; then
        echo "equipos[$ip]=$name" >> /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config
        echo ""
        echo -e " Dispositivo ${azul}$name${borra_colores} con la ${azul}$ip${borra_colores} = ${verde}ok${borra_colores}."
        vacio="no"
        sleep 2
    else
        echo -e "${rojo} Datos de dispositivo incorreptos.${borra_colores}"
        echo ""
        read -p " Pulsa una tecla para continuar." p
    fi
done
}

#menu
menu(){
while :
do
clear
echo -e "${rosa}"; figlet -c sukigsx; echo -e "${borra_colores}"
echo ""
echo -e "${verde} Diseñado por sukigsx / Contacto:   scripts@mbbsistemas.es${borra_colores}"
echo -e "${verde}                                    https://repositorio.mbbsistemas.es${borra_colores}"
echo ""
echo -e "${verde} Nombre del script < $0 > Comprueba si los dispositivos estan activos.  ${borra_colores}"
echo ""
echo -e "${verde} Configurado =${borra_colores} $configurar${verde}. Conexion a internet =${borra_colores} $conexion${verde}. Software necesario =${borra_colores} $software${verde}. Script actualizado =${borra_colores} $actualizado."
echo ""
echo -e "     0. ${azul}Actualizar este script.${borra_colores}"
echo ""
echo -e "     1. ${azul}Incluir dispositivos${borra_colores}"
echo -e "     2. ${azul}Eliminar dispositivos.${borra_colores}"
echo -e "     3. ${azul}Editar el fichero de configuracion.${borra_colores}"
echo -e "     4. ${azul}Desistalar (${rojo}Se elimina completamente de tu sistema${azul}).${borra_colores}"
echo ""
echo -e "     5. ${azul}Escanear los dispositivos.${borra_colores}"
echo ""
echo -e "    90. ${azul}Ayuda.${borra_colores}"
echo -e "    99. ${azul}Salir.${borra_colores}"
echo ""
echo -n " Seleccione una opcion del menu --->>> "
read opcion
case $opcion in

        0)  #actualizar el script
            actualizar_script
            sleep 2
            ;;

        1)  #añadir dispositivos
            while true
            do
                clear
                echo -e "${rosa}"; figlet Incluir; echo -e "${borra_colores}"
                echo ""
                echo -e "${verde}- Listado de tus dispositivos actuales -${borra_colores}"
                echo ""
                tail -n +2 /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config | awk -F'[][]=+' '{print "\033[32m" $3 "\033[0m =", "\033[32m" $2 "\033[0m"}' | column -t
                echo ""
                echo -e "${verde} - Listado finalizado -${borra_colores}"
                echo ""
                # Pide la dirección IP

                # Función para validar una dirección IP
                validate_ip() {
                local ip=$1
                local valid_ip_regex="^([0-9]{1,3}\.){3}[0-9]{1,3}$"

                if [[ $ip =~ $valid_ip_regex ]]; then
                    ip_correpto="si"
                else
                    echo -e "${amarillo} Error: Dirección IP no válida.${borra_colores}"
                    ip_correpto="no"
                fi
                }

                # Función para validar un nombre sin caracteres especiales ni en blanco
                validate_name() {
                local name=$1
                local valid_name_regex="^[a-zA-Z0-9_]+$"

                if [[ $name =~ $valid_name_regex && ! -z $name ]]; then
                    nombre_correpto="si"
                else
                    echo -e "${amarillo} Error: Nombre no válido. Debe contener solo letras, números y guiones bajos, y no puede estar en blanco.${borra_colores}"
                    nombre_correpto="no"
                fi
                }

                # Solicitar y validar la dirección IP
                echo -e "${azul} Introduce ( s para salir ), ( Ej. router 192.168.1.1 ).${borra_colores}"
                read -p " Dime un Nombre Dispositivo espacio y su dirección IP -> " name ip
                echo ""
                if  [ "$name" == "s" ]; then
                    configurar="SI"
                    break
                fi

                validate_ip "$ip"
                validate_name "$name"

                # Verifica si se debe salir del bucle


                # Agrega la entrada al archivo como un nuevo elemento del array
                if [[ "$ip_correpto" == "si" ]] && [[ "$nombre_correpto" == "si" ]]; then
                    echo "equipos[$ip]=$name" >> /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config
                    echo ""
                    echo -e " Dispositivo ${azul}$name${borra_colores} con la ${azul}$ip${borra_colores} = ${verde}ok${borra_colores}."
                    sleep 2
                else
                    echo -e "${rojo} Datos de dispositivo incorreptos.${borra_colores}"
                    echo ""
                    read -p " Pulsa una tecla para continuar." p
                fi
            done
            ;;

        2)  #borrar dispositivos
            while true
            do
                clear
                menu_info
                echo -e "${verde}- Listado de tus dispositivos actuales -${borra_colores}"
                echo ""
                tail -n +2 /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config | awk -F'[][]=+' '{print "\033[32m" $3 "\033[0m =", "\033[32m" $2 "\033[0m"}' | column -t
                echo ""
                echo -e "${verde} - Listado finalizado -${borra_colores}"
                echo ""
                # Pide la dirección IP
                echo -e " Para borrar varios separar con espacio. ( s = salir )"
                read -p " Introduce dispositivo -> " dispositivo

                # Verifica si se debe salir del bucle
                if  [ "$dispositivo" == "s" ]; then
                    configurar="SI"
                    break
                fi


                for borrar in $dispositivo
                do
                    sed -i "/$borrar/d" /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config
                    echo -e " Dispositivo ${azul}$borrar${borra_colores} borrado = ${verde}ok${borra_colores}."
                done
                sleep 4
            done
            ;;

        3)  #editar fichero de configuracion
            sleep 1
            nano /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config
            ;;

        4)  #Desistalar (Se elimina completamente de tu sistema)
            clear
            menu_info
            read -p "¿ Seguro que deseas eliminar ? (s/n) -> " sn
            echo -e "${borra_colores}"
            if [ $sn = "s" ] >/dev/null 2>&1; then
                rm /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config
                descarga=$(dirname "$(readlink -f "$0")")
                rm $descarga/$0
                echo -e " Fichero configuracion, ${verde}ELIMINADO${borra_colores}"
                echo -e " Script ${azul}$0${borra_colores}, ${verde}ELIMINADO${borra_colores}"
                echo ""
                echo -e "${verde} Desistalacion correcta${borra_colores}"
                echo ""
                exit
            else
                echo -e "${verde} OK, No se borra nada.${borra_colores}"; sleep 2
                echo ""
            fi
            ;;

        5)  #escanear
            clear
            menu_info
            archivo="/home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config"
            if [ -f "$archivo" ] && grep -q "\[" "$archivo"; then
                echo ""
                echo -e "${azul} Comprobando dispositivos en tu red.${borra_colores}\n"
                source /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config
                for resultado in "${!equipos[@]}";
                do
                    ping -w 1 $resultado 1>/dev/null 2>/dev/null
                    if [ $? = "0" ]
                    then
                        printf "${azul} IP${amarillo} $resultado ${verde}ENCENDIDA${borra_colores} del equipo ${amarillo}${equipos[$resultado]}\n"
                    else
                        printf "${azul} IP${amarillo} $resultado ${rojo}APAGADA  ${borra_colores} del equipo ${amarillo}${equipos[$resultado]}\n"
                    fi
                done
                echo ""
                printf "${azul} Escaneo Terminado. Pulsa una tecla para continuar.${borra_colores}\n"
                echo "----------------------------------------------------"
                read -p " Pulsa una tecla para continuar." p
            else
                rm $archivo
                configurar="NO"
                configurar
            fi
            ;;

        90) #opcion 3
            clear
            echo ""
            echo '# DISPOSITIVOS_CONECTADOS

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
En resumen, el script es una herramienta interactiva para administrar una lista de dispositivos en una red, permitiendo agregar, eliminar, editar y escanear dispositivos, así como realizar otras acciones de administración.'
echo ""
read -p  " Pulsa una tecla para continuar" p
            ;;

        99) #salir
            ctrl_c
            ;;


        *)      #se activa cuando se introduce una opcion no controlada del menu
                echo "";
                echo -e " ${amarillo}OPCION NO DISPONIBLE EN EL MENU.    Seleccion 0, 1, 2, 3, 4, 5, 90 o 99 ${borra_colores}";
                echo -e " ${amarillo}PRESIONA ENTER PARA CONTINUAR ........${borra_colores}";
                echo "";
                read pause;;

esac
done
}

# EMPIEZA LO GORDO
#clear
#echo ""
#conexion
#echo ""
#if [ $conexion = "SI" ]
#then
#    #si hay internet
#    software_necesario
#    actualizar_script
#else
#    #no hay internet
#    software_necesario
#fi
#sleep 2
#archivo="/home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config"
#if [ -f "$archivo" ] && grep -q "\[" "$archivo"; then
#    configurar="SI"
#else
#    rm $archivo
#    configurar="NO"
#    configurar
#fi
#
#if [ "$1" = "-m" ]
#then
#    menu
#fi



#logica de inicio
clear
menu_info
conexion
if [ $conexion = "SI" ]; then
    comprobar_actualizaciones
    if [ $actualizado = "SI" ]; then
        terminal_bash
        software_necesario
        if [ "$software" = "SI" ]; then
            export software="SI"
            export conexion="SI"
            export actualizado="SI"
            #bash $ruta_ejecucion/ #PON LA RUTA
        else
            echo ""
        fi
    else
        terminal_bash
        software_necesario
        if [ $software = "SI" ]; then
            export software="SI"
            export conexion="SI"
            export actualizado="NOOOOO"
            #bash $ruta_ejecucion/ #PON LA RUTA
        else
            echo ""
        fi
    fi
else
    software_necesario
    if [ $software = "SI" ]; then
        export software="SI"
        export conexion="NO"
        export actualizado="No se ha podido comprobar la actualizacion del script"
        #bash $ruta_ejecucion/ #PON LA RUTA
    else
        echo ""
    fi
fi

#comprueba si esta configurado
archivo="/home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config"
if [ -f "$archivo" ] && grep -q "\[" "$archivo"; then
    configurar="SI"
else
    rm $archivo
    configurar="NO"
    configurar
fi

sleep 2
clear
menu_info

#escanea directo
echo ""
echo -e "${azul} Comprobando dispositivos en tu red.${borra_colores}\n"
source /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config
for resultado in "${!equipos[@]}";
do
    ping -w 1 $resultado 1>/dev/null 2>/dev/null
    if [ $? = "0" ]
    then
        printf "${azul} IP${amarillo} $resultado ${verde}ENCENDIDA${borra_colores} del equipo ${amarillo}${equipos[$resultado]}\n"
    else
        printf "${azul} IP${amarillo} $resultado ${rojo}APAGADA  ${borra_colores} del equipo ${amarillo}${equipos[$resultado]}\n"
    fi
done
echo ""
printf "${azul} Escaneo Terminado. Pulsa una tecla para continuar.${borra_colores}\n"
echo "----------------------------------------------------"
echo ""
read -p " Quieres entrar al menu? (s/n) -> " sn
if [ $sn = "s" ]
then
    menu
fi
echo ""
