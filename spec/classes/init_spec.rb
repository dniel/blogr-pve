require 'spec_helper'
describe 'pve' do

  context 'with defaults for all parameters' do
    it { should contain_class('pve') }
  end
end
