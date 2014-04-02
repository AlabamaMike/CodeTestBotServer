require 'spec_helper'

describe AssessmentsController do
  describe :create do
    it 'creates an assessment from submission and assessor' do
      submission = Submission.create({email_text: 'A submission'})
      assessor = Assessor.create({name: 'Bob'})

      post :create, {assessment: {submission_id: submission.id, assessor_id: assessor.id, score: 5, notes: 'Fantastic!'}}

      expect(response).to be_success

      expect(Assessment.count).to eql(1)
      expect(Assessment.first.submission).to eql(submission)
      expect(Assessment.first.assessor).to eql(assessor)
      expect(Assessment.first.score).to eql(5)
      expect(Assessment.first.notes).to eql('Fantastic!')
    end
  end

  describe :index do
    before(:each) do
      @submission1 = Submission.create({email_text: 'first'})
      @submission2 = Submission.create({email_text: 'second'})
      @assessor1 = Assessor.create({name: 'Bob'})
      @assessor2 = Assessor.create({name: 'Alice'})

      @assessment1 = Assessment.create({submission: @submission1, assessor: @assessor1, score: 1, notes: 'Terrible!'})
      @assessment2 = Assessment.create({submission: @submission2, assessor: @assessor2, score: 5, notes: 'Amazing!'})
    end

    it 'renders a list of all assessments as JSON' do
      get :index

      expect(response.body).to be_json_eql([
          {submission_id: @submission1.id, assessor_id: @assessor1.id, score: 1, notes: 'Terrible!'},
          {submission_id: @submission2.id, assessor_id: @assessor2.id, score: 5, notes: 'Amazing!'}
                                           ].to_json).at_path('assessments')
    end

    it 'includes submission objects in the JSON payload' do
      get :index

      expect(response.body).to be_json_eql([
          {email_text: 'first', zipfile: '/zipfiles/original/missing.png', candidate_id: nil, language_id: nil},
          {email_text: 'second', zipfile: '/zipfiles/original/missing.png', candidate_id: nil, language_id: nil}
                                           ].to_json).at_path('submissions')
    end

    it 'includes the assessor objects in the JSON payload' do
      get :index

      expect(response.body).to be_json_eql([{name: 'Bob'}, {name: 'Alice'}].to_json).at_path('assessors')
    end

    it 'should filter assessments by the submission_id parameter' do
      get :index, submission_id: @submission1.id

      expect(response.body).to be_json_eql([
          {submission_id: @submission1.id, assessor_id: @assessor1.id, score: 1, notes: 'Terrible!'},
                                           ].to_json).at_path('assessments')
    end

    it 'should filter assessments by the asssor_id parameter' do
      get :index, assessor_id: @assessor2.id

      expect(response.body).to be_json_eql([
          {submission_id: @submission2.id, assessor_id: @assessor2.id, score: 5, notes: 'Amazing!'}
                                           ].to_json).at_path('assessments')
    end
  end
end