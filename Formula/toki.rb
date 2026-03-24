class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.1.6"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.6/toki-1.1.6-aarch64-apple-darwin.tar.gz"
      sha256 "56c32a13da372e778579a8fdecf6d35c2db0e43c8434bfd0180d7f63675decd7"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.6/toki-1.1.6-x86_64-apple-darwin.tar.gz"
      sha256 "c4e74a68957c33f5abdb39048dce9f0643d18acc4711a0b73c111df1d0340373"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.6/toki-1.1.6-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "6d88156aa7dd22019dc669e485cbbfd64f342d884527979387c576fbc37cd564"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.6/toki-1.1.6-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8155218b30f6935a0dea274cc31f1fddc7a4b4b392d9c2310c0defdf133ef1d7"
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
          Process.kill("TERM", pid)
          exited = false
          10.times do
            sleep 0.5
            unless begin; Process.kill(0, pid); true; rescue Errno::ESRCH; false; end
              exited = true
              break
            end
          end
          unless exited
            Process.kill("KILL", pid) rescue nil
            sleep 0.5
          end
          File.delete(pidfile) if File.exist?(pidfile)
          sock = File.expand_path("~/.config/toki/daemon.sock")
          File.delete(sock) if File.exist?(sock)
          sleep 1
          ohai "Starting toki daemon with new version..."
          system bin/"toki", "daemon", "start"
        rescue Errno::ESRCH
          File.delete(pidfile) if File.exist?(pidfile)
        end
      end
    end
  end

  test do
    system "#{bin}/toki", "--version"
  end
end
