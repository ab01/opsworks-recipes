include_recipe 'kubernetes::kubernetes-node-setup'

service "flanneld" do
	action :start
	notifies :run, 'bash[wait_flanneld]', :immediately
end

bash 'wait_flanneld' do
	user 'root'
	code <<-EOH
	tries=0
        while [ ! -f /run/flannel/subnet.env -a $tries -lt 10 ]; do
            sleep 1
            tries=$((tries + 1))
        done
	EOH

	action :nothing
	notifies :start, 'service[start-docker]', :immediately
end

service "start-docker" do
	service_name 'docker'
	action :nothing
	notifies :start, 'service[start-kubernetes-node]', :immediately
end

service "start-kubernetes-node" do
	service_name 'kubernetes-node'
	action :nothing
end
