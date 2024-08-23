FROM openjdk:17-jdk-slim-buster


EXPOSE 10389

RUN apt-get update && \
    apt-get install -y openssl wget
RUN mkdir /ldap
WORKDIR /ldap
RUN wget https://github.com/kwart/ldap-server/releases/download/2016-10-04/ldap-server.jar

COPY users.ldif /ldap/users.ldif

CMD ["java","-jar","ldap-server.jar", "users.ldif"]