# GuiaIntegradoraMED

Simulador avanzado de gestión de memoria en PSeInt que implementa la MMU, traducción de direcciones y algoritmos de reemplazo FIFO y Óptimo (OPT) para el análisis de fallos de página.

Nombre: Esmeralda Isabel Alvarez Rivas AR21036  
Teórico 2  
Asignatura: Manejo y Estructura de Datos  
Docente: MEd. Ing. Luis Alberto Herrera Mejía  

link del repo : https://github.com/AR21036-esmeralda/GuiaIntegradoraMED.git



## Descripción General

Este proyecto consiste en el desarrollo de un Simulador Avanzado de Administración de Memoria implementado en pseudocódigo utilizando PSeInt.

El sistema permite simular tres funciones principales de la gestión de memoria:

- Administración de memoria (Fase 1)  
- Traducción de direcciones lógicas a físicas (Fase 2)  
- Simulación de Algoritmos de Reemplazo de páginas FIFO y OPTIMO (Fase 3)  

El simulador está estructurado mediante un programa principal que controla el flujo mediante un menú, y subprocesos que representan cada fase.



## Especificaciones técnicas

El sistema simulado cumple con las siguientes características:

- Memoria RAM física: 16 KB  
- Tamaño de marco: 4 KB (4096bytes)  
- Número de marcos: 4 para fase 2 y 3 para fase 3  
- Memoria virtual (swap): 32 KB  
- Número máximo de páginas: 8  



## Estructuras de datos utilizadas

### Arreglos

**Estructuras de la memoria RAM**

- MarcoOcupado[] : indica si un marco está libre (0) u ocupado (1)  
- MarcoPagina[]: indica qué página está almacenada en cada marco  

**Tabla de paginas**

- Presente[]: indica si una página está cargada en memoria  
  1 = esta en RAM  
  0 = no esta en RAM  
- PaginaMarco[]: relaciona cada página lógica con el marco físico donde esta almacenada  

**Estructuras para reemplazo de paginas**

- Marcos[]: representa los marcos disponibles para los algoritmos FIFO y OPTIMO  
- Ocupado[]: indica si un marco está ocupado o libre  
- Referencias[]: secuencia de acceso a paginas que simula el comportamiento del proceso  



## Cómo ejecutar el programa

Para ejecutar el simulador en PSeInt, se deben seguir los siguientes pasos:

1. Abrir el archivo del código llamado:
   “SimuladorAvanzadoGestionMemoria.psc” en PSeInt  
2. Ejecutar el programa (botón "Ejecutar")  



## Uso del menú principal

Al iniciar el programa, se mostrará un menú principal con las siguientes opciones:

Aparecerá un menú principal con las siguientes opciones:

- 1: Fase 1 (Administrador de memoria)  
- 2: Fase 2 (La MMU y Traducción de Direcciones)  
- 3: Fase 3 (Simulación Algoritmos de Reemplazo)  
- 4: Salir  

3. Seleccionar una opción ingresando el número correspondiente y luego presiona ENTER  



## Fase 1: Administrador de memoria

4. Si se selecciona la opción 1, aparecerá un submenú con:

- 1: Inicializar RAM  
- 2: Mostrar mapa de bits  
- 3: Volver  

5. Para interactuar:
- Ingresar el número de la opción deseada  
- Presionar Enter para ejecutar la acción  



## Fase 2: Traducción de direcciones

6. Si se selecciona la opción 2, se ingresará a la fase de traducción.

En esta fase el sistema solicitará datos de forma secuencial:

- Primero se debe ingresar la página lógica  
- Luego se debe presionar Enter  
- Después, si la página es válida, se solicita el offset  
- Se debe volver a presionar Enter después de cada entrada  



## Fase 3: Simulación Algoritmos de Reemplazo

7. Si se selecciona la opción 3, se accede a la simulación de algoritmos.

Se mostrará un submenú con:

- 1: FIFO  
- 2: OPT  
- 3: Volver  

Para ejecutar un algoritmo:

- Ingresar el número de la opción  
- Presionar Enter  
- El sistema mostrará automáticamente la cantidad de fallos de página según la opción del algoritmo de reemplazo de página que elija ver  



## Análisis de resultados

En la Fase 3 del simulador se evaluaron dos algoritmos de reemplazo de páginas: FIFO (First-In First-Out) y Óptimo (OPT), utilizando la misma secuencia de referencias y tres marcos de memoria. La secuencia utilizada fue:

[1, 2, 3, 4, 1, 2, 5, 1, 2, 3, 4, 5]

El sistema trabaja sobre tres estructuras principales: los marcos de memoria (Marcos[]), que almacenan las páginas actualmente cargadas; el arreglo de control (Ocupado[]), que indica si un marco está disponible o en uso; y la secuencia de referencias (Referencias[]), que representa el orden de accesos a páginas durante la simulación.

En cada iteración, el sistema verifica si la página actual se encuentra en memoria mediante la función BuscarPaginaEnMarcos. Si la página no está presente, se produce un fallo de página. En ese caso, el sistema intenta colocar la página en un marco libre y, si no existe espacio disponible, se aplica el algoritmo de reemplazo correspondiente.

En el caso del algoritmo FIFO, el sistema reemplaza siempre la página que ingresó primero a memoria, sin considerar su uso futuro. Es decir, el criterio de decisión se basa únicamente en el orden de llegada de las páginas. Esto provoca que páginas que todavía serán utilizadas en el futuro puedan ser eliminadas, generando una mayor cantidad de fallos de página en comparación con otros algoritmos más eficientes. Durante la simulación FIFO se obtuvo un total de 9 fallos de página.

Durante la simulación FIFO, los marcos se llenan progresivamente hasta alcanzar el estado [1, 2, 3]. A partir de este punto, cuando ocurre una nueva referencia que no se encuentra en memoria, el algoritmo reemplaza la página más antigua en el sistema. Por ejemplo, al llegar la referencia 4, se elimina la página 1; posteriormente se siguen realizando reemplazos en función del orden de entrada, sin analizar la utilidad futura de las páginas.

Por otro lado, el algoritmo Óptimo (OPT) utiliza un enfoque diferente basado en el conocimiento completo de la secuencia futura de referencias. En cada fallo de página, el sistema analiza cuándo volverá a utilizarse cada página que se encuentra actualmente en memoria. La página que presenta el mayor tiempo hasta su próxima utilización, o que no volverá a utilizarse, es seleccionada como víctima de reemplazo.

En el caso de OPT, cuando la memoria se llena con [1, 2, 3], al llegar la referencia 4 el sistema analiza el futuro y determina que la página 3 es la que más tarda en volver a usarse, por lo que es reemplazada. Este proceso se repite en cada fallo de página, siempre seleccionando la página menos útil en el futuro. Como resultado, el algoritmo Óptimo genera un total de 7 fallos de página, lo que representa el mejor rendimiento posible para esta secuencia.

La diferencia principal entre ambos algoritmos radica en el criterio de reemplazo. FIFO se basa únicamente en el orden de llegada, mientras que OPT utiliza información futura para tomar decisiones más eficientes. Por esta razón, OPT presenta un menor número de fallos de página (7) en comparación con FIFO (9), demostrando un mejor rendimiento matemático.

Sin embargo, el algoritmo Óptimo presenta una limitación fundamental, ya que requiere conocer toda la secuencia futura de referencias de memoria. Esto no es posible en sistemas reales, debido a que los accesos a memoria son dinámicos, dependen del comportamiento del programa y del usuario, y no se pueden predecir con exactitud durante la ejecución.

En conclusión, aunque el algoritmo Óptimo es el más eficiente en términos teóricos con 7 fallos de página, FIFO es más simple y aplicable en sistemas reales, aunque genera 9 fallos de página en esta simulación. OPT se utiliza únicamente como referencia para medir la eficiencia de otros algoritmos de reemplazo.



## CONCLUSION DEL PROYECTO

El simulador desarrollado permite representar de manera práctica el funcionamiento de la Unidad de Administración de Memoria (MMU), integrando procesos de administración de memoria, traducción de direcciones y algoritmos de reemplazo de páginas. A través de su ejecución, se puede observar cómo las decisiones de gestión de memoria afectan directamente el rendimiento del sistema en términos de fallos de página.

La implementación de los algoritmos FIFO y Óptimo permite comparar dos enfoques distintos de reemplazo de páginas: uno basado en el orden de llegada y otro basado en información futura. Esta comparación demuestra la importancia de los algoritmos de gestión de memoria en el rendimiento de los sistemas operativos y evidencia las ventajas teóricas del algoritmo Óptimo frente a FIFO.

Sin embargo, también se concluye que, aunque el algoritmo Óptimo presenta el mejor rendimiento matemático, su uso es únicamente teórico debido a la imposibilidad de conocer el comportamiento futuro de los procesos en sistemas reales.
