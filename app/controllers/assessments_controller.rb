class AssessmentsController < SecuredController
  def create
    created_assessment = AssessmentCreator.create_assessment(params[:assessment])
    render :json => created_assessment,
           :status => :created
  end

  def show
    render :json => Assessment.find(params[:id])
  end

  def index
    filters = {}
    if params.include? :submission_id
      filters[:submission_id] = params[:submission_id]
    end

    if params.include? :assessor_id
      filters[:assessor_id] = params[:assessor_id]
    end

    render :json => Assessment.all.where(filters)
  end
end
