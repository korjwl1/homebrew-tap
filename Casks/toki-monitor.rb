cask "toki-monitor" do
  version "0.1.0-alpha2"
  sha256 "31665da4a0b58782a30ca3b64571f24b251a22d1fe5a078ea271fc3a11169d0c"

  url "https://github.com/korjwl1/toki-monitor/releases/download/v#{version}/TokiMonitor-#{version}.zip"
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
