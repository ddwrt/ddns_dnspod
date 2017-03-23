#!/usr/bin/env ruby -wKU
#Author zcq100 m@zcq100.com
require "net/http"
require "uri"
require "open-uri"
require "yaml"
require "json"

desc "info"
task "info" do 
	p token
end

desc "My IP"
task :ip do
	p "Your IP is #{local_ip}"
end


desc "get Domain list and Record list"
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

desc "check domain change"
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

desc "create domain "
task "create" do
	#todo
end

desc "update domain ip"
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

task :test do
	p fetch("/Record.List",{:domain=>"zcq100.com"})
end

desc "delete domain ip"
task "delete" =>[:check] do 
	p "delete..."
	#todo
end

private 

def local_ip
	ip="0.0.0.0"
	open("http://1212.ip138.com/ic.asp") do |f| 
		str=f.read
		ip= str.scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/).first
	end
end

def config
	YAML.load(File.open("dnspod.yaml"))
end

def domains
	fetch("/Domain.List")
end


def records domain_id=nil?,domain_name=nil?
	list=[]
	if domain_id.nil?&&domain_name==nil?
		domains["records"].each{|x|records :domain_id=>x["id"]}
	elsif !domain_id.nil?
		tmp=fetch("/Record.List",{:domain_id=>domain_id}) 
		tmp["records"].each{|x|list<<x}
	elsif !domain_name.nil?
		tmp=fetch("/Record.List",{:domain=>domain_name})
		tmp["records"].each{|x|list<<x}
	end
end


#Find DomainInfo By subdomain
def find_record subdomain
	domain=subdomain[4+1,subdomain.length]
	name=subdomain[0,subdomain.index(".")]
	tmp =records(nil,domain)
	tmp.select{|x|x["name"]==name}.first
end

def fetch path,params={}
	yaml=config
	token="#{yaml['id']},#{yaml['token']}"
	uri=URI("https://dnsapi.cn/")
	uri.path=path
	params[:login_token]=token
	params[:format]="json"
	params[:lang]="en"
	res=Net::HTTP.post_form uri,params
	#,"UserAgent"=>"zcq100 DnsPod Client/1.0.0 (m@zcq100.com)"
	JSON.parse res.body
end