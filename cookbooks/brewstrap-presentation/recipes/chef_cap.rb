include_recipe "brewstrap-presentation::virtualbox"

execute "verify we are ready to setup the virtualbox" do
  command "test -e #{node[:home]}/workspace/chef_cap-example/Gemfile"
end

execute "install gemset for chef_cap-example" do
  cwd "#{node[:home]}/workspace/chef_cap-example/"
  command "gem install bundler && bundle --without production"
  user node[:user]
end


execute "download vagrant box" do
  not_if "bundle exec vagrant box list | grep lucid32", :cwd => "#{node[:home]}/workspace/chef_cap-example/"

  cwd "#{node[:home]}/workspace/chef_cap-example/"
  command "bundle exec vagrant box add lucid32 http://files.vagrantup.com/lucid32.box"
  user node[:user]
end

execute "init vagrant box" do
  not_if "test -e #{node[:home]}/workspace/chef_cap-example/Vagrantfile"

  cwd "#{node[:home]}/workspace/chef_cap-example/"
  command "bundle exec vagrant init lucid32"
  user node[:user]
end

execute "start vagrant box" do
  not_if "VBoxManage list runningvms | grep chef_cap-example", :cwd => "#{node[:home]}/workspace/chef_cap-example/"

  cwd "#{node[:home]}/workspace/chef_cap-example/"
  command "bundle exec vagrant up"
  user node[:user]
end

execute "update .ssh/config with vagrant box configuration" do
  not_if "cat #{node[:home]}/.ssh/config | grep lucid32"
  
  cwd "#{node[:home]}/workspace/chef_cap-example/"
  command "mkdir -p #{node[:home]}/.ssh && touch #{node[:home]}/.ssh/config && bundle exec vagrant ssh-config | sed -e 's@Host default@Host lucid32@' >> #{node[:home]}/.ssh/config"
  user node[:user]
end

execute "kickoff a chef_cap deployment" do
  cwd "#{node[:home]}/workspace/chef_cap-example/"
  command "bundle exec cap demo deploy"
  user node[:user]
end  