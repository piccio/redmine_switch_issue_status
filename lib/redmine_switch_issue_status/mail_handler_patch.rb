module RedmineSwitchIssueStatus
  module MailHandlerPatch

    private

    def receive_issue_reply(issue_id, from_journal=nil)
      journal = super
      issue = journal.journalized
      from_status = Setting.plugin_redmine_switch_issue_status['from_status']
      to_status = Setting.plugin_redmine_switch_issue_status['to_status']
      assignee = issue.assigned_to
      prerequisites = !to_status.nil? && !from_status.nil? &&
        from_status != to_status &&
        issue.status_id.to_s == from_status &&
        issue.status_id.to_s != to_status &&
        assignee == User.current

      if prerequisites
        issue.update_attribute(:status, IssueStatus.find(to_status))
      end

      journal
    end

  end
end