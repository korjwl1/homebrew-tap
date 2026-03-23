cask "toki-monitor" do
  version "0.1.0-alpha3"
  sha256 "c0fc9b5a672747b04f6a11d57eda10c650050af54df5a8786bd7f728cdd6ecec"

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
