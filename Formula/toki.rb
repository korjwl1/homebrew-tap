class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "2.0.0"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v2.0.0/toki-2.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "c2d690874ca279f6fb50c9a2ca402b9d66519f3f0ea180b3298c5f8777796ed4"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.0.0/toki-2.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "d694748775c87370893c664219a529a47b2b7777bb8b85d7b5974c09d30d111b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v2.0.0/toki-2.0.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "caf2c128af0d31aa19bb77a986538a78a17773e93ee600002e81bbcd477a986d"
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
