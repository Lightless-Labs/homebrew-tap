class Middens < Formula
  desc "AI agent session log analyzer"
  homepage "https://lightless-labs.github.io/third-thoughts/"
  license "AGPL-3.0-or-later"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.2/middens-0.0.1-beta.2-aarch64-apple-darwin.tar.gz"
    sha256 "a80be88500d536748317764ba3936009f3d4a3fbfc2d81b49bb331740e0d8105"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.2/middens-0.0.1-beta.2-aarch64-unknown-linux-gnu.tar.gz"
    sha256 "2e8bd5af6f06ea0d7c4dbd5ada84e11d155f1451a8ee3a4ad01288d7f1831bb9"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.2/middens-0.0.1-beta.2-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "8741ace6c08b9b8627b3870eb901efb9fa617ee08f7007ad952d881c0d3aefa0"
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
