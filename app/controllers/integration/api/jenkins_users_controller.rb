module Integration
  class Api::JenkinsUsersController < Katello::Api::V2::ApiController
    respond_to :json

    include Api::Rendering

    before_filter :find_organization, :only => [:create, :index]
    before_filter :find_jenkins_user, :only => [:show, :destroy]
    before_filter :find_job, :only => [:create]

    def index
       ids = JenkinsUser.readable
            .where(:organization_id => @organization.id, :jenkins_instance_id => params[:jenkins_instance_id])
            .pluck(:id)
      filters = [:terms => {:id => ids}]       

      options = {
         :filters => filters,
         :load_records? => true
      }
      respond_for_index(:collection => item_search(JenkinsUser, params, options))
    end

    # def show
    #   respond_for_show(:resource => @jenkins_user)
    # end

    def create
      @jenkins_user = JenkinsUser.new(jenkins_user_params)
      @jenkins_user.owner = ::User.current
      fail ::Katello::HttpErrors::Conflict, "Could not create Jenkins User:
                                             No Jenkins Instance set for Job " if @job.jenkins_instance.nil?
      @jenkins_user.jenkins_instance = @job.jenkins_instance
      @job.jenkins_user = @jenkins_user
      @jenkins_user.organization = @organization
      # binding.pry
      @jenkins_user.save!

      respond_for_show(:resource => @jenkins_user)
    end

    def destroy
      @jenkins_user.destroy
      respond_for_show(:resource => @jenkins_user)
    end


    protected

    def find_jenkins_user
      @jenkins_user = JenkinsUser.find_by_id(params[:id])
      fail ::Katello::HttpErrors::NotFound, "Could not find Jenkins User with id #{params[:id]}" if @jenkins_user.nil?
      @jenkins_user 
    end

    def find_job
      @job = Job.find_by_id(params[:job_id])
      fail ::Katello::HttpErrors::NotFound, "Could not find job with id #{params[:job_id]}" if @job.nil?
      @job 
    end

    def jenkins_user_params
      params.require(:jenkins_user).permit(:name, :token, :job_id)
    end
    
  end
end