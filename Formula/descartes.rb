class Descartes < Formula
  desc "LLM-backed local system triage, monitoring, and alerting CLI"
  homepage "https://github.com/Lightless-Labs/descartes"
  url "https://github.com/Lightless-Labs/descartes/archive/refs/tags/v0.0.49.tar.gz"
  sha256 "2db87b6911f1b8bb78ad671be08cafc640a17f72f5fce8013aad9cefb0c4b568"

  depends_on "node"

  # Developer ID signed, notarized, and stapled DescartesNotifier.app produced by
  # the tag-triggered Buildkite release pipeline for the same version tag. It is
  # installed inside the npm package tree at the exact relative path the CLI's
  # bundled-helper resolution probes (tools/descartes-cli/src/notification-delivery.js),
  # so `descartes alerts notifications setup --channel native` works without
  # configuration. Cross-platform npm installs intentionally exclude this payload.
  resource "descartes-notifier" do
    url "https://github.com/Lightless-Labs/descartes/releases/download/v0.0.49/DescartesNotifier.app.zip"
    sha256 "e80a1b6178d21989fb531cb19363d65da364c74a55941da614a8cf99a1371a1e"
  end

  def install
    system "npm", "install", *std_npm_args

    # Descartes does not use Pi's optional native clipboard package. Remove its
    # prebuilt Mach-O addons so Homebrew does not try to rewrite their install
    # names during linkage fixes.
    pi_node_modules = libexec/"lib/node_modules/@lightless-labs/descartes/node_modules"
    pi_node_modules /= "@earendil-works/pi-coding-agent/node_modules"
    clipboard_packages = pi_node_modules/"@mariozechner"
    rm_r clipboard_packages if clipboard_packages.exist?

    bin.install_symlink Dir["#{libexec}/bin/*"]

    return unless OS.mac?

    helper_dir = libexec/"lib/node_modules/@lightless-labs/descartes/tools/descartes-cli/native/macos"
    helper_dir.mkpath
    # Extract with ditto rather than resource staging: unpack strategies descend
    # into a single top-level directory, and ditto is the canonical tool for
    # preserving a signed, stapled .app bundle exactly as released.
    helper_zip = resource("descartes-notifier")
    helper_zip.fetch
    system "ditto", "-x", "-k", helper_zip.cached_download, helper_dir
  end

  def caveats
    return unless OS.mac?

    <<~EOS
      The notarized DescartesNotifier.app notification helper is installed
      alongside the CLI. Enable native macOS notifications with:
        descartes alerts notifications setup --channel native
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/descartes --version")
  end
end
