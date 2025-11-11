# Actualización de los archivos necesarios

Para la correcta ejecución del script es necesario disponer de una versión actualizada del archivo bundle.js. Para mantenerlo siempre actualizado, no tenemos más que ejecutar el script de la siguiente forma:

`./htbmachines.sh -u `

Este comando descarga una versión temporal del archivo, lo trata y, si ya existía, lo compara con la versión anterior para actualizarlo si es necesario. Pueden darse tres situaciones al ejecutarlo:

* Que no tuviéramos el archivo descargado.
* Que lo tuviéramos descargado, pero esté desactualizado.
* Que lo tuviéramos descargado y actualizado a la última versión.

### Opción 1: El archivo no está descargado

En este caso, el archivo únicamente se desargará y se tratará para permitir su tratamiento en las distintas ejecuciones del script. Tras ejecutar el comando, obtendremos una salida como la siguiente:

`[+] Descargando archivos necesarios`

`[+] Todos los archivos han sido descargados`

### Opción 2: El archivo está desactualizado

En este caso, se descargará una copia temporal y se comparará con la que tengamos disponible. Al encontrar discrepancias, la copia temporal sustituirá a la original. Tras ejecutar el comando, obtendremos una salida como la siguiente:

`[+] Comprobando si hay actualizaciones pendientes...`

`[+] Se han encontrado actualizaciones disponibles`

`[+] Los archivos han sido actualizados correctamente`

### Opción 3: El archivo está descargado y actualizado

Finalmente, en este caso y tras comprobar que la copia temporal y la original son idénticas, se descartará la copia temporal del archivo. Tras ejecutar el comando obtendremos una salida como la siguiente:

`[+] Comprobando si hay actualizaciones pendientes...`

`[+] No se han detectado actualizaciones. Los archivos están al día.`


## Consideraciones finales

En cualquiera de las tres opciones, dispondremos del archivo `bundle.js` listo para su utilización, en la misma carpeta en la que se encuentra el script `htbmachines.sh`.