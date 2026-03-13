# Cuando el ahorro sale del colchón: bancarización y acumulación de capital.

Este repositorio contiene el flujo de trabajo completo utilizado para el desarrollo del ejercicio “Hecho estilizado (2026-1) – Macroeconomía Avanzada de Largo Plazo”. La estructura del proyecto está organizada en seis subcarpetas (incluyendo una destinada a la carga de paquetes), las cuales cubren cada etapa del proceso de análisis: desde la descarga y carga de los datos, su procesamiento y construcción de variables, hasta la generación de tablas y visualizaciones utilizadas en el documento final.

Para replicar todos los resultados del proyecto, ejecute el script principal del repositorio denominado X, el cual reproduce de manera secuencial cada etapa del trabajo realizado.

<!---------------------------->

## Descripción de carpetas:
- 00_programs: carpeta que contiene los scripts donde se cargan y configuran los paquetes necesarios para la ejecución del proyecto.

- 01_data: carpeta que contiene los scripts encargados de descargar, cargar y almacenar las bases de datos utilizadas en el proyecto: Penn World Table (versión 11.0), Financial Access Survey (FAS) y Global Findex.

- 02_wrangle: carpeta que contiene los procesos de preparación y limpieza de datos. Incluye la selección de variables y países, la construcción de variables macroeconómicas y el cálculo de tasas de crecimiento geométricas.
  
- 03_main_results: carpeta que contiene los resultados principales del análisis, incluyendo el gráfico del hecho estilizado, las tablas de regresiones, las estimaciones con efectos fijos y el cálculo de participaciones utilizadas para motivar el hecho estilizado.

- 04_robustness: carpeta que contiene los ejercicios de robustez aplicados a los datos y a las estimaciones econométricas.

- 05_mechanisms: carpeta que contiene las estimaciones asociadas al análisis de mecanismos, incluyendo regresiones con efectos fijos que exploran los canales a través de los cuales opera el resultado principal.

<!---------------------------->

## Descripción de las subcarpetas:

-   01_input: contiene los insumos necesarios para cada tarea (bases de datos).
-   02_scripts: contiene los códigos utilizados en cada etapa del proceso (importación, contribución).
-   03_output: contiene los resultados generados a partir de la ejecución de los scripts (tablas procesadas, visualizaciones, gráficas).


<!---------------------------->

## Estructura Gráfica de Carpetas:

📂 01_data

├── 📂 01_input

├── 📂 02_scripts

└── 📂 03_output

📂 02_contribution

├── 📂 02_scripts

└── 📂 03_output
