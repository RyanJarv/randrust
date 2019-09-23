# To check the correct dependancies are set up for randrust.

require 'spec_helper'
describe 'randrust' do
  let(:facts) { { is_virtual: false } }
  let :pre_condition do
    'file { "foo.rb":
      ensure => present,
      path => "/etc/tmp",
      notify => Service["randrust"] }'
  end

  on_supported_os.each do |os, f|
    context "on #{os}" do
      let(:facts) do
        f.merge(super())
      end

      it { is_expected.to compile.with_all_deps }
      describe 'Testing the dependancies between the classes' do
        it { is_expected.to contain_class('randrust::install') }
        it { is_expected.to contain_class('randrust::config') }
        it { is_expected.to contain_class('randrust::service') }
        it { is_expected.to contain_class('randrust::install').that_comes_before('Class[randrust::config]') }
        it { is_expected.to contain_class('randrust::service').that_subscribes_to('Class[randrust::config]') }
        it { is_expected.to contain_file('foo.rb').that_notifies('Service[randrust]') }
      end
    end
  end
end
