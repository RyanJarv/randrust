require 'spec_helper_acceptance'

describe 'builds' do
  it 'does an end-to-end thing' do
    pp = <<-EOF
      require randrust
    EOF
      
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
    
  end

  describe file("/etc/default/randrust") do
    it { is_expected.to contain "INTERFACE=0.0.0.0" }
  end
end