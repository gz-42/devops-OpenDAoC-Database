# ---- build ----
# Use the official latest ubuntu image as the build environment
FROM ubuntu:latest AS build
LABEL stage=build

# Copy the source code to the build container
COPY . .

# Combine the SQL files
WORKDIR /opendaoc-db-core
RUN cat *.sql > opendaoc-db-core.sql

# ---- final ----
# Use the official mariadb 10.6 image as the base for the final image
FROM mariadb:10.6 AS final
LABEL stage=final

# Copy the opendaoc-db-core.sql file from the build stage
COPY --from=build /opendaoc-db-core/opendaoc-db-core.sql /docker-entrypoint-initdb.d/opendaoc-db-core.sql

# Create database
ENV MARIADB_DATABASE="opendaoc"
