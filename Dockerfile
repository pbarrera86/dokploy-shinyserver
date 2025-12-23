FROM rocker/shiny:4.4.2

# Dependencias del sistema (Postgres + SSL/HTTP + xml2/rvest + render + sodium + toolchain)
RUN apt-get update && apt-get install -y --no-install-recommends \
    # DB / SSL / HTTP
    libpq-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    \
    # xml2 / rvest
    libxml2-dev \
    \
    # ragg / render (útil si en algún punto entra tidyverse/ggplot/rmarkdown)
    libcairo2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    pkg-config \
    \
    # sodium
    libsodium-dev \
    \
    # compilar paquetes R
    build-essential \
    && rm -rf /var/lib/apt/lists/*

ARG CACHEBUST=20251223_05

# Paquetes R (union de todo lo que tus apps han pedido)
RUN R -q -e "install.packages(c( \
  # shiny + UI
  'shiny','shinyWidgets','shinyjs','DT','bslib','thematic', \
  \
  # data core
  'dplyr','purrr','tidyr','tibble','stringr','jsonlite','yaml','lubridate', \
  \
  # web/scraping
  'httr','xml2','rvest', \
  \
  # finanzas
  'quantmod','TTR','tidyquant','tidyverse', \
  \
  # excel
  'openxlsx', \
  \
  # DB
  'DBI','RPostgres','pool', \
  \
  # email / crypto / stats
  'emayili','sodium','sandwich','lmtest' \
), repos='https://cloud.r-project.org')"

RUN echo "CUSTOM_IMAGE_OK - built on $(date -u)" > /usr/local/share/custom_image_ok.txt
