# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jtsang <marvin@42.fr>                      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/02/08 08:44:21 by jtsang            #+#    #+#              #
#    Updated: 2020/02/10 14:41:16 by jtsang           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM debian:buster
MAINTAINER <jtsang@student.42.fr>

RUN apt-get update
RUN apt-get install -y wget libnss3-tools nginx mariadb-server
RUN apt-get install -y php php-common php-cli php-mysql php-curl php-gd php-intl php-fpm

COPY ./srcs/start.sh ./
COPY ./srcs/nginx-config ./tmp/nginx-config
COPY ./srcs/phpmyadmin.inc.php ./tmp/phpmyadmin.inc.php
COPY ./srcs/wp-config.php ./tmp/wp-config.php

CMD bash start.sh && tail -f /dev/null
