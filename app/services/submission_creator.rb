class SubmissionCreator
  def self.create_submission(submission)
    created_submission = Submission.create_from_json(submission)

    zipfile_name = submission[:zipfile_name]
    zipfile_url = SubmissionFileUploader.upload(created_submission,
                                                submission[:zipfile],
                                                zipfile_name)
    created_submission.attach_zipfile(zipfile_url)

    resumefile_name = submission[:resumefile_name]
    resumefile_url = SubmissionFileUploader.upload(created_submission,
                                                   submission[:resumefile],
                                                   resumefile_name)
    created_submission.attach_resumefile(resumefile_url)

    Notifications::Submissions.new_submission(created_submission)
    created_submission
  end
end
