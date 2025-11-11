# Obtención de listas de máquinas según distintos criterios

La herramienta permite obtener listados de aquellas máquinas que cumplan ciertos criterios de:

* Dificultad, utilizando el parámetro `-d`
* Sistema operativo, utilizando el parámetro `-o`
* Certificación, utilizando el parámetro `-c`

Utilizando, encontraremos el nombre de todas aquellas máquinas que cumplan con los requisitos establecidos en la ejecución.

Por ejemplo, podremos listar todas aquellas máquinas de dificultad fácil ejecutando:

`./htbmachines -d fácil`

![Listado de máquinas de dificultad fácil](/screenshots/03-Fácil.png)

La búsqueda por dificultad, puede combinarse con la búsqueda por sistema operativo, aplicándose ambos filtros de forma simultánea, como en el siguiente ejemplo:

`./htbmachines.sh -d fácil -o Linux`

![Listado de máquinas de dificultad fácil y sistema operativo Linux](/screenshots/03-Fácil_Linux.png)

Además, podemos aplicar un ordenamiento alfabético a los resultados si añadimos el parámetro `-s`, como podemos ver a continuación:

`./htbmachines.sh -d fácil -o Linux -s`

![Listado de máquinas de dificultad fácil y sistema operativo Linux, ordenadas alfabéticamente](/screenshots/03-Fácil_Linux_ordenadas.png)

La búsqueda por dificultad, también puede combinarse con la búsqueda por certificación. En el siguiente ejemplo, listamos de forma ordenada aquellas máquinas de dificultad fácil y que guarden relación con la certificación ecpptv2:

`./htbmachines.sh -c ecpptv2 -d fácil -s`

![Listado de máquinas de dificultad fácil y relacionadas con la certificación ecpptv2, ordenadas alfabéticamente](/screenshots/03-Fácil_cert.png)


## Consideraciones finales

La búsqueda combinada de máquinas por certificación y sistema operativo, así como la combinación de estas dos con la búsqueda por dificultad no está implementada.