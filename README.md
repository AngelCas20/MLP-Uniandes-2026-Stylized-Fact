# Es todo lo que es, un acto de fe: Un modelo sobre decisiones de ahorro y bancarización.

Este repositorio contiene el flujo de trabajo completo utilizado para el desarrollo del ejercicio “Hecho estilizado (2026-1) – Macroeconomía Avanzada de Largo Plazo”. La estructura del proyecto está organizada en seis subcarpetas (incluyendo una destinada a la carga de paquetes), las cuales cubren cada etapa del proceso del trabajo: desde la descarga y carga de los datos, su procesamiento y construcción de variables, hasta la generación de tablas y visualizaciones utilizadas en el documento final.

Para replicar todos los resultados del proyecto, ejecute el script principal del repositorio denominado 00_automatizacion.R, el cual reproduce de manera secuencial cada etapa del trabajo realizado.

Nota: asegurese de estar debtri del .Rproj antes de ejecutar los códigos, dado el caso de trabajar en [RStudio](https://posit.co/downloads/).
<!---------------------------->

## Descripción de carpetas:
- 00_programs: carpeta que contiene los scripts donde se cargan y configuran los paquetes necesarios para la ejecución del proyecto.

- 01_data: carpeta que contiene los scripts encargados de descargar, cargar y almacenar las bases de datos utilizadas en el proyecto: Penn World Table (versión 11.0), Financial Access Survey (FAS) y Global Findex.

- 02_wrangle: carpeta que contiene los procesos de preparación y limpieza de datos. Incluye la selección de variables y países, la construcción de variables macroeconómicas y el cálculo de tasas de crecimiento geométricas.
  
- 03_main_regression: carpeta que contiene las estimaciones principales presentadas en el documento, así como las estimaciones del apéndice.
  
- 04_mechanisms: carpeta que contiene las estimaciones econométricas de los mecanismos por las cuales se transmite el hecho estilizado.
  
- 05_visuals: carpeta que contiene todas las tablas de regresión y gráficos mostrados en el documento.

<!---------------------------->

## Descripción de las subcarpetas:

- 01_input: contiene los insumos necesarios para el desarrollo del proyecto, principalmente las bases de datos utilizadas en las diferentes etapas del trabajo.

- 02_code: contiene los scripts utilizados en cada etapa del proceso, incluyendo la importación, procesamiento y transformación de los datos, así como la generación de resultados.

- 03_output: contiene los resultados generados a partir de la ejecución de los scripts, tales como tablas procesadas, visualizaciones y gráficas utilizadas en el documento.

<!---------------------------->

## Estructura Gráfica de Carpetas:

📂 00_programs

├── 📄 00_packages.R

└── 📄 00_themes.R

📂 01_data

├── 📂 input

├── 📂 code

└── 📂 output

📂 02_wrangle

├── 📂 code

└── 📂 output

📂 03_main_regression

├── 📂 code

└── 📂 output

📂 04_mechanisms

├── 📂 code

└── 📂 output

📂 05_visuals

├── 📂 code

└── 📂 output
