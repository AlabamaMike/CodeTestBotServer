require 'spec_helper'
require 'mailer_spec_helper'

describe SubmissionMailer do
  include MailerSpecHelper

  let(:new_submission_address) { 'test.to@example.com' }
  let(:from_address) { 'test.from@example.com' }

  before(:each) do
    Figaro.env.stub(:new_submission_address => new_submission_address)
    Figaro.env.stub(:from_address => from_address)
    Figaro.env.stub(:base_uri => 'http://example.com')
  end

  describe '#new_submission' do
    let(:level) { Level.new({ text: 'Junior' }) }
    let(:language) { Language.new({ name: 'Java' }) }
    let(:candidate) { Candidate.new({ level: level }) }
    let(:submission) { Submission.new({ id: 2, candidate: candidate, language: language }) }
    subject(:mail) { SubmissionMailer.new_submission(submission) }

    its(:to) { should include new_submission_address }
    its(:from) { should include from_address }
    its(:subject) { should eq("[CTB] #{level.text} #{language.name} Submission") }

    it 'body should match fixture' do
      expected = read_mailer_fixture(SubmissionMailer, 'new_submission')
      expect(mail.body.to_s).to eq(expected)
    end
  end

end