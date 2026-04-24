cask "toki-monitor" do
  version "0.2.2"
  sha256 "b16a43a0baec3e548695311d20d0fb3adf3a0fccef295b113b5e4aa36910a644"

  url "https://github.com/korjwl1/toki-monitor/releases/download/v#{version}/TokiMonitor-#{version}.zip"
  name "Toki Monitor"
  desc "macOS menu bar AI token usage monitor powered by toki TSDB engine"
  homepage "https://github.com/korjwl1/toki-monitor"

  depends_on formula: "korjwl1/tap/toki"
  depends_on macos: ">= :sonoma"

  app "TokiMonitor.app"

  uninstall quit: "com.toki.monitor"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/TokiMonitor.app"]
    system_command "/usr/bin/killall",
                   args: ["TokiMonitor"],
                   must_succeed: false
    system_command "/bin/sleep",
                   args: ["1"],
                   must_succeed: false
    system_command "/usr/bin/open",
                   args: ["#{appdir}/TokiMonitor.app"],
                   must_succeed: false
  end

  zap trash: [
    "~/Library/Preferences/com.toki.monitor.plist",
  ]
end
