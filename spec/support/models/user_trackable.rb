RSpec.shared_examples "UserTrackable" do
  let(:user) { create(:user) }

  it "set created_by and updated_by" do
    User.current_user = user
    subject.save

    expect(subject.created_by).to eq(user)
    expect(subject.updated_by).to eq(user)
  end
end
