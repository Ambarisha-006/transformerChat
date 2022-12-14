#!/usr/bin/env ruby
require 'mechanize'
vars = ARGV
username = vars[0]
password = vars[1]
target_name = vars[2]
concourse_url = vars[3]
team = vars[4]

def web_login(username, password, target)
  agent = Mechanize.new
  page = agent.get(target)
  login_form = page.form
  login_form.field_with(:name => 'username').value = username
  login_form.field_with(:name => 'password' ).value = password
  output = login_form.click_button.body
  if output.include?('success')
    puts 'login successful.'
  else
    puts 'login failed.'
  end
end
def login(username, password, target_name, concourse_url, team)
  command = "fly --target #{target_name} login --team-name #{team} --concourse-url #{concourse_url}"
  IO.popen(command, "r+") do |pipe|
    begin
    concourse_login_url = pipe.gets.gsub(/\s+/, "")
    end until concourse_login_url.include?(concourse_url)
    print "Attempting login to #{concourse_login_url}: "
    web_login(username, password, concourse_login_url)
  end
end

login(username, password, target_name, concourse_url, team)