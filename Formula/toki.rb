class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "2.2.0"
  license "FSL-1.1-Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v2.2.0/toki-2.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "786353345f05796b87baa05f0b11f404ddf8954b78f92b3a4fe1de630da6e6dd"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.2.0/toki-2.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "e28208308dcd080f477106e6504e9e4eb4ae61e251441a0fa8de02be703cd804"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v2.2.0/toki-2.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "4262a5c17d2189c78800775d213b6304d7310156f2bf70afc59777c49b4ec2fa"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.2.0/toki-2.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e33fa811a2bdf2006e66f49b8fa32120206505e55abaaa47f61b9723cdd19056"
    end
  end

  def install
    bin.install "toki"
  end

  def post_install
    pidfile = File.expand_path("~/.config/toki/daemon.pid")
    return unless File.exist?(pidfile)

    pid = File.read(pidfile).strip.to_i
    return unless pid.positive?

    # Is the daemon actually alive? kill(0) raises ESRCH if the process is gone,
    # or EPERM if it exists but is owned by another user (still "running").
    running = begin
      Process.kill(0, pid)
      true
    rescue Errno::EPERM
      true
    rescue Errno::ESRCH
      false
    end
    return unless running

    ohai "Restarting toki daemon to use the new version..."
    system bin/"toki", "daemon", "restart"
  rescue => e
    # Never let a daemon-restart hiccup fail the whole upgrade; the worst case is
    # a stale daemon the user can restart manually with `toki daemon restart`.
    opoo "toki daemon restart skipped (#{e.message}); run `toki daemon restart` manually"
  end

  def caveats
    <<~EOS
      The toki daemon collects usage in the background. When you run the
      Toki Monitor app it manages the daemon for you, so no extra setup is
      needed.

      If you use the CLI on its own (no menu bar app), start the daemon now
      and enable auto-start on login:

        toki daemon start
        toki daemon enable

      Undo it later with `toki daemon disable`.
    EOS
  end

  test do
    system "#{bin}/toki", "--version"
  end
end
