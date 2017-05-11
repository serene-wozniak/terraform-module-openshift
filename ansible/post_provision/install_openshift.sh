#!/bin/bash

ansible-playbook -i /bootstrap/ansible/openshift-inventory  /opt/openshift-ansible/playbooks/byo/config.yml