class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.1.5"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.5/toki-1.1.5-aarch64-apple-darwin.tar.gz"
      sha256 "284f31b917def2c492a60ec7726abdee9267a22328a7a2448a552cecb84c6309"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.5/toki-1.1.5-x86_64-apple-darwin.tar.gz"
      sha256 "262110a9231dfcd385e66b80b3df492a10fd80d2e1ce67df26a19558cbc46ad6"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.5/toki-1.1.5-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ac48cf1d391e43ce99cf477699dcb4e88720d070c2ab20da03a5309f83a70b21"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.5/toki-1.1.5-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "efed99bfc75256a56e14c2e69b355dfe1bdc212c4e13422760f9e0662a275dc6"
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
          ohai "Stopping old toki daemon..."
          # Kill directly instead of using old binary (which may be gone)
          Process.kill("TERM", pid)
          # Wait for process to exit
          10.times do
            break unless begin; Process.kill(0, pid); true; rescue Errno::ESRCH; false; end
            sleep 0.5
          end
          # Clean up stale files
          File.delete(pidfile) if File.exist?(pidfile)
          sock = File.expand_path("~/.config/toki/daemon.sock")
          File.delete(sock) if File.exist?(sock)
          # Brief pause for DB lock release
          sleep 1
          ohai "Starting toki daemon with new version..."
          system bin/"toki", "daemon", "start"
        rescue Errno::ESRCH
          # daemon not running, stale pidfile — clean up
          File.delete(pidfile) if File.exist?(pidfile)
        end
      end
    end
  end

  test do
    system "#{bin}/toki", "--version"
  end
end
