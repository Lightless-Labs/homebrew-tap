# Formula/pessimal-agent.rb in Lightless-Labs/homebrew-tap is rendered from this file.
#
# Its source is packaging/homebrew/pessimal-agent.rb.template in Lightless-Labs/pessimal. The
# release-promote Buildkite step fills in the version, the tag and each archive's line from the
# release's SHA256SUMS (scripts/release-github.py, render_formula), and commits the result to the tap
# through the GitHub Contents API -- only after both release-verify steps have downloaded and run
# what GitHub serves. Edit the template, not the tap: a hand edit there is overwritten by the next
# release. Every placeholder must be one render_formula knows, or the rendered formula is refused
# rather than pushed, so do not write anything shaped like one in these comments.
#
# It installs the prebuilt, released agent rather than building from source, like middens.rb in the
# same tap. A source build would be a different binary from the one release-verify executed, and on
# macOS it would carry no Developer ID signature. Each archive holds one top-level directory, which
# Homebrew descends into before `install` runs.
class PessimalAgent < Formula
  desc "Host telemetry agent that exports system metrics over OpenTelemetry (OTLP)"
  homepage "https://github.com/Lightless-Labs/pessimal"
  # Stated rather than inferred: four URLs whose names carry a version and a target triple, both
  # full of digits, are not something to leave to Homebrew's version scanner.
  version "0.1.2"
  license "AGPL-3.0-or-later"

  # Four archives, one per platform the release builds, and no other platform exists: there is no
  # Windows build, and Homebrew runs nowhere else. The macOS binaries are Developer ID signed and
  # notarized; Homebrew fetches with curl, which never sets com.apple.quarantine, so the missing
  # stapled ticket (packaging/macos/GATEKEEPER.md) does not arise on this channel. The Linux binaries
  # need glibc 2.28 or newer.
  on_macos do
    on_arm do
      url "https://github.com/Lightless-Labs/pessimal/releases/download/v0.1.2/pessimal-agent-0.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "e55094254382e5bebbfec7442d1a6cff136603f53ad3aa9d05bc06a924a36997"
    end
    on_intel do
      url "https://github.com/Lightless-Labs/pessimal/releases/download/v0.1.2/pessimal-agent-0.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "33eb57f2a57f97e60454450a7e4840c83e7cd37a747a7fa396c55648d6e2147b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/Lightless-Labs/pessimal/releases/download/v0.1.2/pessimal-agent-0.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "af792ab1ecc758287b267880859629b6a858b8f728ab236e8f40658feed15284"
    end
    on_intel do
      url "https://github.com/Lightless-Labs/pessimal/releases/download/v0.1.2/pessimal-agent-0.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a0c1176422b87e09a99e10dd79b324e987f2811f129fab478622c790849329cd"
    end
  end

  def install
    bin.install "pessimal-agent"
    # The editable config. Homebrew never overwrites an existing file under etc: an edited endpoint,
    # preset or key survives `brew upgrade`, and a changed example arrives beside it as
    # pessimal.toml.default (Library/Homebrew/install_renamed.rb). It is done here rather than in a
    # post_install because Homebrew 7.0.0's style check rejects post_install in a formula.
    cp "pessimal.example.toml", "pessimal.toml"
    (etc/"pessimal").install "pessimal.toml"
    # A pristine copy, for `brew test` and for reference.
    pkgshare.install "pessimal.example.toml"
  end

  # The same shape as scripts/install-agent-launchd.sh's LaunchAgent: the agent reads its config,
  # logs at info, and is restarted if it exits. On Linux, `keep_alive true` becomes the
  # `Restart=on-failure` that packaging/systemd/pessimal-agent.service also uses.
  #
  # The API key is deliberately NOT an environment variable here. `brew services` writes the service
  # definition with mode 0644 (Homebrew 7.0.0, Library/Homebrew/services/cli.rb), so a key placed in
  # environment_variables may be readable by other accounts on the machine. The config file is read
  # by the agent itself, running as the user who started the service, so it can be mode 0600.
  service do
    run [opt_bin/"pessimal-agent", "--config", etc/"pessimal/pessimal.toml"]
    environment_variables PESSIMAL_LOG: "info"
    keep_alive true
    log_path var/"log/pessimal-agent.log"
    error_log_path var/"log/pessimal-agent.log"
  end

  def caveats
    text = <<~EOS
      Set the endpoint and preset in:
        #{etc}/pessimal/pessimal.toml
      If your backend needs a key, set api_key in that file and make it readable by you alone:
        chmod 600 #{etc}/pessimal/pessimal.toml
      Do not give the key to the service as an environment variable: brew services writes the
      service definition with mode 0644, so other accounts on this machine may be able to read it.

      Check the config without exporting anything, then start the service:
        #{opt_bin}/pessimal-agent --config #{etc}/pessimal/pessimal.toml --check
        brew services start pessimal-agent
    EOS
    if OS.mac?
      text += <<~EOS

        If this Mac already runs the agent from Pessimal's scripts/install-agent-launchd.sh (the
        LaunchAgent com.lightless-labs.pessimal.agent), run one or the other, never both: two agents
        report this host twice. Remove that one with:
          scripts/install-agent-launchd.sh --uninstall
      EOS
    end
    text
  end

  test do
    assert_match "pessimal-agent #{version}", shell_output("#{bin}/pessimal-agent --version")
    system bin/"pessimal-agent", "--config", pkgshare/"pessimal.example.toml", "--check"
  end
end
