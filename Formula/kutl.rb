class Kutl < Formula
  desc "Collaborative text synchronization tool"
  homepage "https://kutl.io"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kutl-io/kutl/releases/download/v0.2.0/kutl-aarch64-apple-darwin.tar.xz"
      sha256 "d213a101601ffe021c40876b1bd7d25aee0c1982d80f1d43c03367f44d01d346"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kutl-io/kutl/releases/download/v0.2.0/kutl-x86_64-apple-darwin.tar.xz"
      sha256 "c842f321d5de6db29c5f7e351a8b8fdfa32a967ba9b29e37ed674bcaad72c01a"
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
