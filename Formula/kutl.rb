class Kutl < Formula
  desc "Collaborative text synchronization tool"
  homepage "https://kutl.io"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kutl-io/kutl/releases/download/v0.1.4/kutl-aarch64-apple-darwin.tar.xz"
      sha256 "43711af855f7dfa08d183139d6585511ed30993471e72274786b78299f0d0248"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kutl-io/kutl/releases/download/v0.1.4/kutl-x86_64-apple-darwin.tar.xz"
      sha256 "6547ac9d52a6760d08477b9f3e8d207cc7ebb5948ad806ab7c92ab40e43e2264"
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
