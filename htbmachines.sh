#!/bin/bash

#Coulors
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
greyColour="\e[0;37m\033[1m"

# Colores extendidos (TrueColor, 24-bit)
orangeColour="\033[38;2;255;165;0m\033[1m"      # Naranja puro
pinkColour="\033[38;2;255;105;180m\033[1m"      # Rosa fuerte (HotPink)
lightBlueColour="\033[38;2;135;206;250m\033[1m" # Azul claro (SkyBlue)
brownColour="\033[38;2;139;69;19m\033[1m"       # Marrón (SaddleBrown)
goldColour="\033[38;2;255;215;0m\033[1m"        # Dorado
lightGreyColour="\033[38;2;211;211;211m\033[1m" # Gris claro
darkGreyColour="\033[38;2;169;169;169m\033[1m"  # Gris oscuro

# Función empleada para interrumpir el programa
function ctrl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm && exit 1
}

# Ctrl+C
trap ctrl_c INT

# Variables globales
main_url="https://htbmachines.github.io/bundle.js"

# Función empleada para mostrar el panel de ayuda de la herramienta
function helpPanel(){
  echo -e "\n${yellowColour}[+]${greyColour} Uso:${endColour}"
  echo -e "\t${purpleColour}u)${greyColour} Descargar o actualizar archivos necesarios.${endColour}"
  echo -e "\t${purpleColour}m)${greyColour} Buscar por un nombre de máquina.${endColour}"
  echo -e "\t${purpleColour}i)${greyColour} Buscar por dirección IP.${endColour}"
  echo -e "\t${purpleColour}y)${greyColour} Obtener link a la resolución de la máquina en Youtube.${endColour}"
  echo -e "\t${purpleColour}d)${greyColour} Listar las máquinas de una dificultad determinada. Puede combinarse con búsqueda por SO o por certificación.${endColour}"
  echo -e "\t${purpleColour}o)${greyColour} Listar las máquinas de un sistema operativo (SO)  determinado.${endColour}"
  echo -e "\t${purpleColour}t)${greyColour} Listar las máquinas que requieran de una técnica determinada.${endColour}"
  echo -e "\t${purpleColour}c)${greyColour} Listar las máquinas asociadas a una certificación determinada.${endColour}"
  echo -e "\t${purpleColour}s)${greyColour} Ordena alfabéticamente los resultados. Debe combinarse con parámetros que listan los resultados.${endColour}"
  echo -e "\t\t${greyColour}Ejemplos de uso:"
  echo -e "\t\t\t${yellowColour}[+]${greyColour} Por separado:${endColour} -d [dificultad] -s ${greyColour}//${endColour} -o [SO] -s ${greyColour}//${endColour} -k [skill] -s ${greyColour}//${endColour} -s -d [dificultad] ${greyColour}//${endColour} -s -o [SO] ${greyColour}//${endColour} -s -k [skill]"
  echo -e "\t\t\t${yellowColour}[+]${greyColour} En conjunto:${endColour} -sd [dificultad] ${greyColour}//${endColour} -so [SO] ${greyColour} ${greyColour}//${endColour} -sk [skill] ${greyColour}(siempre primero el parámetro \"-s\")${endColour}"
  echo -e "\t${purpleColour}h)${greyColour} Abrir el panel de ayuda.${endColour}\n"
}


# Función empleada para obtener el archivo que contiene la información sobre las máquinas
  # Si no disponemos del archivo, lo descarga
  # Si disponemos de él, descarga una copia y lo compara con el anterior para buscar actualizaciones, actualizándolo si es necesario
  # Sin argumentos

function updateFiles(){
  if [ ! -f data/bundle.js ]; then
    tput civis
    echo -e "\n${yellowColour}[+]${greyColour} Descargando archivos necesarios...${endColour}"
    curl -s $main_url > data/bundle.js
    js-beautify -r data/bundle.js > /dev/null
    echo -e "\n${yellowColour}[+]${greyColour} Todos los archivos han sido descargados${endColour}\n"
    tput cnorm
  else
    tput civis
    echo -e "\n${yellowColour}[+]${greyColour} Comprobando si hay actualizaciones pendientes...${endColour}"
    curl -s $main_url > data/bundle_temp.js
    js-beautify -r data/bundle_temp.js > /dev/null
    # Utilizamos el hash md5 para comprobar si ha habido cambios
    md5_temp_value=$(md5sum data/bundle_temp.js | awk '{print $1}')
    md5_original_value=$(md5sum data/bundle.js | awk '{print $1}')

    if [ "$md5_temp_value" == "$md5_original_value" ]; then
      echo -e "\n${yellowColour}[+]${greyColour} No se han detectado actualizaciones. Los archivos están al día.${endColour}\n"
      rm data/bundle_temp.js
    else
      echo -e "\n${yellowColour}[+]${greyColour} Se han encontrado actualizaciones disponibles${endColour}"
      sleep 1

      rm data/bundle.js && mv data/bundle_temp.js data/bundle.js
      echo -e "\n${yellowColour}[+]${greyColour} Los archivos han sido actualizados correctamente${endColour}\n"
    fi
    tput cnorm
  fi
}


# Función que muestra por pantalla la información asociada a una máquina
  # Comprueba si la máquina existe y muestra su información en caso de que así sea. En caso contrario, muestra un mensaje de error.
  # Argumentos:
    # $1: el nombre de la máquina de la que deseamos obtener información. Case sensitive

function searchMachine(){
  machineName="$1"

  machineName_checker=$(cat data/bundle.js | awk "/name: \"$machineName\"/,/resuelta:/" | grep -vE "id:|sku:|resuelta" | tr -d '"' | tr -d ',' | sed 's/^ *//')
  
  if [ "$machineName_checker" ]; then
    echo -e "\n${yellowColour}[+]${greyColour} Listando las propiedades de la máquina${blueColour} $machineName${greyColour}:${endColour}\n"

    # Bucle para dar formato a la salida
    while IFS= read -r line; do
      key=$(echo "$line" | cut -d':' -f1)
      value=$(echo "$line" | cut -d':' -f2-)

      echo -e "${greenColour}$key:${greyColour}$value${endColour}"
    done <<< "$machineName_checker"
    echo -e " "
  else
    echo -e "\n${redColour}[!] No existen datos para la máquina${blueColour} $machineName${endColour}\n"
  fi
}


# Función que localiza el nombre de una máquina en base a su dirección IP
  # Verifica que la IP esté asociada a una máquina y, en caso afirmativo, muestra su nombre. En caso contrario, muestra un mensaje de error
  # Argumentos:
    # $1: la IP a través de la que buscamos hallar el nombre de la máquina

function searchIP(){
  ipAddress="$1"
  machineName=$(cat data/bundle.js | grep "ip: \"$ipAddress\"" -B 3 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')

  if [ "$machineName" ]; then
    echo -e "\n${yellowColour}[+]${greyColour} La máquina con IP${blueColour} $ipAddress${greyColour} es${purpleColour} $machineName${endColour}\n"
  else 
    echo -e "\n${redColour}[!] La IP${blueColour} $ipAddress ${redColour}no está asociada a ninguna máquina de la base de datos${endColour}\n" 
  fi
}


# Función que muestra por pantalla el enlace al vídeo de resolución de una máquina a partir de su nombre
  # Comprueba que la máquina exista en la BD y, en caso afirmativo, muestra su enlace. En caso contrario muestra un mensaje de error
  # Argumentos:
    # $1: el nombre de la máquina cuya resolución queremos visualizar. Case insensitive, sensible a acentos

function getLink(){
  machineName="$1"

  youtubeLink="$(cat data/bundle.js | grep "name: \"$machineName\"" -i -A 10 | grep youtube: | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"

  if [ $youtubeLink ]; then
    realName="$(cat data/bundle.js | grep "name: \"$machineName\"" -i | awk 'NF{print $NF}' | tr -d '"' | tr -d ',')"
    echo -e "\n${yellowColour}[+]${greyColour} La resolución de la máquina${blueColour} $realName${greyColour} puede encontrarse en el siguiente enlace: ${blueColour}$youtubeLink${endColour}\n"
  else
    echo -e "\n${redColour}[!] La máquina${blueColour} $machineName${redColour} no se encuentra en la base de datos o no dispone de enlace a su resolución${endColour}\n"
  fi
}


# Función que lista por pantalla el conjunto de máquinas de una determinada dificultad
  # Comprueba si hay máquinas de dicha dificultad y las muestra por pantalla en caso afirmativo. En caso contrario, muestra un mensaje de error.
  # Argumentos:
    # $1: el nivel de dificultad deseado. Case insensitive, sensible a acentos
    # $2: parámetro utilizado para determinar si queremos obtener el resultado ordenado alfabéticamente (1) o no (0)

function searchDifficulty(){
  difficulty="$1"
  sorted=$2
  difficultyColour=$blueColour

  # Modificamos el color de la salida en función del nivel
  caseDifficulty="$(echo $difficulty | tr '[:upper:]' '[:lower:]')"
  case $caseDifficulty in
    fácil) difficultyColour=$greenColour;;
    media) difficultyColour=$yellowColour;;
    difícil) difficultyColour=$orangeColour;;
    insane) difficultyColour=$redColour;;
  esac

  if [ $sorted -eq 1 ]; then
    results_check="$(cat data/bundle.js | grep "dificultad: \"$difficulty\"" -i -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | sort |  column -x -c $(tput cols))"
  else
    results_check="$(cat data/bundle.js | grep "dificultad: \"$difficulty\"" -i -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column -x -c $(tput cols))"
  fi

  if [ "$results_check" ]; then
    # Recuperamos el nivel de dificultad, tal y como está en el archivo original (se podría haber perdido al ser case insensitive)
    realDifficulty="$(cat data/bundle.js | grep "dificultad: \"$difficulty\"" -i | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | head -n 1)"
    echo -e "\n${yellowColour}[+]${greyColour} Listando las máquinas de dificultad${difficultyColour} $realDifficulty${greyColour}:${endColour}\n"
    echo -e "${greyColour}$results_check${endColour}\n"
  else
    echo -e "\n${redColour}[!] No disponemos de máquinas con dificultad${difficultyColour} $difficulty${endColour}"
    echo -e "\n${redColour}[+]  Los niveles de dificultad posibles son:${greenColour} \"Fácil\"${greyColour}, ${yellowColour}\"Media\"${greyColour}, ${orangeColour}\"Difícil\" ${greyColour}e ${redColour}\"Insane\"${endColour}\n"
  fi
}


# Función que lista por pantalla el conjunto de máquinas de un determinado sistema operartivo
  # Comprueba si existen máquinas para dicho sistema operativo y las muestra por pantalla. En caso contrario, muestra un mensaje de error
  # Argumentos:
    # $1: el sistema operativo cuyas máquinas deseamos visualizar. Case insensitive, sensible a acentos
    # $2: parámetro utilizado para determinar si queremos obtener el resultado ordenado alfabéticamente (1) o no (0) 

function searchOSMachines(){
  os="$1"
  sorted=$2

  if [ $sorted -eq 1 ]; then
    os_results="$(cat data/bundle.js | grep "so: \"$os\"" -i -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | sort | column -x -c $(tput cols))"
  else
    os_results="$(cat data/bundle.js | grep "so: \"$os\"" -i -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column -x -c $(tput cols))"
  fi

  if [ "$os_results" ]; then
    # Recuperamos el sistema operativo, tal y como está en el archivo original (se podría haber perdido al ser case insensitive)
    realOS="$(cat data/bundle.js | grep "so: \"$os\"" -i | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | head -n 1)"
    echo -e "\n${yellowColour}[+]${greyColour} Listando las máquinas para el sistema operativo ${blueColour}$realOS${greyColour}:${endColour}"
    echo -e "\n${greyColour}$os_results${endColour}\n"
  else
    echo -e "\n${redColour}[!] No existen máquinas para el sistema operativo${blueColour} $os${endColour}"
    echo -e "\n${redColour}[+]  Los sistemas operativos posibles son:${blueColour} \"Windows\"${greyColour} y ${blueColour}\"Linux\"${endColour}\n"
  fi
}


# Función que lista por pantalla las máquinas para un determinado sistema operativo y con una dificultad concreta
  # Comprueba que existan máquinas de dicho SO y dificultad, mostrándolas por pantalla si es así. En caso contrario, muestra un mensaje de error.
  # Es una combinación de las funciones searchDifficulty() y searchOSMachines()
  # Argumentos:
    # $1: la dificultad de las máquinas que queremos obtener. Case insensitive, sensible a acentos
    # $2: el sistema operativo de las máquinas que queremos obtener. Case insensitive, sensible a acentos
    # $3: parámetro utilizado para determinar si queremos obtener el resultado ordenado alfabéticamente (1) o no (0)

function searchOSDifficultyMachines(){
  difficulty="$1"
  os="$2"
  sorted=$3
  difficultyColour=$blueColour
  caseDifficulty="$(echo $difficulty | tr '[:upper:]' '[:lower:]')"
  case $caseDifficulty in
    fácil) difficultyColour=$greenColour;;
    media) difficultyColour=$yellowColour;;
    difícil) difficultyColour=$orangeColour;;
    insane) difficultyColour=$redColour;;
  esac

  if [ $sorted -eq 1 ]; then
    results_check="$(cat data/bundle.js | grep "so: \"$os\"" -i -C 4 | grep "dificultad: \"$difficulty\"" -i -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | sort | column -x -c $(tput cols))"
  else
    results_check="$(cat data/bundle.js | grep "so: \"$os\"" -i -C 4 | grep "dificultad: \"$difficulty\"" -i -B 5 | grep "name:" | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column -x -c $(tput cols))"
  fi

  if [ "$results_check" ]; then
    realDifficulty="$(cat data/bundle.js | grep "dificultad: \"$difficulty\"" -i | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | head -n 1)"
    realOS="$(cat data/bundle.js | grep "so: \"$os\"" -i | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | head -n 1)"
    echo -e "\n${yellowColour}[+]${greyColour} Listando las máquinas para el sistema operativo${blueColour} $realOS${greyColour} con dificultad${difficultyColour} $realDifficulty${greyColour}:${endColour}"
    echo -e "\n${greyColour}$results_check${endColour}\n"
  else
    echo -e "\n${redColour}[!] No existen máquinas para el sistema operativo${blueColour} $os${redColour} con nivel de dificultad${difficultyColour} $difficulty${endColour}"
    echo -e "\n${redColour}[+]  Los sistemas operativos posibles son:${blueColour} \"Windows\"${greyColour} y ${blueColour}\"Linux\"${endColour}"
    echo -e "\n${redColour}[+]  Los niveles de dificultad posibles son:${greenColour} \"Fácil\"${greyColour}, ${yellowColour}\"Media\"${greyColour}, ${orangeColour}\"Difícil\" ${greyColour}e ${redColour}\"Insane\"${endColour}\n"
  fi
}


# Función que lista por pantalla las máquinas asociadas con una determinada técnica o skill
  # Comprueba que haya máquinas asociadas a dicha técnica y las muestra por pantalla en caso afirmativo. En caso contrario muestra un mensaje de error.
  # Argumentos:
    # $1: la técnica requerida por las máquinas que deseamos obtener. Case insensitive, sensible a acentos
    # $2: parámetro utilizado para determinar si queremos obtener el resultado ordenado alfabéticamente (1) o no (0)

function searchSkill(){
  skill="$1"
  sorted=$2

  if [ $sorted -eq 1 ]; then
    results_check="$(cat data/bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | sort | column -x -c $(tput cols))"
  else
    results_check="$(cat data/bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column -x -c $(tput cols))"
  fi

  if [ "$results_check" ]; then
    # Recuperamos la técnica tal y como está en el archivo original (podría haberse perdido al ser case insensitive)
    realSkill="$(cat data/bundle.js | grep "$skill" -i | head -n 1 | grep "$skill" -i -o)"
    echo -e "\n${yellowColour}[+]${greyColour} Listando las máquinas que requieren de la técnica${blueColour} $realSkill${greyColour}:${endColour}"
    echo -e "\n${greyColour}$results_check${endColour}\n"
  else
    echo -e "\n${redColour}[!] No disponemos de máquinas que requieran la skill${blueColour} $skill${endColour}\n"
  fi
}


# Función que lista por pantalla las máquinas asociadas con una determinada certificación
  # Comprueba que haya máquinas asociadas a dicha certificación y las muestra por pantalla en caso afirmativo. En caso contrario muestra un mensaje de error.
  # Argumentos:
    # $1: la certificación asociada a las máquinas. Case insensitive, sensible a acentos
    # $2: parámetro utilizado para determinar si queremos obtener el resultado ordenado alfabéticamente (1) o no (0)

function searchCertification(){
  certification="$1"
  sorted=$2

  if [ $sorted -eq 1 ]; then
    results_check="$(cat data/bundle.js | grep "like: " -B 7 | grep "$certification" -i -B 7 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | sort | column -x -c $(tput cols))"
  else
    results_check="$(cat data/bundle.js | grep "like: " -B 7 | grep "$certification" -i -B 7 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column -x -c $(tput cols))"
  fi

  if [ "$results_check" ]; then
    # Recuperamos la certificación tal y como está en el archivo original (podría haberse perdido al ser case insensitive)
    realCertification="$(cat data/bundle.js | grep "$certification" -i | head -n 1 | grep "\b$certification\b" -i -m1 -oP | head -n 1)"
    echo -e "\n${yellowColour}[+]${greyColour} Listando las máquinas asociadas a la certificación${blueColour} $realCertification${greyColour}:${endColour}"
    echo -e "\n${greyColour}$results_check${endColour}\n"
  else
    echo -e "\n${redColour}[!] No disponemos de máquinas asociadas a la certificación${blueColour} $certification${endColour}\n"
  fi
}


# Función que lista por pantalla las máquinas asociadas con una determinada certificación y de una dificultad concreta
  # Comprueba que haya máquinas asociadas a dicha certificación y dificultad y las muestra por pantalla en caso afirmativo. En caso contrario muestra un mensaje de error.
  # Argumentos:
    # $1: la certificación asociada a las máquinas. Case insensitive, sensible a acentos
    # $2: el nivel de dificultad deseado. Case insensitive, sensible a acentos.
    # $2: parámetro utilizado para determinar si queremos obtener el resultado ordenado alfabéticamente (1) o no (0)

function searchCertificationDifficulty(){
  certification="$1"
  difficulty="$2"
  sorted=$3
  difficultyColour=$blueColour
  caseDifficulty="$(echo $difficulty | tr '[:upper:]' '[:lower:]')"
  case $caseDifficulty in
    fácil) difficultyColour=$greenColour;;
    media) difficultyColour=$yellowColour;;
    difícil) difficultyColour=$orangeColour;;
    insane) difficultyColour=$redColour;;
  esac

  if [ $sorted -eq 1 ]; then
    results_check="$(cat data/bundle.js | grep "like: " -B 7 | grep "$certification" -i -B 7 | grep "dificultad: \"$difficulty\"" -i -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | sort | column -x -c $(tput cols))"
  else
    results_check="$(cat data/bundle.js | grep "like: " -B 7 | grep "$certification" -i -B 7 | grep "dificultad: \"$difficulty\"" -i -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column -x -c $(tput cols))"
  fi

  if [ "$results_check" ]; then
    # Recuperamos la certificación tal y como está en el archivo original (podría haberse perdido al ser case insensitive)
    realCertification="$(cat data/bundle.js | grep "$certification" -i | head -n 1 | grep "\b$certification\b" -i -m1 -oP | head -n 1)"
    # Hacemos lo mismo con la dificultad
    realDifficulty="$(cat data/bundle.js | grep "dificultad: \"$difficulty\"" -i | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | head -n 1)"
    echo -e "\n${yellowColour}[+]${greyColour} Listando las máquinas asociadas a la certificación${blueColour} $realCertification${greyColour} y nivel de dificultad${difficultyColour} $realDifficulty${greyColour}:${endColour}"
    echo -e "\n${greyColour}$results_check${endColour}\n"
  else
    echo -e "\n${redColour}[!] No disponemos de máquinas asociadas a la certificación${blueColour} $certification${redColour} y nivel de dificultad${difficultyColour} $difficulty${endColour}\n"
  fi
}


# Indicadores
# Utilizado para determinar la función a ejecutar según los parámetros de entrada
declare -i parameter_counter=0

# Chivatos
# Utilizados para determinar qué función ejecutar, o alterar el comportamiento de algunas funciones
declare -i results_sorted=0
declare -i chivato_difficulty=0
declare -i chivato_os=0
declare -i chivato_cert=0

# Bucle para actualizar indicadores y chivatos en función de los parámetros y argumentos
while getopts "m:ui:d:y:o:t:c:sh" arg; do
  case $arg in
    u) let parameter_counter+=1;;
    m) machineName="$OPTARG"; let parameter_counter+=2;;
    i) ipAddress="$OPTARG"; let parameter_counter+=3;;
    y) machineName="$OPTARG"; let parameter_counter+=4;;
    d) difficulty="$OPTARG"; chivato_difficulty=1; let parameter_counter+=5;;
    o) os=$OPTARG; chivato_os=1; let parameter_counter+=6;;
    t) skill=$OPTARG; let parameter_counter+=7;;
    c) certification=$OPTARG; chivato_cert=1; let parameter_counter+=8;;
    s) results_sorted=1;;
    h) ;;
  esac
done

# Bloque para determinar la función a ejecutar, pasándole los argumentos adecuados
if [ $parameter_counter -eq 1 ]; then
  updateFiles
elif [ $parameter_counter -eq 2 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 3 ]; then
  searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]; then
  getLink $machineName
elif [ $parameter_counter -eq 5 ]; then
  searchDifficulty $difficulty $results_sorted
elif [ $parameter_counter -eq 6 ]; then
  searchOSMachines $os $results_sorted
elif [ $parameter_counter -eq 7 ]; then
  searchSkill "$skill" $results_sorted
elif [ $parameter_counter -eq 8 ]; then
  searchCertification "$certification" $results_sorted
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
# Alternativa sin el uso de chivatos (habría que evitar utilizar otra funcion con parameter_counter=11)
#elif [ $parameter_counter -eq 11 ]; then
  searchOSDifficultyMachines $difficulty $os $results_sorted
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_cert -eq 1 ]; then
  searchCertificationDifficulty $certification $difficulty $results_sorted
else
  helpPanel
fi
