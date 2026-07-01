class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "2.1.1"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v2.1.1/toki-2.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "4e17a6f5ad695dc42db57c3a7d0f7ee9413cc5924a23abdb1c2dbc34a88603a0"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.1.1/toki-2.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "fc55cc33a4a00b5f884578528d71312ea5c8ac5e78a57bdc928309fe59f4b4a5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v2.1.1/toki-2.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "96579534866de961afffa9696de11bbc657f38e6237c654fec9768cf5c1077e9"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.1.1/toki-2.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c6a692e9fccbc8db01a5942164ce0ad5a2149aeb97a9b0ad5a38e349b25062ae"
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

  test do
    system "#{bin}/toki", "--version"
  end
end
