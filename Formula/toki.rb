class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.1.1"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.1/toki-1.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "02f2fa60e75c9c3845876c596a26c554da7a7f3c635d21c42b8215ade7b583c8"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.1/toki-1.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "b07d95defd2e8b0729d2af4043a53e1b32dafc2792fb06c4a449156c8b9fb455"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.1/toki-1.1.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "588ad7707a6a59d6ce67630dc6b22702a27d3a84e16db9abd54134c5dffca52a"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.1/toki-1.1.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a0d6340298303628bdbde4b3d70a5dd262aeca4c28304e0cf94d4e5e4f2de21f"
    end
  end

  def install
    bin.install "toki"
  end

  def post_install
    # Restart daemon if it was running (picks up new binary)
    pidfile = File.expand_path("~/.config/toki/daemon.pid")
    if File.exist?(pidfile)
      pid = File.read(pidfile).strip.to_i
      if pid > 0
        begin
          Process.kill(0, pid) # check if alive
          ohai "Restarting toki daemon to use the new version..."
          system bin/"toki", "daemon", "restart"
        rescue Errno::ESRCH
          # daemon not running, stale pidfile — nothing to do
        end
      end
    end
  end

  test do
    system "#{bin}/toki", "--version"
  end
end
