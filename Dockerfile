FROM debian:buster

RUN apt-get -y update && apt-get -y install mariadb-server nginx \
			wget libnss3-tools \
			php php-cli php-cgi php-mbstring php-fpm php-mysql

COPY srcs ./root/

EXPOSE 80 443

WORKDIR /root/

ENTRYPOINT ["bash", "start.sh"]
