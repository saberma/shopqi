#!/usr/bin/env ruby
# encoding: utf-8
require 'httparty'
require 'json' # httparty默认的Crack::JSON.parse方法会报错

class Milestone # http://developer.github.com/v3/issues/milestones/
  include HTTParty
  format :plain

  def initialize(json)
    @json = json
  end

  def self.closed
    @closed ||= JSON(self.get("https://api.github.com/repos/saberma/shopqi/milestones?state=closed"))
  end

  def self.find(title)
    json = self.closed.select do |milestone|
      milestone['title'] == title
    end.first
    self.new json
  end

  def self.last_closed
    self.new self.closed.first
  end

  def issues
    @issues ||= Issue.all(@json)
  end

  def bugs_issues # 缺陷
    @bugs ||= begin
      issues.select(&:bug?).sort do |y, x|
        x.assignee <=> y.assignee
      end
    end
  end

  def features_issues # 功能
    @features ||= begin
      issues.reject(&:bug?).sort do |y, x|
        x.assignee <=> y.assignee
      end
    end
  end

  def method_missing(name, *args)
    name = name.to_s
    return @json[name] if @json.key?(name)
    super
  end
end

class Issue # http://developer.github.com/v3/issues/
  include HTTParty
  format :plain

  def initialize(json)
    @json = json
  end

  def self.all(milestone)
    JSON(self.get("https://api.github.com/repos/saberma/shopqi/issues?state=closed&milestone=#{milestone['number']}")).map do |json|
      self.new json
    end
  end

  def bug?
    self.labels.any? do |label|
      label['name'] == '缺陷'
    end
  end

  def assignee # 任务接收人
    @json['assignee']['login']
  end

  def method_missing(name, *args)
    name = name.to_s
    return @json[name] if @json.key?(name)
    super
  end
end

#milestone = Milestone.find('0.1.1')
milestone = Milestone.last_closed
changelog = "## v#{milestone.title} / #{DateTime.parse(milestone.due_on).strftime("%Y-%m-%d")} (#{milestone.issues.size})\n"
unless milestone.features_issues.empty?
  changelog += "\n### 功能(#{milestone.features_issues.size}):\n\n"
  milestone.features_issues.each_with_index do |issue, index|
    changelog += "#{index+1}. #{issue.title}[#{issue.assignee}] ##{issue.number}\n"
  end
end
unless milestone.bugs_issues.empty?
  changelog += "\n### 缺陷(#{milestone.bugs_issues.size}):\n\n"
  milestone.bugs_issues.each_with_index do |issue, index|
    changelog += "#{index+1}. #{issue.title}[#{issue.assignee}] ##{issue.number}\n"
  end
end

path = File.expand_path('../../CHANGELOG.md',  __FILE__)
changelog += "\n\n"
changelog += File.read(path)
File.open(path, 'w') do |f|
  f.write changelog
end
