class Middens < Formula
  desc "AI agent session log analyzer"
  homepage "https://lightless-labs.github.io/third-thoughts/"
  license "AGPL-3.0-or-later"

  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.1/middens-0.0.1-beta.1-aarch64-apple-darwin.tar.gz"
    sha256 "fa744a051397d4f52bb69ca30549a6842fb05e0ee0260a405b240cfd0fb817fa"
  elsif OS.linux? && Hardware::CPU.arm?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.1/middens-0.0.1-beta.1-aarch64-unknown-linux-gnu.tar.gz"
    sha256 "baa23267aae0b275ece07f7d3bccc4c2dd50c836fe1f000a70ac7e5d37eec15b"
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Lightless-Labs/third-thoughts/releases/download/v0.0.1-beta.1/middens-0.0.1-beta.1-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "f8bfc01b8b46de6d450acf3217265585972b23f732343feff0616d124ff40518"
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
