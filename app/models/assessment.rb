class Assessment < ActiveRecord::Base
  class ExistingAssessmentError < StandardError
  end

  belongs_to :submission
  belongs_to :assessor

  def self.create_from_json(assessment)
    submission = Submission.find(assessment.fetch(:submission_id))
    assessor = Assessor.find(assessment.fetch(:assessor_id))

    if submission.has_assessment_by_assessor(assessor)
      raise ExistingAssessmentError
    end

    created = Assessment.create({
      submission: submission,
      assessor: assessor,
      score: assessment[:score],
      notes: assessment[:notes],
      published: assessment[:published]
    })

    submission.assessments << created

    created
  end

  def update_from_json(assessment_json)
    update!({
      score: assessment_json[:score],
      notes: assessment_json[:notes],
      published: assessment_json[:published]
    })
    self
  end

  def age
    Time.now.utc - created_at
  end
end
