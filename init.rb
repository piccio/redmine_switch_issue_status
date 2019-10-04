require 'redmine_switch_issue_status/issues_controller_patch'
require 'redmine_switch_issue_status/mail_handler_patch'

Rails.configuration.to_prepare do
  unless IssuesController.included_modules.include? RedmineSwitchIssueStatus::IssuesControllerPatch
    IssuesController.prepend(RedmineSwitchIssueStatus::IssuesControllerPatch)
  end

  unless MailHandler.included_modules.include? RedmineSwitchIssueStatus::MailHandlerPatch
    MailHandler.prepend(RedmineSwitchIssueStatus::MailHandlerPatch)
  end
end

Redmine::Plugin.register :redmine_switch_issue_status do
  name 'Redmine Switch Issue Status plugin'
  author 'Roberto Piccini'
  description <<-eos
    automatically switch status of the issue from a starting status to another status when updating the description or adding a comment
  eos
  version '1.1.0'
  url 'https://github.com/piccio/redmine_switch_issue_status'
  author_url 'https://github.com/piccio'

  settings default: { 'from_status' => nil, 'to_status' => nil }, partial: 'settings/switch_issue_status'
end
