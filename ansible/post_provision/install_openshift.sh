#!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i /bootstrap/ansible/openshift-inventory  /opt/openshift-ansible/playbooks/byo/config.yml

