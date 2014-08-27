# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

$env = YAML::load_file('devstacked-hosts.yml')

Vagrant.configure('2') do |config|
    # Create and provision each host as defined devstacked-hosts.yml
    $env['hosts'].each do |host_name, host_config|
        config.vm.define host_name do |host|
            host.vm.box = 'hashicorp/precise64'
            host.vm.synced_folder './', '/vagrant', :disabled => true
            host.vm.synced_folder './repos', '/repos', :disabled => false
            host.vm.network 'private_network', :ip => host_config['private_ip']
            host.vm.host_name = "#{host_name}.local"

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
