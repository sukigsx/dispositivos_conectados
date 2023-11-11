#!/bin/bash

#colores
#ejemplo: echo -e "${verde} La opcion (-e) es para que pille el color.${borra_colores}"

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
figlet -c Gracias por
figlet -c utilizar mi
figlet -c script
wmctrl -r :ACTIVE: -b remove,maximized_vert,maximized_horz
exit
}

software_necesario(){
echo ""
echo -e " Comprobando el software necesario."
echo ""
software="ping figlet git diff" #ponemos el foftware a instalar separado por espacion dentro de las comillas ( soft1 soft2 soft3 etc )
for paquete in $software
do
which $paquete 2>/dev/null 1>/dev/null 0>/dev/null #comprueba si esta el programa llamado programa
sino=$? #recojemos el 0 o 1 del resultado de which
contador="1" #ponemos la variable contador a 1
    while [ $sino -gt 0 ] #entra en el bicle si variable programa es 0, no lo ha encontrado which
    do
        if [ $contador = "4" ] || [ $conexion = "no" ] 2>/dev/null 1>/dev/null 0>/dev/null #si el contador es 4 entre en then y sino en else
        then #si entra en then es porque el contador es igual a 4 y no ha podido instalar o no hay conexion a internet
            clear
            echo ""
            echo -e " ${amarillo}NO se ha podido instalar ${rojo}$paquete${amarillo}.${borra_colores}"
            echo -e " ${amarillo}Intentelo usted con la orden: (${borra_colores}sudo apt install $paquete ${amarillo})${borra_colores}"
            echo -e ""
            echo -e " ${rojo}No se puede ejecutar el script sin el software necesario.${borra_colores}"
            echo ""; read p
            echo ""
            exit
        else #intenta instalar
            echo " Instalando $paquete. Intento $contador/3."
            sudo apt install $paquete -y 2>/dev/null 1>/dev/null 0>/dev/null
            let "contador=contador+1" #incrementa la variable contador en 1
            which $paquete 2>/dev/null 1>/dev/null 0>/dev/null #comprueba si esta el programa en tu sistema
            sino=$? ##recojemos el 0 o 1 del resultado de which
        fi
    done
echo -e " [${verde}ok${borra_colores}] $paquete."
software="SI"
done
}

conexion(){
if ping -c1 google.com &>/dev/null
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

actualizar_script(){
archivo_local="dispositivos_conectados.sh" # Nombre del archivo local
ruta_repositorio="https://github.com/sukigsx/dispositivos_conectados.git" #ruta del repositorio para actualizar y clonar con git clone

# Obtener la ruta del script
descarga=$(dirname "$(readlink -f "$0")")
git clone $ruta_repositorio /tmp/comprobar >/dev/null 2>&1

diff $descarga/$archivo_local /tmp/comprobar/$archivo_local >/dev/null 2>&1


if [ $? = 0 ]
then
    #esta actualizado, solo lo comprueba
    echo ""
    echo -e "${verde} El script${borra_colores} $0 ${verde}esta actualizado.${borra_colores}"
    echo ""
    chmod -R +w /tmp/comprobar
    rm -R /tmp/comprobar
    actualizado="SI"
else
    #hay que actualizar, comprueba y actualiza
    echo ""
    echo -e "${amarillo} EL script${borra_colores} $0 ${amarillo}NO esta actualizado.${borra_colores}"
    echo -e "${verde} Se procede a su actualizacion automatica.${borra_colores}"
    sleep 3
    mv /tmp/comprobar/$archivo_local $descarga
    chmod -R +w /tmp/comprobar
    rm -R /tmp/comprobar
    echo ""
    echo -e "${amarillo} El script se ha actualizado, es necesario cargarlo de nuevo.${borra_colores}"
    echo -e ""
    read -p " Pulsa una tecla para continuar." pause
    exit
fi
}

#configurar el fichero de dispositivos
configurar(){
mkdir /home/$(whoami)/.config/dispositivos_conectados > /dev/null 2>&1
echo "declare -A equipos" >> /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config
vacio="si"
while true
do
    clear
    echo -e "${rosa}"; figlet sukigsx; echo -e "${borra_colores}"
    echo ""
    echo -e "${verde} Diseñado por sukigsx / Contacto:   scripts@mbbsistemas.es${borra_colores}"
    echo -e "${verde}                                    https://repositorio.mbbsistemas.es${borra_colores}"
    echo ""
    echo -e "${verde} Nombre del script < $0 > Comprueba si los dispositivos estan activos.  ${borra_colores}"
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
        tail -n +2 /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config | awk -F'[[\]=]+' '{print "\033[32m" $3 "\033[0m =", "\033[32m" $2 "\033[0m"}' | column -t; echo ""
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
    echo -e "${azul} Introduce ( s para salir ), ( Ej. 192.168.1.1 router ).${borra_colores}"
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
            sleep 3
            ;;

        1)  #añadir dispositivos
            while true
            do
                clear
                echo -e "${rosa}"; figlet Incluir; echo -e "${borra_colores}"
                echo ""
                echo -e "${verde}- Listado de tus dispositivos actuales -${borra_colores}"
                echo ""
                tail -n +2 /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config | awk -F'[[\]=]+' '{print "\033[32m" $3 "\033[0m =", "\033[32m" $2 "\033[0m"}' | column -t; echo ""
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
                echo -e "${azul} Introduce ( s para salir ), ( Ej. 192.168.1.1 router ).${borra_colores}"
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
                echo -e "${rosa}"; figlet Eliminar; echo -e "${borra_colores}"
                echo ""
                echo -e "${verde}- Listado de tus dispositivos actuales -${borra_colores}"
                echo ""
                tail -n +2 /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config | awk -F'[[\]=]+' '{print "  Dispositivo = ", "\033[32m" $3 "\033[0m"}' | column -t; echo ""
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
            clear
            echo -e "${rosa}"; figlet Editar; echo -e "${borra_colores}"
            sleep 1
            nano /home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config
            ;;

        4)  #Desistalar (Se elimina completamente de tu sistema)
            clear
            echo -e "${rojo}"; figlet Desistalar; echo -e "${borra_colores}"
            echo -e "${rojo}"
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
            echo -e "${rosa}"; figlet Escanear; echo -e "${borra_colores}"
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

        90)  #opcion 3
            ;;
        99) #salir
            ctrl_c
            ;;


        *)      #se activa cuando se introduce una opcion no controlada del menu
                echo "";
                echo -e " ${amarillo}OPCION NO DISPONIBLE EN EL MENU.    Seleccion 0, 1, 2, 3, 4, 5, 6,7, 90 o 99 ${borra_colores}";
                echo -e " ${amarillo}PRESIONA ENTER PARA CONTINUAR ........${borra_colores}";
                echo "";
                read pause;;

esac
done
}

# EMPIEZA LO GORDO
clear
echo ""
conexion
echo ""
if [ $conexion = "SI" ]
then
    #si hay internet
    software_necesario
    actualizar_script
else
    #no hay internet
    software_necesario
fi
sleep 3
archivo="/home/$(whoami)/.config/dispositivos_conectados/dispositivos_conectados.config"
if [ -f "$archivo" ] && grep -q "\[" "$archivo"; then
    configurar="SI"
else
    rm $archivo
    configurar="NO"
    configurar
fi

if [ "$1" = "-m" ]
then
    menu
fi

#escanea directo
clear
echo -e "${rosa}"; figlet " sukigsx"; echo -e "${borra_colores}"
echo -e "${verde} Diseñado por sukigsx / Contacto:   scripts@mbbsistemas.es${borra_colores}"
echo -e "${verde}                                    https://repositorio.mbbsistemas.es${borra_colores}"
echo ""
echo -e "${verde} Cargar el menu = ${borra_colores}$0 -m"
echo ""
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
