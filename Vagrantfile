# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'fileutils'

$env = YAML::load_file('devstacked-hosts.yml')

# Create the local.yml variables file if not already present
unless File.exist?('vars/local.yml')
    FileUtils.mkpath('vars')
    FileUtils.touch('vars/local.yml')
end

Vagrant.configure('2') do |config|
    # Create and provision each host as defined devstacked-hosts.yml
    $env['hosts'].each do |host_name, host_config|
        config.vm.define host_name do |host|
            host.vm.box = 'hashicorp/precise64'

            # Packer
            # host.vm.box = 'devstacked-ubuntu-14.04'
            # host.vm.box_url = './packer/builds/virtualbox/devstacked-ubuntu-14.04.box'
            # host.vm.provider 'vmware_fusion' do |v, override|
            #     override.vm.box_url = './packer/builds/vmware/devstacked-ubuntu-14.04.box'
            # end

            host.vm.network 'private_network', :ip => host_config['private_ip']
            host.vm.host_name = "#{host_name}.local"

            host.vm.synced_folder './', '/vagrant', :disabled => true
            host.vm.synced_folder './repos', '/repos', :disabled => false

            if host_config['ports']
                host_config['ports'].each do |port|
                    host.vm.network 'forwarded_port', :guest => port['guest'],
                                    :host => port['host']
                end
            end

            # VirtualBox config
            host.vm.provider :virtualbox do |vbox|
                if host_config['memory']
                    vbox.customize ['modifyvm', :id, '--memory',
                                    host_config['memory']]
                end
                vbox.customize ['modifyvm', :id, '--usb', 'off']
            end

            # VMware config
            host.vm.provider :vmware_fusion do |vmware|
                if host_config['memory']
                    vmware.vmx['memsize'] = host_config['memory']
                end
                vmware.vmx['numvcpus'] = '1'
                vmware.vmx['virtualHW.version'] = '10'
                vmware.vmx['vhv.enable'] = 'TRUE'
                vmware.gui = false
            end

            # Ansible provisioning using the generated host based inventory
            host.vm.provision 'ansible' do |ansible|
                ansible.playbook = 'devstacked-playbook.yml'
            end
        end
    end
end
