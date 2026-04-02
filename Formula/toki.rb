class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "2.0.1"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v2.0.1/toki-2.0.1-aarch64-apple-darwin.tar.gz"
      sha256 "870c5045a45f16d2b627b6cbbd184e19d2465a3afeb00a3f83e3f6fdc7c64250"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.0.1/toki-2.0.1-x86_64-apple-darwin.tar.gz"
      sha256 "d6010e5a181b84359862e2469c43f3d87ca52162122b088eed654d5c9cca3fc0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v2.0.1/toki-2.0.1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a7ff8eef6c6a7225e459d4babbf13d4014c1748f427697098984e681cf49b39c"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.0.1/toki-2.0.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b8566e5f799b8e2ad3a9b0dbc2d1a6ddc227b6b33e01ec5b956ff980d2a54d6a"
    end
  end

  def install
    bin.install "toki"
  end

  def post_install
    pidfile = File.expand_path("~/.config/toki/daemon.pid")
    if File.exist?(pidfile)
      pid = File.read(pidfile).strip.to_i
      if pid > 0
        begin
          Process.kill(0, pid)
          ohai "Restarting toki daemon to use the new version..."
          system bin/"toki", "daemon", "restart"
        rescue Errno::ESRCH
        end
      end
    end
  end

  test do
    system "#{bin}/toki", "--version"
  end
end
