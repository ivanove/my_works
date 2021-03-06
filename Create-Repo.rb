require 'colorize'
require 'rubygems'
require 'json'
require 'net/http'
require 'open-uri'
require 'fileutils'

class Gitcreate
    
    
    def initialize
        #by ETTAHERI Nizar
        # Visibility_level :
        # 20 for Public
        # 10 for Internal
        # 0  for Private
        #namespace_id
        # @Visibility_level=0
        @token="xxxxxxxx"
        @user="nizar"
        @host="devserver"
        @path="http://devserver/api/v3/groups?private_token=xxxxxxxxx"
        
    end
    def getGroup
        path = URI(@path)
        puts "path : #{path}"
        content = Net::HTTP.get(path)
        json = JSON.parse(content)
        @group = json[1]["name"]
        @group.downcase!
        @group.gsub!(' ','-')
        @group
        
    end
    def gitignore
        puts "Enter number of folders and files to ignore : (to skip hit enter)".yellow
        nmbr=STDIN.gets.to_i
        
        a=Array.new(nmbr)
        puts "Enter folders and files to ignore : (to skip hit enter)".red
        begin
            puts"#{nmbr} :"
            items=STDIN.gets.chomp()
            cmde="git rm --cached #{items}"
            system(cmde)
            a.unshift(items)
            nmbr-=1
        end while nmbr>0
        File.open('.gitignore', 'w') {|f| f.write a.join("\n")}
        
    end
    
    def name_from_floder
        
        puts"name processing...".blue
        name1 = File.basename(Dir.getwd)
        name=name1
        name.downcase!
        name.gsub!(' ','-')
        # name.unicode_normalize!(:kd)
        puts "name : #{name}"
        name
    end
    
    def create_repo(name)
        puts "Creating Git repository #{name}...".blue
        
        
        cmd="curl -H \"Content-Type:application/json\" http://#{@host}/api/v3/projects?private_token=#{@token} -d '{\"name\":\"#{name}\",\"visibility_level\": 20 , \"namespace_id\":19}'"
        
        
        puts cmd
        
        system(cmd)
        puts " done."
    end
    
    def push_repo(name)
        puts "Pushing to Git repository #{name}...".blue
        system("git remote remove origin")
        system("git init")
        cmd5="git add -A"
        system(cmd5)
        puts cmd5
        puts "Enter message of commit #{name}...".blue
        msg=STDIN.gets.chomp()
        cmd3="git commit -m \"#{msg}\""
        system(cmd3)
        cmd4="git remote add origin git@#{@host}:#{@group}/#{name}.git"
        puts cmd4
        system(cmd4)
        system("git push -u origin master")
        puts"Done".blue
    end
    
end



git=Gitcreate.new
#git.gitignore
group=git.getGroup
puts "group : #{group}".blue
name=git.name_from_floder
#git.create_repo(name)
git.push_repo(name)
