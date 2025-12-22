FROM rocker/shiny:4.4.2

# Dependencias del sistema para RPostgres, httr, SSL, etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala paquetes R requeridos por tu app
ARG CACHEBUST=20251222_01
RUN R -q -e "install.packages(c('shiny','shinyWidgets','shinyjs','DT','dplyr','DBI','RPostgres','jsonlite','lubridate','httr','tidyquant','tidyverse','emayili'), repos='https://cloud.r-project.org')"
RUN echo "CUSTOM_IMAGE_OK - built on $(date -u)" > /usr/local/share/custom_image_ok.txt
