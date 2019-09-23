# frozen_string_literal: true

require 'spec_helper'

describe 'randrust::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { {} }

      it { is_expected.to compile }

      conf_path = '/etc/default/randrust'

      describe 'interfaces' do
        context 'when set' do
          let(:params) do
            super().merge(interface: 'a.b.c.d')
          end

          it { is_expected.to contain_file(conf_path).with_content(%r{INTERFACE=a.b.c.d}) }
        end

        context 'when not set' do
          it { is_expected.to contain_file(conf_path).with_content(%r{INTERFACE=0.0.0.0}) }
        end
      end

      describe 'listen port' do
        context 'when set' do
          let(:params) do
            super().merge(listen_port: 38_491)
          end

          it { is_expected.to contain_file(conf_path).with_content(%r{LISTEN_PORT=38491}) }
        end

        context 'when not set' do
          it { is_expected.to contain_file(conf_path).with_content(%r{LISTEN_PORT=80}) }
        end
      end

      describe 'allows template to be overridden with epp template' do
        let(:params) { { config_epp: 'my_randrust/my_randrust.epp' } }

        it { is_expected.to contain_file(conf_path).with_content(%r{randrustd}) }
      end
    end
  end
end
