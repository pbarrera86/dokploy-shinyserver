FROM rocker/shiny:4.4.2

# Dependencias del sistema para RPostgres, httr, SSL, etc.
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Instala paquetes R requeridos por tu app
RUN R -q -e "install.packages(c('shiny','shinyWidgets','shinyjs','DT','dplyr','DBI','RPostgres','jsonlite','lubridate','httr'), repos='https://cloud.r-project.org')"
