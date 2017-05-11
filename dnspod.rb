#!/usr/bin/env ruby -wKU
require "net/http"
require "uri"
require "open-uri"
require "yaml"
require "json"

#get localip address
def local_ip
	ip="0.0.0.0"
	open("http://1212.ip138.com/ic.asp") do |f| 
		str=f.read
		ip= str.scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/).first
	end
end

#read configfile from config.yaml
def config
	YAML.load(File.open("config.yaml"))
end

#API token
def token
	"#{config['id']},#{config['token']}"
end

#request all domain use API
def domains
	fetch("/Domain.List")
end

#Frind all records
#domain_id,domain_name
#return records
#http://www.dnspod.cn/docs/records.html#record-list
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

def update_domain domain_name,ip_address
	name=domain_name[0,domain_name.index(".")]
	domain=domain_name[4+1,domain_name.length]
	tmp=find_record(domain_name)
	record_id=tmp["id"]
	if ip_address==tmp["value"]
	 p "ip没有不改变，不更新 "
	else
	 msg=fetch("/Record.Ddns",{:domain=>domain,:record_id=>record_id,:record_line_id=>"10=0",:record_type=>"A",:value=>ip_address,:sub_domain=>name})
	 p "#{msg['status']['code']}  #{msg['status']['message']}"
	end
end

#find record by subdomain
def find_record subdomain
	domain=subdomain[4+1,subdomain.length]
	name=subdomain[0,subdomain.index(".")]
	tmp =records(nil,domain)
	tmp.select{|x|x["name"]==name}.first
end

#fetch dnspod API
def fetch path,params={}
	yaml=config
	uri=URI("https://dnsapi.cn/")
	uri.path=path
	params[:login_token]=token
	params[:format]="json"
	params[:lang]="cn"
	res=Net::HTTP.post_form uri,params
	#,"UserAgent"=>"zcq100 DnsPod Client/1.0.0 (m@zcq100.com)"
	resp=JSON.parse(res.body)
	raise resp["status"]["message"] unless resp["status"]["code"]=="1"
	resp
end