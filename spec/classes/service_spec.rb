require 'spec_helper'

describe 'randrust::service' do
  let(:params) do
    {
      service_manage: true,
      service_enable: true,
      service_ensure: 'running',
      service_name: 'randrustd',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      context 'with defaults' do
        it {
          is_expected.to contain_service('randrust').with(
            enable: true,
            ensure: 'running',
            name: 'randrustd',
            hasstatus: true,
            hasrestart: true,
          )
        }
      end

      context 'when service_ensure => stopped' do
        let(:params) do
          super().merge(service_ensure: 'stopped')
        end

        it { is_expected.to contain_service('randrust').with_ensure('stopped') }
      end

      context 'when service_manage => false' do
        let(:params) do
          super().merge(service_manage: false)
        end

        it { is_expected.not_to contain_service('randrust').with('enable' => true, 'ensure' => 'running', 'name' => 'randrustd') }
      end
    end
  end
end
