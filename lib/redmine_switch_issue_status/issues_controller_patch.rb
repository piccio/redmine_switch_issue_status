module RedmineSwitchIssueStatus
  module IssuesControllerPatch

    def update_issue_from_params
      return unless super

      from_status = Setting.plugin_redmine_switch_issue_status['from_status']
      to_status = Setting.plugin_redmine_switch_issue_status['to_status']
      assignee = @issue.assigned_to
      prerequisites = params[:form_update_triggered_by].blank? &&
        !to_status.nil? && !from_status.nil? &&
        from_status != to_status &&
        @issue.status_id.to_s == from_status &&
        @issue.status_id.to_s != to_status &&
        assignee == User.current

      if (prerequisites && params[:issue].has_key?(:notes) && !params[:issue][:notes].blank?) ||
        (prerequisites && params[:issue].has_key?(:description) && !params[:issue][:description].blank? &&
          @issue.description != params[:issue][:description])

        @issue.status = IssueStatus.find(to_status)
      end

      true
    end

  end
end