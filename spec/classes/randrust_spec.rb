# frozen_string_literal: true

require 'spec_helper'

describe 'randrust' do
  let(:facts) { { is_virtual: false } }
  let(:params) { {} }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts.merge(super())
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('randrust::install') }
      it { is_expected.to contain_class('randrust::config') }
      it { is_expected.to contain_class('randrust::service') }
    end
  end
end
