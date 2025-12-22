FROM rocker/shiny:4.4.2

# Dependencias del sistema para RPostgres, httr, SSL, tidyverse (xml2/ragg/rvest), etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    \
    # xml2 / rvest
    libxml2-dev \
    \
    # ragg (rendering) y otras deps típicas de tidyverse
    libcairo2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Instala paquetes R requeridos por tu app
ARG CACHEBUST=20251222_01

# (Opcional pero recomendable) asegura herramientas de compilación
# Si te llega a fallar algo compilando, descomenta estas 2 líneas:
# RUN apt-get update && apt-get install -y --no-install-recommends build-essential \
#     && rm -rf /var/lib/apt/lists/*

RUN R -q -e "install.packages(c( \
  'shiny','shinyWidgets','shinyjs','DT','dplyr','DBI','RPostgres','jsonlite','lubridate','httr', \
  'tidyquant','xml2','ragg','rvest','tidyverse','emayili' \
), repos='https://cloud.r-project.org')"

RUN echo "CUSTOM_IMAGE_OK - built on $(date -u)" > /usr/local/share/custom_image_ok.txt
