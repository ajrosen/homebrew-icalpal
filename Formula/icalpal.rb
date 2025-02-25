# frozen_string_literal: true

# Brew formula for icalPal
class Icalpal < Formula
  desc 'Command-line tool to query a macOS Calendar or Reminders database for accounts, calendars, events, and tasks'
  homepage 'https://github.com/ajrosen/icalPal'
  url 'https://codeload.github.com/ajrosen/icalPal/tar.gz/refs/tags/icalpal-3.2.0'
  sha256 'aa16d0c90f51b9c5bffa4e4bd7906e6ae3182e5e8ada775cd189ca19c41fcae8'
  license 'GPL-3.0-or-later'

  uses_from_macos 'ruby'

  resource 'testdata' do
    url 'https://github.com/ajrosen/icalPal/raw/main/test/testdata.tar.gz'
    sha256 'c9ce172f6e38efc2c54f73cf3d07fa0221e63ac5a0e266eb87f0808559eb5b1b'
  end

  def install
    ENV['GEM_HOME'] = libexec
    system 'gem', 'build', "#{name}.gemspec"
    system 'gem', 'install', "#{name}-#{version}.gem"
    bin.install "libexec/bin/#{name}"
    bin.env_script_all_files('libexec/bin', GEM_HOME: ENV['GEM_HOME'])
  end

  test do
    checksums = %w[
      ace7eaa25df2c1228c707c4b4f0e4312eac8b1fc0b1bedbd1b45c1f633c8a1ec
      a61d9cdafe86f55ca5af4601eba3cf7cd55bc6a3b75a5639ddfb51e030179de2
      85904ee48c89c4ca5e7adb297ed5a65b5f1272f0b803ecdde1e6b848ddc75d4f
    ]
    testsums = []

    resource('testdata').stage do
      %w[calendars stores].each do |t|
        system "#{bin}/icalpal -c #{t} --db Calendar.sqlitedb --cf /dev/null > #{t}"
        testsums.push(Digest::SHA256.hexdigest(File.read(t)))
      end

      %w[tasks].each do |t|
        system "#{bin}/icalpal -c #{t} --db . --cf /dev/null > #{t}"
        testsums.push(Digest::SHA256.hexdigest(File.read(t)))
      end

      checksums == testsums
    end
  end
end
