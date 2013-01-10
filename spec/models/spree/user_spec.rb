require 'spec_helper'

describe Spree::User do
  let(:alpha_tenant) { FactoryGirl.create(:tenant, :shortname => 'alpha') }
  let(:beta_tenant) { FactoryGirl.create(:tenant, :shortname => 'beta') }

  it 'permits creating two users with the same email address with different tenants' do
    Spree::Tenant.set_current_tenant(alpha_tenant)
    alpha_user = Spree::User.create!(email: 'test@example.com', password: 'spree123')

    Spree::Tenant.set_current_tenant(beta_tenant)
    beta_user = Spree::User.create!(email: 'test@example.com', password: 'spree123')

    expect(alpha_user.email).to eq(beta_user.email)
    expect(alpha_user.id).to_not eq(beta_user.id)
  end

  it 'prevents creating two users with the same email address for the same tenant' do
    Spree::Tenant.set_current_tenant(alpha_tenant)

    Spree::User.create!(email: 'test@example.com', password: 'spree123')
    expect {
      Spree::User.create!(email: 'test@example.com', password: 'spree123')
    }.to raise_error('Validation failed: Email has already been taken')
  end

  it 'creates first user as a super admin'
  it 'creates second user as neither super nor admin'

  it 'assigns admin role when super_admin is set to true' do
    default_admin = Spree::User.create(email: 'admin@example.com', password: 'spree123')
    user = Spree::User.create!(email: 'test@example.com', password: 'spree123')

    user.should_not have_spree_role(:admin)
    user.should_not be_super_admin

    user.super_admin = true
    user.save!

    user.should have_spree_role(:admin)
  end
end
