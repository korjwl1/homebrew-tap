class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.1.2"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.2/toki-1.1.2-aarch64-apple-darwin.tar.gz"
      sha256 "011f46ee2aaa98421593f63b91d0dc6fa41292773422c1586f993b75c07736b8"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.2/toki-1.1.2-x86_64-apple-darwin.tar.gz"
      sha256 "389673b6dc38de7d1877fdf073b93c1ea2487b022a1a2b8a89e6f9a57d0ad2c7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.2/toki-1.1.2-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6a7e214c11c126fc9250a2dae981ff265e1d3e39bb53632ecb94791f8ea3abc5"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.2/toki-1.1.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "c1a42cd5220afc6d69ef7c9aa4b8a742b6a0d75057f6d6b733d786b14463b5d5"
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
