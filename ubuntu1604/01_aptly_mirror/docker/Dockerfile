FROM ubuntu:16.04
MAINTAINER daniel.barragan@correo.icesi.edu.co

ADD config/my_key_notpassphrase.pub /tmp

# Configure repository 
RUN apt-key add /tmp/my_key_notpassphrase.pub && \
    rm -f /tmp/my_key_notpassphrase.pub && \
    echo "deb http://192.168.33.10:8080/ xenial main" > /etc/apt/sources.list && \
    chmod 777 /tmp

# Install packages
RUN apt-get clean && \
    apt-get update -y && \
    apt-get install python3 -y

EXPOSE 5000

CMD python3 -m http.server 5000 
