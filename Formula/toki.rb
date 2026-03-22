class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.1.3"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.3/toki-1.1.3-aarch64-apple-darwin.tar.gz"
      sha256 "d687eab72b34bed04d59c0ac48609eb78addf9ef481f4644cf0002e58a9488aa"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.3/toki-1.1.3-x86_64-apple-darwin.tar.gz"
      sha256 "383be9f2874bcf8ed8feee5058818d478f0fb850a1c71d1a92f481ede2f8b2c2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.3/toki-1.1.3-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "359e0c7439c81d4527cd371480d03b292805793270f0b6b92347a876ba67cb7f"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.3/toki-1.1.3-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "7dc6eade3a50388e2fe048a6e06e0434a4fc141b729ea0332953a9f4563ed410"
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
