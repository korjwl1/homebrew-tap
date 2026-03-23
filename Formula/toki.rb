class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.1.4"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.4/toki-1.1.4-aarch64-apple-darwin.tar.gz"
      sha256 "f7b5c8f46f62a390ec556110176c60763a2cfcac557e2b5dc8db02dbd09264d8"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.4/toki-1.1.4-x86_64-apple-darwin.tar.gz"
      sha256 "f90f61a635706e0e6c29df30e8c3ef1ba7a0dc3f6303e3dddd0f70f7e4ac4b47"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.4/toki-1.1.4-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6054a380a1450fb7f5b4ef2fed7f69444effb36879738f514a7832e709747bb7"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.4/toki-1.1.4-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "998af901106ab68f9fd6cb3b99f6990527e946e2edcba9805e1c0530c5fff14d"
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
