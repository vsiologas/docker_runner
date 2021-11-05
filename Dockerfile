FROM hashicorp/terraform:latest

WORKDIR /opt
ADD init.tf /opt/
RUN terraform init

EXPOSE 8080

ENTRYPOINT ["terraform"]