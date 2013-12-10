require 'spec_helper'

describe Changeorder do
  it { should belong_to :restaurant }
  it { should belong_to :user }
  it { should have_valid(:type).when('description') }
  it { should_not have_valid(:type).when('dsgufgdsuifgeg',12325,'', " ") }
end
