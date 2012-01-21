RSpec::Matchers.define :be_a_mac_address do
  match do |actual|
    actual.match(/^(?:[A-F0-9]{2}:){5}[A-F0-9]{2}$/)
  end
end