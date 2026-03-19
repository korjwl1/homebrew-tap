class Toki < Formula
  desc "AI CLI tool token usage tracker"
  homepage "https://github.com/korjwl1/toki"
  version "1.1.0-alpha1"
  license "FSL-1.1-Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0-alpha1/toki-1.1.0-alpha1-aarch64-apple-darwin.tar.gz"
      sha256 "6553443a6b969b88260c55d8790d38e4071ff4ee276b4d2c7b71587644562cbe"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0-alpha1/toki-1.1.0-alpha1-x86_64-apple-darwin.tar.gz"
      sha256 "8b6ab4256629a31becc3d76685ac1c06ed2094d9f622f944b9e4ee21b6494365"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0-alpha1/toki-1.1.0-alpha1-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0cc7f536746417c545da5f61b06f4b3d6aa9a66488ce1c4af972889eec90f7df"
    end
    on_intel do
      url "https://github.com/korjwl1/homebrew-tap/releases/download/v1.1.0-alpha1/toki-1.1.0-alpha1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "256e8e439134a1d08a477177fb5e7be9ad24db72faebd9695cea4353abd41a39"
    end
  end

  def install
    bin.install "toki"
  end

  test do
    system "#{bin}/toki", "--version"
  end
end
