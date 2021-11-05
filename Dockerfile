FROM hashicorp/terraform:latest

WORKDIR /opt
ADD main.tf /opt/

EXPOSE 8080

ENTRYPOINT ["terraform"]