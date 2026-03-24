class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.1.7"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.7/toki-1.1.7-aarch64-apple-darwin.tar.gz"
      sha256 "70b645d5ae8b5b1b11142e935ba5603ea3d58a970dec94cf172154e3a1de1454"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.7/toki-1.1.7-x86_64-apple-darwin.tar.gz"
      sha256 "a0aa9dc553d808913885537b332784beb1598743f7fac6d87aaae3bfb62c7730"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.7/toki-1.1.7-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "bef9b6857a0016a4294599073caea60055b21f7ff7a5028666826c385521bda1"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.7/toki-1.1.7-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2a226bba4fb956aec177ba05c786f636b2d71f5d60e0e1d90049da9632f02453"
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
