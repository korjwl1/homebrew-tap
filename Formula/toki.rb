class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.1.0"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0/toki-1.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "fba1cdffbb488bbed3d3da14095f85562dfa3b8b63074ef6bc2d07322dbd5005"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0/toki-1.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "339325500285541cdddf6abfe0a042f757bcadbb5c686015528834c85111b89a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0/toki-1.1.0-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "a98657a6825e75c466b7e6136a149930831694b40c3b58b1195ca5bc2eda84d1"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0/toki-1.1.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "fd51d68a95db20375efef58b4ef883e93de14d31ce386808a16074179b785200"
    end
  end

  def install
    bin.install "toki"
  end

  test do
    system "#{bin}/toki", "--version"
  end
end
