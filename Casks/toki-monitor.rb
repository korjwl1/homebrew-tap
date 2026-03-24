cask "toki-monitor" do
  version "0.1.2"
  sha256 "0b65fd786cd7e06f4dcb9e3e09cc7dbdf881886ed691b3c4aee1201253484ebb"

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
