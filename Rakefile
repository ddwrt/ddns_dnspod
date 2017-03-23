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

desc "get all domain infomantion"
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
	if record.nil
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
	target=config["sub1"]
	name=name=target[0,target.index(".")]
	domain=target[4+1,target.length]
	tmp=find_record(target)
	record_id=tmp["id"]
	localip=local_ip
	if localip==tmp["value"]
	 p "ip没有不改变，不更新 "
	else
	 msg=fetch("/Record.Ddns",{:domain=>domain,:record_id=>record_id,:record_line_id=>"10=0",:record_type=>"A",:value=>local_ip,:sub_domain=>name})
	 p "#{msg['status']['code']}  #{msg['status']['message']}"
	end
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

