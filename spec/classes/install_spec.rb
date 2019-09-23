require 'spec_helper'

describe 'randrust::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { package_ensure: 'present', package_name: ['randrust'], package_manage: true } }

      it { is_expected.to compile }
      #it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('randrust').with_ensure('present') }

      context 'with package_ensure => latest' do
        let(:params) do
          super().merge(package_ensure: 'latest')
        end

        it { is_expected.to contain_package('randrust').with_ensure('latest') }
      end

      context 'with package_name => rustyham' do
        let(:params) do
          super().merge(package_name: ['rustyham'])
        end

        it { is_expected.to contain_package('rustyham') }
      end

      context 'with package_manage => false' do
        let(:params) do
          super().merge(package_manage: false)
        end

        it { is_expected.not_to contain_package('randrust') }
      end
    end
  end
end
