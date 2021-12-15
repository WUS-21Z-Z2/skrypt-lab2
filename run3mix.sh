#!/bin/bash
ansible-playbook config-3-playbook.yml -e \
    "mysql_master=mysql-petclinic-slave \
    mysql_master_port=30703 \
    mysql_slave=mysql-petclinic-slave \
    mysql_slave_port=30704 \
    rest_write=nginx-load-balancer \
    rest_write_port=7776 \
    angular=spring-petclinic-angular \
    angular_port=8998"
