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
    resource("testdata").stage do
      ["calendars", "stores"].each do |t|
        system "#{bin}/icalPal -c #{t} --db Calendar.sqlitedb --cf /dev/null > #{t}"
      end
      system "sha256sum", "-c", "sha256sum"
    end
  end
end
