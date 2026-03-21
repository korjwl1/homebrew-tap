class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.1.0"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0/toki-1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "e575c1d290529cbb48ebce912c89f58fd2a0540865af7d296d3d251096dde853"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0/toki-1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "0a3998d2224d2ef24f39a475e3f40f131a6e37a0744a2fae1e676dff53cf31a8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0/toki-1.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "9960d5c3c6f0462b37f9189ae32bd6d9ca4d20ad1560eb4df7c6cc2fdd99a02e"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0/toki-1.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "47a8aba27fd0b1bdc034aac1723d8c541ba91f0fbb97bec928bb9180987938ff"
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
