require 'spec_helper'

describe DeliveryNote do
  it { should validate_presence_of(:content) }
  it { should belong_to(:delivery_order) }
end
