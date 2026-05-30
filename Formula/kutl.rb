class Kutl < Formula
  desc "Collaborative text synchronization tool"
  homepage "https://kutl.io"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kutl-io/kutl/releases/download/v0.1.7/kutl-aarch64-apple-darwin.tar.xz"
      sha256 "91be6aadb354b2573ffec5c1b8bc8bcc8b7df4adcce8331b98a16782d8f2d88a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kutl-io/kutl/releases/download/v0.1.7/kutl-x86_64-apple-darwin.tar.xz"
      sha256 "9e09e233e83c6eeb69a60cdb282cc9c3e6ae443905cf5d8fbcdd35bf855f4438"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "x86_64-apple-darwin":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "kutl" if OS.mac? && Hardware::CPU.arm?
    bin.install "kutl" if OS.mac? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
