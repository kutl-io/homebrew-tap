class Kutl < Formula
  desc "Collaborative text synchronization tool"
  homepage "https://kutl.io"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kutl-io/kutl/releases/download/v0.1.6/kutl-aarch64-apple-darwin.tar.xz"
      sha256 "311d8bd43439cf15318bd3ecb43b35d021458fb7c153f6d3f78c82e55d8bd968"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kutl-io/kutl/releases/download/v0.1.6/kutl-x86_64-apple-darwin.tar.xz"
      sha256 "887bc41776c237594d9f8853f77c11d8ecd4ba3e03e7964e8a890aaed0400d52"
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
