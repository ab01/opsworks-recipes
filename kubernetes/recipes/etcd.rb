bash 'install_etcd' do
  user 'root'
  cwd '/tmp'
  code <<-EOH
  if [ ! -f /usr/local/bin/etcd ]; then
    yum install wget -y
	wget --max-redirect 255 https://github.com/coreos/etcd/releases/download/v3.3.0/etcd-v3.3.0-linux-amd64.tar.gz
    tar zxvf etcd-v3.3.0-linux-amd64.tar.gz
    cd etcd-v3.3.0-linux-amd64
    cp etcd etcdctl /usr/local/bin
  fi
  EOH
end


template "/etc/init.d/etcd" do
	mode "0755"
	owner "root"
	source "etcd.erb"
end

service "etcd" do
	action [:enable, :start]
	subscribes :reload, "template[/etc/init.d/etcd]", :immediately
	subscribes :reload, "template[/root/etcd_enable_ba.sh]", :immediately	
end

