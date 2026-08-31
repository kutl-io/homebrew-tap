class Kutl < Formula
  desc "Collaborative text synchronization tool"
  homepage "https://kutl.io"
  version "0.5.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kutl-io/kutl/releases/download/v0.5.1/kutl-aarch64-apple-darwin.tar.xz"
      sha256 "18d8f6c428128bbc0cb67c4b1fbaf02cd455d999fe07d7e1a74004f7be8e59db"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kutl-io/kutl/releases/download/v0.5.1/kutl-x86_64-apple-darwin.tar.xz"
      sha256 "a90cc87cc68d336b588e31d1f299493c2ff4545ed37f878a249cdfaf455a69d0"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "kutl"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "kutl"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
