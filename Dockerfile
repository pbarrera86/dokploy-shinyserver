FROM rocker/shiny:4.4.2

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libcairo2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    pkg-config \
    libsodium-dev \
    build-essential \
    libicu-dev \
    libxt6 \
    git \
    && rm -rf /var/lib/apt/lists/*

ARG CACHEBUST=20251223_07
RUN echo "cachebust=$CACHEBUST"

RUN R -q -e "install.packages(c( \
  'shiny','shinyWidgets','shinyjs','DT','bslib','thematic', \
  'markdown','rmarkdown', \
  'tidyverse','tidyquant', \
  'jsonlite','yaml','lubridate','config', \
  'httr','xml2','rvest', \
  'openxlsx', \
  'DBI','RPostgres','pool', \
  'emayili','sodium','sandwich','lmtest' \
), repos='https://cloud.r-project.org', Ncpus=parallel::detectCores())"

RUN echo "CUSTOM_IMAGE_OK - built on $(date -u)" > /usr/local/share/custom_image_ok.txt
