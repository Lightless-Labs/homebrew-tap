class Middens < Formula
  desc "AI agent session log analyzer"
  homepage "https://lightless-labs.github.io/third-thoughts/"
  license "AGPL-3.0-or-later"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.4/middens-0.0.1-beta.4-aarch64-apple-darwin.tar.gz"
    sha256 "b6b57d82d9d0b6059f701e83baf2e933be32492f85b7e95396b40289da3482f9"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.4/middens-0.0.1-beta.4-aarch64-unknown-linux-gnu.tar.gz"
    sha256 "ca92cc8c5c251d0c85ffa880111cf1d9c9c717c845cc8a392fad189d8b1e487f"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.4/middens-0.0.1-beta.4-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "5aac34ccb02646d5de70a6cba8fc1ebfd2c9596958376d42e6d317e8611129a0"
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
