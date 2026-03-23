cask "toki-monitor" do
  version "0.1.1-alpha"
  sha256 "5168f7f6466dbc7b50b609ba6920d36c4f040aa057a4e82849e5589d646419e1"

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
