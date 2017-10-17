#!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i /bootstrap/ansible/openshift-inventory  /opt/openshift-ansible/PRE_INSTALLATION/giffgaff_openshift_requirements.yml

ansible-playbook -i /bootstrap/ansible/openshift-inventory  /opt/openshift-ansible/playbooks/byo/openshift_facts.yml

ansible-playbook -i /bootstrap/ansible/openshift-inventory  /opt/openshift-ansible/playbooks/byo/config.yml

ansible-playbook -i /bootstrap/ansible/openshift-inventory /opt/openshift-ansible/POST_INSTALLATION/openshift_giffgaff.yml