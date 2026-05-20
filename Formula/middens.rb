class Middens < Formula
  desc "AI agent session log analyzer"
  homepage "https://lightless-labs.github.io/third-thoughts/"
  license "AGPL-3.0-or-later"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.3/middens-0.0.1-beta.3-aarch64-apple-darwin.tar.gz"
    sha256 "c1fa734fe03de4275ad5128f0a07c613a5b1b3a14db09e5c1d38793cd92a76ed"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.3/middens-0.0.1-beta.3-aarch64-unknown-linux-gnu.tar.gz"
    sha256 "2b5aa12b4525a6b0357814b3654061a57a0202fe0ab7f4aafafdd0604bef664b"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.3/middens-0.0.1-beta.3-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "f3e44cf602358be83ba11a78d6f5c8b9e0649b2da77e77e27ef220c3ef8e7611"
  elsif OS.mac? && Hardware::CPU.intel?
    odie <<~EOS
      middens does not currently publish an x86_64 macOS binary.
      Supported Homebrew targets: Apple Silicon macOS, x86_64 Linux, arm64 Linux.
    EOS
  else
    odie <<~EOS
      middens does not publish a binary for this platform.
      Supported Homebrew targets: Apple Silicon macOS, x86_64 Linux, arm64 Linux.
    EOS
  end

  depends_on "uv" => :recommended

  def install
    bin.install "middens"
  end

  test do
    assert_match "middens #{version}", shell_output("#{bin}/middens --version")
  end
end
