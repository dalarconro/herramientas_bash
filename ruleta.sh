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


# Función empleada para mostrar el panel de ayuda de la herramienta

function helpPanel(){
  echo -e "\n${yellowColour}[+]${greyColour} Uso de${purpleColour} $0${greyColour}:${endColour}\n"
  echo -e "\t${purpleColour}m)${greyColour} Indicar la cantidad de dinero con el que deseamos jugar. Debe ser un entero${endColour}"
  echo -e "\t${purpleColour}t)${greyColour} Técnica a utilizar.${endColour}"
  echo -e "\t\t${yellowColour}[+]${greyColour} Valores posibles:${purpleColour} martingala${greyColour} //${purpleColour} inverseLabrouchere${greyColour} //${purpleColour} fibonacci.${endColour}"
  echo -e "\t${purpleColour}u)${greyColour} Opcional. Establecer un umbral de beneficio, para retirarnos. Debe ser un entero mayor al dinero disponible${endColour}" # Pendiente de desarrollo
  echo -e "\t${purpleColour}h)${greyColour} Mostrar el panel de ayuda.${endColour}\n"
  exit 1
}


# Función empleada para determinar si ganamos o perdemos una apuesta, independientemente de la estrategia utilizada. Apostando a pares/impares
  # Sin parámetros necesarios
  # Devuelve la salida por consola, pudiendo utilizar la última línea para determinar si hemos ganado o perdido

function betResult(){
  result_number="$(($RANDOM % 37))"
  echo -e "${yellowColour}[+]${greyColour} Ha salido el número${pinkColour} $result_number${endColour}"
  if [ "$result_number" -eq 0 ]; then
    echo -e "${yellowColour}[+]${greyColour} Ha salido el número${greenColour} $result_number${greyColour},${redColour} pierdes${endColour}"
    result="lose"
  else
    if [ "$bet_option" = "par" ]; then
      if [ "$(($result_number % 2))" -eq 0 ]; then
        echo -e "${yellowColour}[+]${greyColour} El número que ha salido es par, ${greenColour}¡ganas!${endColour}"
        result="win"
      else
        echo -e "${yellowColour}[+]${greyColour} El número que ha salido es impar, por tanto${redColour} pierdes${endColour}"
        result="lose"
      fi
    else
      if [ ! "$(($result_number % 2))" -eq 0 ]; then
          echo -e "${yellowColour}[+]${greyColour} El número que ha salido es impar, ${greenColour}¡ganas!${endColour}"
          result="win"
      else
        echo -e "${yellowColour}[+]${greyColour} El número que ha salido es par, por tanto${redColour} pierdes${endColour}"
        result="lose"
      fi
    fi
  fi
  echo "$result"
}


# Función empleada para determinar si ganamos o perdemos una apuesta, independientemente de la estrategia utilizada. Apostando a colores
  # Sin parámetros necesarios
  # Devuelve la salida por consola, pudiendo utilizar la última línea para determinar si hemos ganado o perdido

function betResultColour(){
  reds=(1 3 5 7 9 12 14 16 18 19 21 23 25 27 30 32 34 36)
  blacks=(2 4 6 8 10 11 13 15 17 20 22 24 26 28 29 31 33 35)
  result_number="$(($RANDOM % 37))"
  if [ "$result_number" -eq 0 ]; then
    echo -e "${yellowColour}[+]${greyColour} Ha salido el número${greenColour} $result_number${greyCoulor},${redCoulor} pierdes${endColour}"
    result="lose"
  else
    for red in "${reds[@]}"; do
      if [ "$red" -eq "$result_number" ]; then
        coulor="red"
        printColour="${redColour}"
      fi
    done
    for black in "${blacks[@]}"; do
      if [ "$black" -eq "$result_number" ]; then
        coulor="black"
        printColour="${darkGreyColour}"
      fi
    done
    echo -e "${yellowColour}[+]${greyColour} Ha salido el número${printColour} $result_number${endColour}"
    if [ "$bet_option" = "rojo" ]; then
      if [ "$coulor" = "red" ]; then
        echo -e "${yellowColour}[+]${greyColour} El número que ha salido es ${redColour}rojo${greyColour}, ${greenColour}¡ganas!${endColour}"
        result="win"
      else
        echo -e "${yellowColour}[+]${greyColour} El número que ha salido es ${darkGreyColour}negro${greyColour}, por tanto${redColour} pierdes${endColour}"
        result="lose"
      fi
    else
      if [ "$coulor" = "black" ]; then
          echo -e "${yellowColour}[+]${greyColour} El número que ha salido es ${darkGreyColour}negro${greyColour}, ${greenColour}¡ganas!${endColour}"
          result="win"
      else
        echo -e "${yellowColour}[+]${greyColour} El número que ha salido es ${redColour}rojo${greyColour}, por tanto${redColour} pierdes${endColour}"
        result="lose"
      fi
    fi
  fi
  echo "$result"
}


# Función utilizada para determinar cómo paramos de apostar, si retirándonos o perdiendo, independientemente de la técnica utilizada
  # Sin parámetros necesarios
  # Detecta cuando hemos sobrepasado un umbral de beneficio o nos hemos quedado a 0, ejecutando la salida correspondiente

function exitMode(){
  # money=$1
  if [ $threshold ] && [ $money -ge $threshold ]; then
    echo -e "\n${greenColour}[!] ¡¡Enhorabuena!! Has alcanzado tu umbral de beneficio (${goldColour}$threshold€${greenColour}) después de${yellowColour} $plays${greenColour} jugadas y una racha de${yellowColour} $wins${greenColour} victorias seguidas${endColour}"
    echo -e "${greenColour}[!] Has entrado con${goldColour} $initial_money€${greenColour} y te llevas${goldColour} $money€${endColour}"
    echo -e "${greenColour}[!] ¡¡Vuelve pronto!!\n${endColour}"
    tput cnorm; exit 0
  elif [ $money -eq 0 ]; then
    echo -e "\n${redColour}[!] Te has quedado sin pasta después de${orangeColour} $loses${redColour} derrotas seguidas en${yellowColour} $plays${redColour} jugadas${endColour}"
    echo -e "${redColour}[!] Has entrado con${goldColour} $initial_money€${redColour} y has llegado a tener${goldColour} $max_money€${endColour}"
    echo -e "${redColour}[!] Aprende a retirarte a tiempo, payaso${endColour}"
    echo -e "${redColour}[!] ¡¡FUERA DEL CASINO!!\n${endColour}"
    tput cnorm; exit 0
  fi

}


# Función empleada para el uso de la técnica martingala
  # Sin parámetros necesarios
  # Implementa de forma continua la estrategia martingala, hasta quedarnos sin dinero u obtener cierto beneficio (opcional)

function martingala(){
  echo -e "\n${yellowColour}[+]${greyColour} Dinero disponible: ${goldColour}$money€${endColour}"
  echo -en "\n${yellowColour}[?]${greyColour} ¿Qué importe deseas apostar inicialmente? (disponible:${goldColour}$money€${greyColour})-> ${greenColour}" && read initial_bet
  while [[ ! "$initial_bet" =~ ^[0-9]+$ ]] || [ $initial_bet -gt $money ]; do
    if [[ ! "$initial_bet" =~ ^[0-9]+$ ]]; then
      echo -e "${redColour}[!] Su apuesta inicial debe ser un número entero positivo. Por favor, introduzca una nueva apuesta${endColour}"
    elif [ $initial_bet -gt $money ]; then
      echo -e "${redColour}[!] No dispone de suficiente dinero. Por favor, reduzca el importe de su apuesta.${endColour}"
    fi
    echo -en "${yellowColour}[?]${greyColour} ¿Qué importe deseas apostar inicialmente? (disponible:${goldColour}$money€${greyColour})-> ${greenColour}" && read initial_bet
  done
  echo -en "\n${yellowColour}[?]${greyColour} ¿Qué apuesta deseas realizar de forma continua (${blueColour}par${greyColour}/${blueColour}impar${greyColour}) // (${redColour}rojo${greyColour}/${darkGreyColour}negro${greyColour})? -> ${blueColour}" && read bet_option
  while [ "$bet_option" != "par" ] && [ "$bet_option" != "impar" ] && [ "$bet_option" != "rojo" ] && [ "$bet_option" != "negro" ]; do
    echo -e "${redColour}[!] Opción no disponible para apostar. Por favor, seleccione una opción disponible.${endColour}"
    echo -en "${yellowColour}[?]${greyColour} ¿Qué apuesta deseas realizar de forma continua (${blueColour}par${greyColour}/${blueColour}impar${greyColour}) // (${redColour}rojo${greyColour}/${darkGreyColour}negro${greyColour})? -> ${blueColour}" && read bet_option
  done

  echo -e "\n${yellowColour}[+]${greyColour} Vamos a jugar con una cantidad inicial de${greenColour} $initial_bet€${greyColour} a la opción ${blueColour}$bet_option."${endColour}

  declare -i plays=0 # Variable para almacenar el número de jugadas
  declare -i loses=0 # Variable para almacenar el número de veces que hemos perdido de forma seguida
  declare -i wins=0 # Variable para almacenar el número de veces que hemos ganado de forma seguida
  initial_money=$money
  max_money=$money
  tput civis # Ocultamos el cursor
  while true; do
    let plays+=1
    
    # Si hemos ganado en la anterior jugada, volvemos a la apuesta inicial
    if [ $loses -eq 0 ]; then
      bet=$initial_bet
    # Si hemos perdido en la anterior jugada, duplicamos la apuesta
    else
      multi=$((2**$loses))
      bet=$(($initial_bet*$multi))
    fi

    if [ $bet -ge $money ]; then
      #echo -e "\n\n${orangeColour}[!] Atención: jugada crítica. Si pierdes, te quedarás sin dinero${endColour}"
      bet=$money
    fi
    money=$(($money-$bet))
    echo -e "\n${yellowColour}[+]${greyColour} Acabas de apostar${goldColour} $bet€${greyColour} y te quedan${goldColour} $money€${endColour}"

    # Utilizamos la función betResult() o betResultColour() para determinar el resultado
    if [ "$bet_option" = "par" ] || [ "$bet_option" = "impar" ]; then
      output="$(betResult)"
    else
      output="$(betResultColour)"
    fi
    echo "$output" | head -n 2
    result=$(echo "$output" | tail -n 1)

    if [ "$result" = "win" ]; then
      # Actualizamos la recompensa obtenida y el dinero disponible
      reward=$(($bet*2))
      echo -e "${yellowColour}[+]${greyColour} Ganas un total de${goldColour} $reward€${endColour}"
      money=$(($money+$reward))
      echo -e "${yellowColour}[+]${greyColour} Tienes${goldColour} $money€${endColour}"
      # Restablecemos el contador de derrotas; aumentamos el contador de victorias
      loses=0
      let wins+=1
    else
      echo -e "${yellowColour}[+]${greyColour} Te quedan${goldColour} $money€${greyColour} para apostar${endColour}"
      # Aumentamos el contador de derrotas; reseteamos el de victorias
      let loses+=1
      wins=0
    fi

    # Actualizamos el máximo de dinero obtenido, si es necesario
    if [ $money -gt $max_money ]; then
      max_money=$money
    fi

    # Decidimos si debemos retirarnos por sobrepasar el umbral de beneficio, o si el casino debe echarnos por quedarnos sin dinero
    exitMode
  done
  tput cnorm # Recuperamos el cursor
}


# Función empleada para el uso de la técnica inverseLabrouchere
  # Sin parámetros necesarios
  # Implementa de forma continua la estrategia inverseLabrouchere, hasta quedarnos sin dinero u obtener cierto beneficio (opcional)

function inverseLabrouchere(){
  echo -e "\n${yellowColour}[+]${greyColour} Dinero disponible: ${goldColour}$money€${endColour}"
  echo -en "\n${yellowColour}[?]${greyColour} ¿Qué apuesta deseas realizar de forma continua (${blueColour}par${greyColour}/${blueColour}impar${greyColour}) // (${redColour}rojo${greyColour}/${darkGreyColour}negro${greyColour})? -> ${blueColour}" && read bet_option
  while [ "$bet_option" != "par" ] && [ "$bet_option" != "impar" ] && [ "$bet_option" != "rojo" ] && [ "$bet_option" != "negro" ]; do
    echo -e "${redColour}[!] Opción no disponible para apostar. Por favor, seleccione una opción disponible.${endColour}"
    echo -en "${yellowColour}[?]${greyColour} ¿Qué apuesta deseas realizar de forma continua (${blueColour}par${greyColour}/${blueColour}impar${greyColour}) // (${redColour}rojo${greyColour}/${darkGreyColour}negro${greyColour})? -> ${blueColour}" && read bet_option
  done

  declare -a my_sequence=(1 2 3 4) # Secuencia inicial
  declare -i plays=0 # Variable para almacenar el número de jugadas
  declare -i loses=0 # Variable para almacenar el número de veces que hemos perdido de forma seguida
  declare -i wins=0 # Variable para almacenar el número de veces que hemos ganado de forma seguida
  initial_money=$money
  max_money=$money
  bet_to_renew=$(($money + 50))

  tput civis
  while true; do
    let plays+=1
    
    # Si nuestra secuencia tiene más de un elemento, apostaremos con la suma de los extremos. Si no, apostaremos su único elemento.
    if [ ${#my_sequence[@]} -ge 2 ]; then
      bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
    else
      bet=${my_sequence[0]}
    fi

    if [ $bet -ge $money ]; then
      echo -e "\n\n${orangeColour}[!] Atención: jugada crítica. Si pierdes, te quedarás sin dinero${endColour}"
      bet=$money
    fi
    money=$(($money-$bet))
    echo -e "\n${yellowColour}[+]${greyColour} Vas a jugar con la secuencia${greenColour} (${my_sequence[@]})${endColour}"
    echo -e "${yellowColour}[+]${greyColour} Acabas de apostar${goldColour} $bet€${greyColour} y te quedan${goldColour} $money€${endColour}"

    # Utilizamos la función betResult() o betResultColour() para determinar el resultado
    if [ "$bet_option" = "par" ] || [ "$bet_option" = "impar" ]; then
      output="$(betResult)"
    else
      output="$(betResultColour)"
    fi
    echo "$output" | head -n 2
    result=$(echo "$output" | tail -n 1)

    # Si hemos ganado, añadimos el importe apostado a la secuencia
    if [ "$result" = "win" ]; then
      my_sequence+=($bet)
      my_sequence=(${my_sequence[@]})
      # También actualizamos la recompensa obtenida y el dinero disponible
      reward=$(($bet*2))
      echo -e "${yellowColour}[+]${greyColour} Ganas un total de${goldColour} $reward€${endColour}"
      money=$(($money+$reward))
      echo -e "${yellowColour}[+]${greyColour} Tienes${goldColour} $money€${endColour}"
      # Restablecemos el contador de derrotas; aumentamos el contador de victorias
      loses=0
      let wins+=1
    # Si hemos perdido, eliminamos los extremos de la secuencia (o la reiniciamos si es necesario)
    else
      if [ ${#my_sequence[@]} -le 2 ]; then
        my_sequence=(1 2 3 4)
      else
        unset my_sequence[0]
        unset my_sequence[-1]
        my_sequence=(${my_sequence[@]})
      fi
      echo -e "${yellowColour}[+]${greyColour} Te quedan${goldColour} $money€${greyColour} para apostar${endColour}"
      # Aumentamos el contador de derrotas; reseteamos el de victorias
      let loses+=1
      wins=0
    fi

    # Actualizamos el máximo de dinero obtenido, si es necesario
    if [ $money -gt $max_money ]; then
      max_money=$money
    fi

    # Modificamos el umbral para renovar la secuencia, si es necesario
    if [ $money -gt $bet_to_renew ]; then
      echo -e "\n${yellowColour}[+] Se ha alcanzado el umbral para renovar la secuencia de${goldColour} $bet_to_renew€${endColour}"
      let bet_to_renew+=50
      my_sequence=(1 2 3 4)
      echo -e "${yellowColour}[+] El nuevo umbral se ha establecido en${goldColour} $bet_to_renew€${endColour}"
      echo -e "${yellowColour}[+]${greyColour} La secuencia ha sido restablecida a${greenColour} (1 2 3 4)${endColour}"
    elif [ $money -lt $(($bet_to_renew - 100)) ]; then
      echo -e "\n${yellowColour}[+] Se ha traspasado el límite inferior para reiniciar el umbral de restablecimiento de la secuencia establecido en${goldColour} $bet_to_renew€${endColour}"
      let bet_to_renew-=50
      echo -e "${yellowColour}[+] El nuevo umbral se ha establecido en${goldColour} $bet_to_renew€${endColour}"
    fi

    # Decidimos si debemos retirarnos por sobrepasar el umbral de beneficio, o si el casino debe echarnos por quedarnos sin dinero
    exitMode
  done
  tput cnorm
}


# Función empleada para el uso de la técnica Fibonacci
  # Sin parámetros necesarios
  # Implementa de forma continua la estrategia de Fibonacci, hasta quedarnos sin dinero u obtener cierto beneficio (opcional)

function fibonacci(){
  echo -e "\n${yellowColour}[+]${greyColour} Dinero disponible: ${goldColour}$money€${endColour}"
  echo -en "\n${yellowColour}[?]${greyColour} ¿Qué apuesta deseas realizar de forma continua (${blueColour}par${greyColour}/${blueColour}impar${greyColour}) // (${redColour}rojo${greyColour}/${darkGreyColour}negro${greyColour})? -> ${blueColour}" && read bet_option
  while [ "$bet_option" != "par" ] && [ "$bet_option" != "impar" ] && [ "$bet_option" != "rojo" ] && [ "$bet_option" != "negro" ]; do
    echo -e "${redColour}[!] Opción no disponible para apostar. Por favor, seleccione una opción disponible.${endColour}"
    echo -en "${yellowColour}[?]${greyColour} ¿Qué apuesta deseas realizar de forma continua (${blueColour}par${greyColour}/${blueColour}impar${greyColour}) // (${redColour}rojo${greyColour}/${darkGreyColour}negro${greyColour})? -> ${blueColour}" && read bet_option
  done

  declare -a my_sequence=(1) # Secuencia inicial
  declare -i plays=0 # Variable para almacenar el número de jugadas
  declare -i loses=0 # Variable para almacenar el número de veces que hemos perdido de forma seguida
  declare -i wins=0 # Variable para almacenar el número de veces que hemos ganado de forma seguida
  initial_money=$money
  max_money=$money
  bet_to_renew=$(($money + 50))

  tput civis
  while true; do
    let plays+=1
    
    # Nuestra apuesta siempre será el último elemento de la secuencia.
    bet=${my_sequence[-1]}

    if [ $bet -ge $money ]; then
      echo -e "\n\n${orangeColour}[!] Atención: jugada crítica. Si pierdes, te quedarás sin dinero${endColour}"
      bet=$money
    fi
    money=$(($money-$bet))
    echo -e "\n${yellowColour}[+]${greyColour} Vas a jugar con la secuencia${greenColour} (${my_sequence[@]})${endColour}"
    echo -e "${yellowColour}[+]${greyColour} Acabas de apostar${goldColour} $bet€${greyColour} y te quedan${goldColour} $money€${endColour}"

    # Utilizamos la función betResult() o betResultColour() para determinar el resultado
    if [ "$bet_option" = "par" ] || [ "$bet_option" = "impar" ]; then
      output="$(betResult)"
    else
      output="$(betResultColour)"
    fi
    echo "$output" | head -n 2
    result=$(echo "$output" | tail -n 1)

    # Si hemos ganado, retrocedemos dos pasos en la secuencia (eliminar los dos elementos finales)
    if [ "$result" = "win" ]; then
      if [ ${#my_sequence[@]} -gt 2 ]; then
        unset my_sequence[-1]
        my_sequence=(${my_sequence[@]})
        unset my_sequence[-1]
        my_sequence=(${my_sequence[@]})
      else
        my_sequence=(1)
        my_sequence=(${my_sequence[@]})
      fi
      # También actualizamos la recompensa obtenida y el dinero disponible
      reward=$(($bet*2))
      echo -e "${yellowColour}[+]${greyColour} Ganas un total de${goldColour} $reward€${endColour}"
      money=$(($money+$reward))
      echo -e "${yellowColour}[+]${greyColour} Tienes${goldColour} $money€${endColour}"
      # Restablecemos el contador de derrotas; aumentamos el contador de victorias
      loses=0
      let wins+=1
    # Si hemos perdido, añadimos a la secuencia la suma de las dos últimas apuestas
    else
      if [ ${#my_sequence[@]} -ge 2 ]; then
        new=$((${my_sequence[-2]} + ${my_sequence[-1]}))
      else
        new=1
      fi
      my_sequence+=($new)
      my_sequence=(${my_sequence[@]})
      echo -e "${yellowColour}[+]${greyColour} Te quedan${goldColour} $money€${greyColour} para apostar${endColour}"
      # Aumentamos el contador de derrotas; reseteamos el de victorias
      let loses+=1
      wins=0
    fi

    # Actualizamos el máximo de dinero obtenido, si es necesario
    if [ $money -gt $max_money ]; then
      max_money=$money
    fi

    # Modificamos el umbral para renovar la secuencia, si es necesario
    if [ $money -gt $bet_to_renew ]; then
      echo -e "\n${yellowColour}[+] Se ha alcanzado el umbral para renovar la secuencia de${goldColour} $bet_to_renew€${endColour}"
      let bet_to_renew+=50
      my_sequence=(1)
      echo -e "${yellowColour}[+] El nuevo umbral se ha establecido en${goldColour} $bet_to_renew€${endColour}"
      echo -e "${yellowColour}[+]${greyColour} La secuencia ha sido restablecida a${greenColour} (1)${endColour}"
    elif [ $money -lt $(($bet_to_renew - 100)) ]; then
      echo -e "\n${yellowColour}[+] Se ha traspasado el límite inferior para reiniciar el umbral de restablecimiento de la secuencia establecido en${goldColour} $bet_to_renew€${endColour}"
      let bet_to_renew-=50
      echo -e "${yellowColour}[+] El nuevo umbral se ha establecido en${goldColour} $bet_to_renew€${endColour}"
    fi

    # Decidimos si debemos retirarnos por sobrepasar el umbral de beneficio, o si el casino debe echarnos por quedarnos sin dinero
    exitMode
  done
  tput cnorm
}



# Bucle utilizado para recuperar los argumentos introducidos en la ejecución del programa

while getopts "m:t:u:h" arg; do
  case $arg in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    u) threshold=$OPTARG;;
    h) ;;
  esac
done


# Validación de que los parámetros introducidos sean enteros
if [ $money ] && [[ ! "$money" =~ ^[0-9]+$ ]]; then
  echo -e "\n${redColour}[!] Debe introducir el dinero disponible como un número entero${endColour}\n"
  exit 1
fi
if [ $threshold ] && [[ ! "$threshold" =~ ^[0-9]+$ ]]; then
  echo -e "\n${redColour}[!] Debe introducir el umbral deseado como un número entero${endColour}\n"
  exit 1
fi

# Bloque definido para dirigir el flujo del programa en función de los argumentos introducidos

if [ $money ] && [ $technique ]; then
  if [ $money -le 0 ]; then
    echo -e "\n${redColour}[!] Lo sentimos, no dispone de suficiente dinero para apostar.${endColour}\n"
    exit 1
  elif [ $threshold ] && [ $money -ge $threshold ]; then
    echo -e "\n${redColour}[!] El umbral de beneficio debe ser mayor a tu dinero disponible.${endColour}\n"
    exit 1
  elif [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == "inverseLabrouchere" ]; then
    if [ $money -lt 10 ]; then
      echo -e "\n${redColour}[!] Necesitas al menos 10€ para poder utilizar la técnica Inverse Labrouchere${endColour}\n"
    else
      inverseLabrouchere
    fi
  elif [ "$technique" == "fibonacci" ]; then
    fibonacci
  else
    echo -e "\n${redColour}[!] La técnica introducida no está disponible.${endColour}\n"
    helpPanel
  fi
else
  helpPanel
fi
