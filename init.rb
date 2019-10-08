require 'redmine_switch_issue_status/journal_patch'

Rails.configuration.to_prepare do
  unless Journal.included_modules.include? RedmineSwitchIssueStatus::JournalPatch
    Journal.prepend(RedmineSwitchIssueStatus::JournalPatch)
  end
end

Redmine::Plugin.register :redmine_switch_issue_status do
  name 'Redmine Switch Issue Status plugin'
  author 'Roberto Piccini'
  description <<-eos
    automatically switch status of the issue from a starting status to another status when updating the description or adding a comment
  eos
  version '2.0.0'
  url 'https://github.com/piccio/redmine_switch_issue_status'
  author_url 'https://github.com/piccio'

  settings default: { 'from_status' => nil, 'to_status' => nil }, partial: 'settings/switch_issue_status'
end
