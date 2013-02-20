# encoding: UTF-8
class HTTPError < StandardError; end
class MalformedTargetsError < StandardError; end
class SSHError < StandardError; end

require 'net/http'
require "curses"
include Curses

class RedButton
  attr_reader :targets

  def initialize(targets)
    @targets = targets

    raise MalformedTargetsError, "You have not configured any targets" if targets.size == 0
    raise MalformedTargetsError, "One or more of your targets is malformed (missing host, shared location, or URI)" unless targets_are_valid
  end

  def slam
    if this_is_really_happening
      targets.each do |target|
        touch_maintenance_file(target[:host], target[:directory])
        check_uri(target[:uri])
      end
    else
      puts "Remaining calm..."
    end
  end

  private

  def check_uri(uri)
    uri = URI.parse(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"

    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)

    if response.code == "503"
      puts "  #{ uri } is in maintenance mode."
      puts "  \e[32mEXCELLENT\e[0m\n\n"
    else
      raise HTTPError, "#{ uri } is not returning a 503 response code. Check the URI in your target list, and make sure that the maintenance Nginx configuration is installed correctly."
    end
  end

  def random_david_caruso_quote
    [
      "You don't spend $1,000 on clothes that you're never going to wear.",
      "The verdict is in.",
      "It turns out the wave is not the only thing about to hit Miami.",
      "They brought the war to us. Now we are going to take it to them.",
      "Our accident is not an accident at all.",
      "Here we go.",
      "The tide is rising, and we have a sinking crime scene.",
      "Right now, I'm your only suspect.",
      "Miami has a new breed of criminal.",
      "I am going to get to the truth.",
      "That's what happens when worlds collide.",
      "It's time to hit back.",
      "The verdict is in, but the jury is out.",
      "Join the club.",
      "They're not going to get away with murder.",
      "We're going to Brazil.",
      "A dead body can have that effect on you."
    ].sample
  end

  def sunglasses
    init_screen
    curs_set(0)
    print "( •_•)"
    sleep 1
    print "\b" * 6
    print "( •_•)>⌐■-■"
    sleep 1
    print "\b" * 11
    print "( ⌐■_■)    "
    sleep 1
    print "\b" * 4
    print " -- \"MOTHER OF GOD\"\n"
    sleep 1
    curs_set(1)
    close_screen
  end

  def targets_are_valid
    targets.all? do |target|
      target[:host] && target[:directory] && target[:uri]
    end
  end

  def this_is_really_happening
    confirmation_string = random_david_caruso_quote

    puts "Is this really happening?"
    puts "  Type '#{ confirmation_string }' to continue.\n"
    print "> "
    user_confirmation = STDIN.gets.chomp
    puts "\n"

    if user_confirmation == confirmation_string
      sunglasses
      puts File.read("ascii-art.txt")
      return true
    end

    false
  end

  def touch_maintenance_file(host, directory)
    puts "* Iron Curtain going up on #{ host } in #{ directory }"
    great_success = system "ssh #{ host } \'touch #{ directory }/maintenance-on\'"

    raise SSHError, "Error executing command on #{ host }. Please check the hostname and directory for any typos" unless great_success
  end

end
