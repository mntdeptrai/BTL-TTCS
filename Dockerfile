FROM mcr.microsoft.com/mssql/server:2019-latest

# Chuyển sang root để cài đặt gói
USER root

# Cài đặt mssql-tools và phụ thuộc
RUN apt-get update && apt-get install -y curl gnupg2 apt-transport-https
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev

# Chuyển lại về user mssql
USER mssql

# Đảm bảo PATH
ENV PATH="$PATH:/opt/mssql-tools/bin"