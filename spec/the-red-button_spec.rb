require_relative '../the-red-button'

describe RedButton do
  let(:targets) {
    [ {:host=>"hostname", :directory=>"/shared/location", :uri=>"http://github.com"} ]
  }

  describe ".new" do
    it "raises an error if the targets array is empty" do
      expect { RedButton.new([]) }.to raise_error(MalformedTargetsError)
    end
  end

# describe "#ssh_command" do
#   it "formats the SSH command correctly" do
#     TheRedButton.ssh_command("test_host", "/var/www/example.com/shared").should eq "ssh test_host \'touch /var/www/example.com/shared/maintenance-on\'"
#   end
# end

  describe "#targets_are_valid" do
    it "succeeds if a target has all required attributes" do
      expect { RedButton.new(targets) }.to_not raise_error(MalformedTargetsError)
    end

    it "fails if a target is missing a required attribute" do
      targets.first[:host] = nil
      expect { RedButton.new(targets) }.to raise_error(MalformedTargetsError)
      targets.first[:host] = "hostname"
      
      targets.first[:directory] = nil
      expect { RedButton.new(targets) }.to raise_error(MalformedTargetsError)
      targets.first[:directory] = "/shared/location"

      targets.first[:uri] = nil
      expect { RedButton.new(targets) }.to raise_error(MalformedTargetsError)
    end
  end
end
