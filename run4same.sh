#!/bin/bash
ansible-playbook config-4-playbook.yml -e \
    "mysql_master=spring-petclinic-angular \
    mysql_master_port=30703 \
    mysql_slave=spring-petclinic-angular \
    mysql_slave_port=30704 \
    rest_write=spring-petclinic-angular \
    rest_write_port=7776 \
    rest_read=spring-petclinic-angular \
    rest_read_port=7775 \
    load_balancer=spring-petclinic-angular \
    load_balancer_port=8008
    angular=spring-petclinic-angular \
    angular_port=8998"
