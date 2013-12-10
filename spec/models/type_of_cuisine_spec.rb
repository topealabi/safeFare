require 'spec_helper'

describe TypeOfCuisine do
  it { should belong_to :cuisine }
  it { should belong_to :restaurant }
end
