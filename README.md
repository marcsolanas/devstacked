devstacked
==========

A configurable DevStack environment using Vagrant and Ansible. Very much a 
work in progress at this point.

To get started, simply have Vagrant and Ansible installed and run _vagrant up_ 
from the project root directory.

Local Configuration via vars/local.yml
-------------------------------------

__Enabling Programs__

Supported optional programs can be enabled by setting the appropriate 
variables.

    enable_neutron: true 

__Repository Overrides__

Alternate repositories can be configured by adding entries to
repository_overrides. If checked out locally in the "repos" directory, they
can be made accessible to devstack via a file:// reference

    repository_overrides:
        - { name: "nova", repo: "https://github.com/openstack/nova.git", branch: "master" }
        - { name: "neutron", repo: "file:////repos/neutron", branch: "master" }
