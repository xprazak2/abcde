module Actions
  module Integration
    module Job
      class CvPublishJobHook < Actions::EntryAction

        def self.subscribe
          Katello::ContentView::Publish
        end

        def plan(content_view, descripton)
          plan_self(:trigger => trigger.output)
          valid_jobs = content_view.jobs.select { |job| job.is_valid? }
          jobs_to_run = valid_jobs.select { |job| job.environment.library? }
          jobs_to_run.each do |job|
            if job.levelup_trigger
              plan_action(Dummy, :job_name => job.name)
            end
          end
        end

        def run
        end
      end
    end
  end
end