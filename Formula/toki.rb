class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "2.3.0"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v2.3.0/toki-2.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "4f1e957bde695c880066b465ade6794bf1a4ddc1400ff80c0929927ac2bde07f"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.3.0/toki-2.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "518a1ce0b5d8cf8f183a4e0ca69789d21f7b31ccdfe0944c8ac9cd6b3bf7e3d0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v2.3.0/toki-2.3.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "d41503171babd291990ee6539631dcb0145c51fd38e2d3393aed11d10f6e09bb"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.3.0/toki-2.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fc9528b8d4bda14e44a632b982fa1e3c1fcbf14678407e9c72f51342450364a6"
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
