class Middens < Formula
  desc "AI agent session log analyzer"
  homepage "https://lightless-labs.github.io/third-thoughts/"
  license "AGPL-3.0-or-later"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.0/middens-0.0.1-beta.0-aarch64-apple-darwin.tar.gz"
    sha256 "8f9a99454910316cf625303711446ec90a01489c9a7ada6e4ed6606753a30f06"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.0/middens-0.0.1-beta.0-aarch64-unknown-linux-gnu.tar.gz"
    sha256 "8d39a9f3b0f8a0762aaa729578ffee9fe761cc1f32e64a25197e95850a2d9926"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.0/middens-0.0.1-beta.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "7a8f3fdb6445f862179cef9d284858ff763a4aac3400d4ef989ae5676eaf19b0"
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
