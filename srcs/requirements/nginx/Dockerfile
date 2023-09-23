ARG VERSION_ALPINE

FROM alpine:${VERSION_ALPINE}

RUN apk update && \
    yes | apk add --no-cache nginx openssl && \
    mkdir -p /etc/nginx/ssl /var/www/html/wordpress && \
    openssl req -x509 -newkey rsa:4096 -nodes \
            -keyout /etc/nginx/ssl/pmeising.key \
            -out /etc/nginx/ssl/pmeising.crt\
            -sha256 -days 10 \
            -subj "/C=DE/ST=Schleswig-Holstein/L=Kiel/O=42/OU=pmeising/CN=pmeising.42.fr"
# C -> Country, ST -> State, L -> Locality, O -> Organization, OU -> Organizational Unit, CN -> Common name (specifies hostname for which the cert is valid)

COPY ./conf/default.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
