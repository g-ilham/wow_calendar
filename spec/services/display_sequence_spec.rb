require "rails_helper"

describe DisplaySequence do
  describe "will be continued sequence" do
    let(:last_sequence) { [{"3"=>1}, {"1"=>1}, {"2"=>2}, {"1"=>2}] }

    it "match with last_sequence" do
      expect(DisplaySequence.new(6).show_sequence).to eq(last_sequence)
    end
  end
end
