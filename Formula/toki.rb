class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.1.8"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.8/toki-1.1.8-aarch64-apple-darwin.tar.gz"
      sha256 "024108520fff214a15f680cd5c5b7728c520f7b054ea837da10c23f26f06d3d0"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.8/toki-1.1.8-x86_64-apple-darwin.tar.gz"
      sha256 "085d5335d94ea0b2120ec492879fa8f9e159d5116f18cf16beda24058107b47d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.8/toki-1.1.8-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "212d23330b4fdc3e6c20f80b064ce22a62f30b12b4f33d00a15786a1e120c9f1"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v1.1.8/toki-1.1.8-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "b0d9f597d1ce50e5726dc81c9777fdf02f3f08e6e4de5446e1a33edb9471a10f"
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
