#!/bin/bash
ansible-playbook config-1-playbook.yml -e \
    "mysql_master=mysql-petclinic-slave \
    mysql_master_port=30703 \
    rest_write=nginx-load-balancer \
    rest_write_port=7776 \
    angular=spring-petclinic-angular \
    angular_port=8998"
