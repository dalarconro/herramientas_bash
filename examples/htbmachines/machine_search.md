# Búsqueda de una máquina

La herramienta permite obtener las características correspondientes a una máquina a través de su nombre. Para obtener dichas propiedades deberemos ejecutar el script con el parámetro `-m` seguido del nombre de la máquina, como en el siguiente ejemplo:

`./htbmachines.sh -m Haircut`

Obtendremos todas las propiedades de la máquina, como ilustra la siguiente imagen:

![Propiedades de la máquina Haircut](/screenshots/02-Máquina_Haircut.png)

También podemos buscar una máquina por su dirección ip utilizando el parámetro `-i`. En este caso nos devolverá el nombre asociado a la máquina. Siguiendo el ejemplo de la máquina Haircut, podemos ejecutar:

`./htbmachines.sh -i 10.10.10.24`

Y obtendremos como resultado:

`[+] La máquina con IP 10.10.10.24 es Haircut`

Y si quisiéramos únicamente obtener en enlace al vídeo de Youtube con la resolución de la máquina podemos emplear el parámetro -y. Otra vez, con el mismo ejemplo, ejecutaríamos:

`./htbmachines.sh -y Haircut`

Y obtendremos como resultado:

`[+] La resolución de la máquina Haircut puede obtenerse en el siguiente enlace: https://www.youtube.com/watch?v=9gurBGeazok`

