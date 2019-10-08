module RedmineSwitchIssueStatus
  module JournalPatch

    def self.prepended(base)
      base.after_create :switch_issue_status
    end

    private

    def switch_issue_status
      issue = self.issue

      unless issue.nil?
        from_status = Setting.plugin_redmine_switch_issue_status['from_status']
        to_status = Setting.plugin_redmine_switch_issue_status['to_status']
        prerequisites = !to_status.nil? && !from_status.nil? &&
          from_status != to_status &&
          issue.status_id.to_s == from_status &&
          issue.status_id.to_s != to_status &&
          issue.assigned_to == User.current &&
          ( !self.notes.blank? || !self.detail_for_attribute('description').nil? )

        if prerequisites
          issue.init_journal(User.first)
          issue.current_journal.notify = false
          issue.update_attribute(:status, IssueStatus.find(to_status))
        end
      end
    end

  end
end