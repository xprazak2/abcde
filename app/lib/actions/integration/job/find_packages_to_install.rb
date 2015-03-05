module Actions
  module Integration
    module Job
      class FindPackagesToInstall < Actions::EntryAction
        middleware.use ::Actions::Middleware::RemoteAction
        include ::Dynflow::Action::Cancellable
        
        def run
          job = ::Integration::Job.find input.fetch(:job_id)
          output[:package_names] = job.target_cv_version.packages.map(&:name)
        end
        
      end
    end
  end
end