# Proyecto: Herramientas Bash — HTB Machines & Ruleta

**(Trabajo de práctica — scripts en Bash)**

> Este repositorio contiene dos herramientas desarrolladas en Bash durante un curso de introducción a Linux. Su propósito es servir como muestra de práctica y aprendizaje, no como proyecto colaborativo.

---

## Contenido

* `htbmachines.sh` — Buscador y gestor del fichero `bundle.js` con datos de máquinas de HackTheBox resueltas por S4vitar.
* `ruleta.sh` — Simulador de ruleta con estrategias Martingala, Fibonacci e Inverse Labouchère.

---

## Descripción

### 🔎 htbmachines.sh

Permite realizar búsquedas y actualizaciones sobre un archivo `bundle.js` (obtenido con curl desde https://htbmachines.github.io/bundle.js) que contiene información de máquinas HackTheBox resueltas por S4vitar. Las opciones disponibles son:

* `u` → Descargar o actualizar archivos necesarios.
* `m` → Buscar por nombre de máquina y listar sus características.
* `i` → Buscar máquina por su dirección IP.
* `y` → Obtener link de resolución en YouTube de una máquina concreta.
* `d` → Listar máquinas por dificultad (puede combinarse con la búsqueda por SO o por certificación).
* `o` → Listar máquinas por sistema operativo.
* `t` → Listar máquinas por técnica.
* `c` → Listar máquinas por certificación.
* `s` → Ordenar alfabéticamente los resultados (en el caso de que sean listas de máquinas).
* `h` → Mostrar panel de ayuda.

**Ejemplo básico de ejecución:**

```bash
./htbmachines.sh -m Monteverde
./htbmachines.sh -d Fácil -s
```

### 🎰 ruleta.sh

Simulador de ruleta que aplica estrategias clásicas de progresión en apuestas.

* `m` → Indicar el dinero con el que se desea jugar (entero).
* `t` → Estrategia a seguir: `martingala`, `inverselabrouchere`, `fibonacci`.
* `u` → Umbral de beneficios tras el cual retirarse (opcional). Debe ser superior al dinero con el que ingresamos.
* `h` → Mostrar panel de ayuda.

Una vez elegida la estrategia, se nos pedirá la apuesta que deseamos realizar continuamente entre las opciones:

* `par/impar`
* `rojo/negro`

En el caso de la martingala, se nos solicitará también el importe de la apuesta inicial.

Para las estrategias inverseLabrouchere y fibonacci, utilizaremos secuencias predefinidas que serán restablecidas tras superar cierto umbral de beneficio (50€ en nuestro caso).

La simulación se ejecuta de forma continua imprimiendo por pantalla una traza de cada jugada simulada. Podremos acelerar la simulación comentando o eliminando las líneas que imprimen la traza. Existen tres formas de detener la simulación:

* `Quedarnos sin dinero para apostar`. La única manera si no establecemos un umbral de beneficio.
* `Alcanzar el umbral de beneficio`. Si lo hemos establecido al lanzar el script, la simulación se detendrá si alcanzamos el umbral indicado.
* `Detención manual`. Presionando la combinación de teclas Ctrl + C.

**Ejemplo básico:**

```bash
./ruleta.sh -m 1000 -t martingala -u 2000
```

### :underage: Aviso

En ningún caso el script `ruleta.sh` busca ofrecer consejos de cómo apostar a la ruleta. De hecho, En su versión más básica demuestra como no existe una estrategia infalible para ganar y que al final la banca siempre gana, haciéndonos perder todo nuestro dinero. No se recomienda el empleo de las estrategias en él implementadas como método para ganadr 'dinero fácil'.

Eñ único propósito del script es practicar el scripting en bash.


---

## Requisitos

* **Bash** (≥ 4 recomendado)
* **js-beautify** (opcional, para formateo de `bundle.js`)
* Utilidades estándar: `grep`, `awk`, `sed`, `sort`, `mktemp`, `mv`, etc.

> En Windows, si usas **Git Bash**, algunas herramientas como `sponge` pueden no estar disponibles. Se recomienda el uso de **WSL** o la alternativa `js-beautify -r bundle.js`.

---

## Instalación

```bash
git clone https://github.com/dalarconro/herramientas_bash.git
cd herramientas_bash
chmod +x htbmachines.sh ruleta.sh
```

Opcionalmente, instala `js-beautify`:

```bash
npm install -g js-beautify
```

---

## Estructura del repositorio

```
README.md
htbmachines.sh
ruleta.sh
data/
  bundle.js (opcional)
examples/
  (salidas de ejemplo)
```

---

## Licencia

MIT License
Copyright (c) 2025 Diego Alarcón

---

## Autor

**Diego Alarcón** — Estudiante y desarrollador de Bash en formación (curso de introducción a Linux)

---

## Agradecimientos

Agradecimiento especial a **S4vitar** por el contenido del curso y la inspiración del proyecto.

---

*Este proyecto se publica con fines educativos.*
