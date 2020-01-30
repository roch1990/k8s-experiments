#Vagrantfile

NAGENT = 2
NSERVER = 1

Vagrant.configure(2) do |config|


  (1..NAGENT).each do |i|
    config.vm.define "agent-#{i}" do |node|
      node.vm.box = 'centos/7'
      node.vm.hostname = "agent-#{i}"

      # BRIDGE
      node.vm.network 'private_network', ip: "192.168.0.#{i + 9}"

      # Expose nomad web
      # config.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true

      node.vm.provider :libvirt do |v|
        v.cpus = 2
        v.memory = 512
      end

      # provision only when all nodes started
      if i == NAGENT
        node.vm.provision 'ansible' do |ansible|
          ansible.limit = "all"
          ansible.playbook = 'ansible/bootstrap.yml'
        end
      end
    end
  end

  (1..NSERVER).each do |i|
    config.vm.define "server-#{i}" do |node|
      node.vm.box = 'centos/7'
      node.vm.hostname = "server-#{i}"

      # BRIDGE
      node.vm.network 'private_network', ip: "192.168.0.#{i + 10}"

      # Expose nomad web
      # config.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true
      # config.vm.network "forwarded_port", guest: 8500, host: 8500, auto_correct: true
      # config.vm.network "forwarded_port", guest: 8080, host: 8080, auto_correct: true

      node.vm.provider :libvirt do |v|
        v.cpus = 2
        v.memory = 512
      end

      # provision only when all nodes started
      if i == NSERVER
        node.vm.provision 'ansible' do |ansible|
          ansible.limit = "all"
          ansible.playbook = 'ansible/bootstrap.yml'
        end
      end
    end
  end

end