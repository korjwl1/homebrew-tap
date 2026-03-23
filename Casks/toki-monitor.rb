cask "toki-monitor" do
  version "0.1.0-alpha4"
  sha256 "341d5c6a1e2f6a721e4ef6b3d3189fbc9365af14c6101d8886dc45e3ad3c06b4"

  url "https://github.com/korjwl1/homebrew-tap/releases/download/toki-monitor-v#{version}/TokiMonitor-#{version}.zip"
  name "Toki Monitor"
  desc "macOS menu bar AI token usage monitor powered by toki TSDB engine"
  homepage "https://github.com/korjwl1/toki-monitor"

  depends_on formula: "korjwl1/tap/toki"
  depends_on macos: ">= :sonoma"

  app "TokiMonitor.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/TokiMonitor.app"]
  end

  zap trash: [
    "~/Library/Preferences/com.toki.monitor.plist",
  ]
end
