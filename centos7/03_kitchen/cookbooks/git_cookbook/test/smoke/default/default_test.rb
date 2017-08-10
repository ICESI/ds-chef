# # encoding: utf-8

# Inspec test for recipe git_cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe user('root') do
    it { should exist }
  end
end

describe port(22) do
  it { should_not be_listening }
end

describe package('git') do
  it { should be_installed }
end

describe package('httpd') do
  it { should_not be_installed }
end
