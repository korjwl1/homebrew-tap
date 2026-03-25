class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.2.0"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v1.2.0/toki-1.2.0-aarch64-apple-darwin.tar.gz"
      sha256 "e5f41e429d544914e07b051e2261f184d2379873f51671c4f575e7d799e1bfef"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v1.2.0/toki-1.2.0-x86_64-apple-darwin.tar.gz"
      sha256 "2c0c37d9353f4547a5122049e5b458e3f54b1b741b1a5f792403635072a73343"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/toki/releases/download/v1.2.0/toki-1.2.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "f871da7cf4af035b4cabbf24fe225d87110777f437513f2e0e940ae977204c4a"
    end
    on_intel do
      url "https://github.com/korjwl1/toki/releases/download/v1.2.0/toki-1.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a40b2d4686c7704b06fe8209e550eeabce770a4503a5f01e5b6bc74f62828238"
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
