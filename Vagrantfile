Vagrant.configure("2") do |config|
		config.vm.box = "centos65_virtualbox_50G.box"

	config.vm.provider :virtualbox do |v, override|
		override.vm.box_url = "https://googledrive.com/host/0B4tZlTbOXHYWVGpHRWZuTThGVUE/centos65_virtualbox_50G.box"
		v.customize ["modifyvm", :id, "--memory", "1024"]
		v.customize ["modifyvm", :id, "--vram", "16"]
	end
  
	config.vm.define :smdw do |smdw_config|
		smdw_config.vm.network :private_network, ip: "172.16.1.14"
		smdw_config.vm.hostname = "smdw"
		smdw_config.vm.provision :shell, :path => "install_applications.sh"
		smdw_config.vm.provision :shell, :path => "setup_host.sh"
		smdw_config.vm.provision :shell, :path => "unmount_vagrant.sh"
	end
  
	config.vm.define :sdw1 do |sdw1_config|
		sdw1_config.vm.network :private_network, ip: "172.16.1.12"
		sdw1_config.vm.hostname = "sdw1"
		sdw1_config.vm.provision :shell, :path => "install_applications.sh"
		sdw1_config.vm.provision :shell, :path => "setup_host.sh"
		sdw1_config.vm.provision :shell, :path => "install_lab_data_on_sdw1.sh"
		sdw1_config.vm.provision :shell, :path => "unmount_vagrant.sh"
	end
  
	config.vm.define :sdw2 do |sdw2_config|
		sdw2_config.vm.network :private_network, ip: "172.16.1.13"
		sdw2_config.vm.hostname = "sdw2"
		sdw2_config.vm.provision :shell, :path => "install_applications.sh"
		sdw2_config.vm.provision :shell, :path => "setup_host.sh"
		sdw2_config.vm.provision :shell, :path => "unmount_vagrant.sh"
	end

	config.vm.define :mdw do |mdw_config|
		mdw_config.vm.provider :virtualbox do |v3|
			v3.customize ["modifyvm", :id, "--memory", "4096"]
		end
		mdw_config.vm.network :private_network, ip: "172.16.1.11"
		mdw_config.vm.network "forwarded_port", guest: 5432, host: 5433
		mdw_config.vm.hostname = "mdw"
		mdw_config.vm.provision :shell, :path => "install_applications.sh"
		mdw_config.vm.provision :shell, :path => "setup_host.sh"
		mdw_config.vm.provision :shell, :path => "setup_master.sh"
		mdw_config.vm.provision :shell, :path => "change_password.sh"
		mdw_config.vm.provision :shell, :path => "install_lab_data_on_mdw.sh"
		mdw_config.vm.provision :shell, :path => "install_gpdb_and_gpcc_on_mdw.sh"
		mdw_config.vm.provision :shell, :path => "install_gpdb_on_segments.sh"
		mdw_config.vm.provision :shell, :path => "run_system_verification_tests.sh"
		mdw_config.vm.provision :shell, :path => "initialize_gpdb.sh"
		mdw_config.vm.provision :shell, :path => "initialize_gpcc.sh"
		mdw_config.vm.provision :shell, :path => "unmount_vagrant.sh"
	end
end