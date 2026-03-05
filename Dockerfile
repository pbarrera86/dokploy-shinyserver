FROM rocker/shiny:4.4.2

# --- System deps needed by your R code:
# - Postgres (RPostgres/DBI/pool)
# - SSL/HTTP (httr/curl)
# - XML/HTML parsing (xml2/rvest)
# - Graphics stack (bslib/thematic + potential rmarkdown/plots)
# - Sodium (password hashing)
# - ICU + X11 (common runtime deps in Shiny/HTML widgets)
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
    libsodium-dev \
    libicu-dev \
    libxt6 \
    pkg-config \
    build-essential \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Optional cache busting (force rebuild when you change it)
ARG CACHEBUST=20260305_01
RUN echo "cachebust=$CACHEBUST"

# Install only what your app loads/uses (plus deps)
RUN R -q -e "install.packages('remotes', repos='https://cloud.r-project.org')" \
 && R -q -e "install.packages(c( \
      'shiny','shinyWidgets','shinyjs','DT', \
      'bslib','thematic', \
      'dplyr','jsonlite','lubridate','httr', \
      'pool','DBI','RPostgres', \
      'yaml','emayili', \
      'sodium', \
      'future','furrr', \
      'purrr','tidyr','tibble','stringr', \
      'xml2','rvest', \
      'quantmod','TTR', \
      'openxlsx', \
      'markdown','rmarkdown', \
      'sandwich','lmtest' \
    ), repos='https://cloud.r-project.org', Ncpus=parallel::detectCores())"

# ---- Deploy app to Shiny Server standard directory:
# The URL /pugaxtrade will map to this folder by default in shiny-server.
WORKDIR /srv/shiny-server
RUN mkdir -p /srv/shiny-server/pugaxtrade

# Copy your app repo content into /srv/shiny-server/pugaxtrade
# (Assumes your Docker build context includes app.R and R/ folder, etc.)
COPY . /srv/shiny-server/pugaxtrade

# Permissions (Shiny runs as user 'shiny' in rocker/shiny images)
RUN chown -R shiny:shiny /srv/shiny-server/pugaxtrade \
 && chmod -R 755 /srv/shiny-server/pugaxtrade

# Helpful build marker
RUN echo "CUSTOM_IMAGE_OK - built on $(date -u)" > /usr/local/share/custom_image_ok.txt

EXPOSE 3838
