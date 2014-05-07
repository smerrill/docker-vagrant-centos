## vagrant-centos

This is a _monolithic_ Docker image (e.g. it runs /sbin/init) that runs sshd.
Because of this, it is possible to use all Vagrant provisioners with it.

### Sample Vagrantfile

    Vagrant.configure("2") do |config|
      config.vm.provider "docker" do |d, override|
        d.image = "smerrill/vagrant-centos"
        d.has_ssh = true
    
        # This is needed if you have non-Docker provisioners in the Vagrantfile.
        override.vm.box = nil
      end
    end
