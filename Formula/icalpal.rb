class Icalpal < Formula
  desc "Command-line tool to query a macOS Calendar or Reminders database for accounts, calendars, events, and tasks"
  homepage "https://github.com/ajrosen/icalPal"
  url "https://github.com/ajrosen/icalPal/archive/refs/tags/2.0.0.tar.gz"
  sha256 "1be42661590b48c89e7792f48b9eb5c0642f4e59efd9c9daf48dedbd28145af2"
  license "GPL-3.0-or-later"

  uses_from_macos "ruby"

  resource "testdata" do
    url "https://github.com/ajrosen/icalPal/raw/main/test/testdata.tar.gz"
    sha256 "298f95ce9d54c7434602bd6f3bd22aba67cfcc8cd14ddefe1549cf71a7c6edd4"
  end

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    checksums = [
      "ace7eaa25df2c1228c707c4b4f0e4312eac8b1fc0b1bedbd1b45c1f633c8a1ec",
      "a61d9cdafe86f55ca5af4601eba3cf7cd55bc6a3b75a5639ddfb51e030179de2",
      "85904ee48c89c4ca5e7adb297ed5a65b5f1272f0b803ecdde1e6b848ddc75d4f",
    ]
    testsums = []

    resource("testdata").stage do
      ["calendars", "stores"].each do |t|
        system "#{bin}/icalPal -c #{t} --db Calendar.sqlitedb --cf /dev/null > #{t}"
        testsums.push(Digest::SHA256.hexdigest(File.read(t)))
      end

      ["tasks"].each do |t|
        system "#{bin}/icalPal -c #{t} --db . --cf /dev/null > #{t}"
        testsums.push(Digest::SHA256.hexdigest(File.read(t)))
      end

      checksums == testsums
    end
  end
end
