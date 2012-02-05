# Not neccesary but forces an explicit dependency in case the run_list does not have it correct.
include_recipe "pivotal_workstation::git_projects"

execute "mark-presentation-as-opened" do
  action :nothing
  command "touch /tmp/.brewstrap-presentation-opened"
  user node[:user]
end

execute "open up the presentation if it is available" do
  only_if { 
    File.exist?("#{node[:home]}/workspace/presentation-teaching_your_team_chef/index.html") &&
    !File.exist?("/tmp/.brewstrap-presentation-opened")
  }
  command "open #{node[:home]}/workspace/presentation-teaching_your_team_chef/index.html"
  user node[:user]
  notifies :run, "execute[mark-presentation-as-opened]", :immediately
end

execute "make safari full screen for presentation" do
  only_if { 
    File.exist?("#{node[:home]}/workspace/presentation-teaching_your_team_chef/index.html") &&
    !File.exist?("/tmp/.brewstrap-presentation-opened")
  }
  ignore_failure
  applescript <<-APPLESCRIPT
tell application "Safari"
  activate
  tell application "System Events" to tell window 1 of application process "Safari"
    click (every button whose description contains "full screen")
  end tell
end tell
  APPLESCRIPT
end
