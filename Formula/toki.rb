class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "2.1.0"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v2.1.0/toki-2.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "2e02f220430de8b9f8ab0f1fa220a497d54e602d39c4bf4ad6ab4c4ce3cce35a"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.1.0/toki-2.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "e890d1337fc091f1edbe0d7138d83cee8e5286239ecee437c967ff8999720ee4"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v2.1.0/toki-2.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "1231787b369d00318c4c90225c4abefaf78a5dbd042eeb3bd8c817e702fe2fbc"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.1.0/toki-2.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "5cada083521b52c75f207664050a8119cff6b08c5eb16d0baf08367ca667f7f3"
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
