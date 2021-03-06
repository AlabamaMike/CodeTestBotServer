require 'spec_helper'

describe LevelsController do
  describe '#index' do
    subject(:response) { get :index }


    context 'with an active session' do
      before { add_user_to_session('Assessor') }
      let(:expected) { ['Junior', 'Mid', 'Senior', 'Tech Lead'].collect_concat { |l| {text: l} }.to_json }
      it { should be_ok }
      its(:body) { should be_json_eql(expected).at_path('levels') }
    end
  end
end