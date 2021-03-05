# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vagrant.plugins = %w(vagrant-vbguest)
  config.vbguest.auto_update = false
  config.vm.define "base-box" do |b|
    b.vm.hostname = "base-box"
    b.vm.box = "ubuntu/focal64"
    b.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    b.vm.network "private_network", ip: '198.18.0.2', netmask: '255.255.255.0', name: 'vboxnet7'
    b.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 4
    end
    config.vm.provision "docker" do |d|
      d.pull_images "alpine"
    end
    b.vm.provision :shell, privileged: true, inline: <<-SHELL
        if [ ! -f /once ]; then
            sed -i '/security.ubuntu.com\\/ubuntu/d' /etc/apt/sources.list
            echo 'APT::Periodic::Update-Package-Lists "0";
            APT::Periodic::Download-Upgradeable-Packages "0";
            APT::Periodic::AutocleanInterval "0";' > /etc/apt/apt.conf.d/10periodic
            echo 'APT::Periodic::Update-Package-Lists "0";
            APT::Periodic::Unattended-Upgrade "0";' > /etc/apt/apt.conf.d/20auto-upgrades
            apt-get remove -y unattended-upgrades || true
            swapoff -a
            sed -i '/swap/d' /etc/fstab
            sed -i /pam_motd.so/d /etc/pam.d/sshd

            apt-get update && apt-get install -y \
                eatmydata curl jq nginx supervisor wget \
                net-tools awscli parallel

            for S in supervisor nginx; do
                systemctl stop $S
                systemctl disable $S
            done

            wget -O /usr/local/sbin/minio https://dl.min.io/server/minio/release/linux-amd64/minio
            wget -O /usr/local/sbin/mc    https://dl.min.io/client/mc/release/linux-amd64/mc
            chmod +x /usr/local/sbin/minio /usr/local/sbin/mc
        fi
    SHELL
    b.vm.provision :shell, privileged: false, inline: <<-SHELL
        curl -L https://nixos.org/nix/install | sh
        echo '
            source /home/vagrant/.nix-profile/etc/profile.d/nix.sh
            export PATH=/vagrant/bin:$PATH
        ' >  ~/.bash_aliases

        mkdir -p ~/run
        mkdir -p ~/.aws && chmod 700 ~/.aws
        ln -s -f /vagrant/dot-aws-config ~/.aws/config
    SHELL

  end

end
