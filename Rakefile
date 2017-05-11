#!/usr/bin/env ruby -wKU
#Author zcq100 m@zcq100.com
require './dnspod.rb'

desc "info"
task "info" do 
	p token
end

desc "Show local IP"
task :ip do
	p "Your IP is #{local_ip}"
end

desc "Get all domain infomantion"
task "list" do 
	domainlist=domains
	domainlist["domains"].each{|domain|
		 recorderlist=records(domain["id"])
		 p ""
		 p "域名:#{domain["name"]}"
		 p "子域名#{domain["records"].length}个:"
		 p "类型".ljust(10)+"域名".ljust(60)+"值".ljust(60)+"线路"
		p "-".ljust(140,"-")
		recorderlist.each{|x|p x["type"].ljust(10)+x["name"]+"."+domain["name"].ljust(60)+x["value"].ljust(60)+x["line"]}
	}
end

desc "Check domain change"
task "check" do
	target=config["sub1"]
	puts "check #{target}"
	record=find_record(target)
	if record.nil?
		p "没找到域名#{target}"
	else
		localip=local_ip
		bindip=record["value"]
		p "域名#{target} 绑定ip:#{bindip}------> 本地ip#{localip}"
		p "域名没有改变...."
	end
end

desc "Create record "
task "create" do
	#todo
end

desc "Update domain bind IP"
task "update" do 
	update_domain config["sub1"],local_ip
end	

#Test
task :test do
	p fetch("/Record.List",{:domain=>"zcq100.com"})
end

desc "Delete record"
task "delete" =>[:check] do 
	p "delete..."
	#todo
end

