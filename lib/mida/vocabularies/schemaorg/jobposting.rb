require 'mida/vocabulary'

module Mida
  module SchemaOrg

    autoload :Thing, 'mida/vocabularies/schemaorg/thing'
    autoload :Organization, 'mida/vocabularies/schemaorg/organization'
    autoload :Place, 'mida/vocabularies/schemaorg/place'

    # A listing that describes a job opening in a certain organization.
    class JobPosting < Mida::Vocabulary
      itemtype %r{http://schema.org/JobPosting}i
      include_vocabulary Mida::SchemaOrg::Thing

      # The base salary of the job.
      has_many 'baseSalary' do
        extract Mida::DataType::Number
      end

      # Description of benefits associated with the job.
      has_many 'benefits'

      # Publication date for the job posting.
      has_many 'datePosted' do
        extract Mida::DataType::ISO8601Date
      end

      # Educational background needed for the position.
      has_many 'educationRequirements'

      # Type of employment (e.g. full-time, part-time, contract, temporary, seasonal, internship).
      has_many 'employmentType'

      # Description of skills and experience needed for the position.
      has_many 'experienceRequirements'

      # Organization offering the job position.
      has_many 'hiringOrganization' do
        extract Mida::SchemaOrg::Organization
        extract Mida::DataType::Text
      end

      # Description of bonus and commission compensation aspects of the job.
      has_many 'incentives'

      # The industry associated with the job position.
      has_many 'industry'

      # A (typically single) geographic location associated with the job position.
      has_many 'jobLocation' do
        extract Mida::SchemaOrg::Place
        extract Mida::DataType::Text
      end

      # Category or categories describing the job. Use BLS O*NET-SOC taxonomy: http://www.onetcenter.org/taxonomy.html. Ideally includes textual label and formal code, with the property repeated for each applicable value.
      has_many 'occupationalCategory'

      # Specific qualifications required for this role.
      has_many 'qualifications'

      # Responsibilities associated with this role.
      has_many 'responsibilities'

      # The currency (coded using ISO 4217, http://en.wikipedia.org/wiki/ISO_4217 used for the main salary information in this job posting.
      has_many 'salaryCurrency'

      # Skills required to fulfill this role.
      has_many 'skills'

      # Any special commitments associated with this job posting. Valid entries include VeteranCommit, MilitarySpouseCommit, etc.
      has_many 'specialCommitments'

      # The title of the job.
      has_many 'title'

      # The typical working hours for this job (e.g. 1st shift, night shift, 8am-5pm).
      has_many 'workHours'
    end

  end
end
