shared_context 'login liwh' do
 before :each do
   visit new_user_session_path
   fill_in 'user[email]', with: user_liwh.email
   fill_in 'user[password]', with: user_liwh.password
   click_on 'log in'
  end
  let(:user_liwh){ Factory :user_liwh}
  let(:shop) { user_liwh.shop}
end

shared_context 'login admin' do 
  let(:user_admin) { Factory :user_admin }
  before :each do
    visit new_user_session_path
    fill_in 'user[email]', with: user_admin.email
    fill_in 'user[password]', with: user_admin.password
    click_on 'log in'
  end
end
