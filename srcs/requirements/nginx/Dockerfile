ARG VERSION_ALPINE

FROM alpine:${VERSION_ALPINE}

RUN apk update && \
    yes | apk add --no-cache nginx openssl && \
    mkdir -p /etc/nginx/ssl /var/www/html/wordpress && \
    openssl req -x509 -newkey rsa:4096 -nodes \
            -keyout /etc/nginx/ssl/cudoh.key \
            -out /etc/nginx/ssl/cudoh.crt\
            -sha256 -days 90 \
            -subj "/C=DE/ST=Hessen/L=Frankfurt/O=42/OU=cudoh/CN=cudoh.42.fr"

COPY ./conf/default.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
