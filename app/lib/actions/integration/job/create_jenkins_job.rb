module Actions
  module Integration
    module Job
      class CreateJenkinsJob < Actions::EntryAction

        def create_jenkins_job(job_id, shell_command = "")
          job = get_job
          job.init_run
          job.jenkins_instance.client.job.create_freestyle(:name => input[:unique_name], :shell_command => shell_command)
        end

        def get_job
          job = ::Integration::Job.find input[:job_id]
        end
      end
    end
  end
end