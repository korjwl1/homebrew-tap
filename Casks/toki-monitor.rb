cask "toki-monitor" do
  version "0.2.0"
  sha256 "25a5efb081cef6e458c2418a5c06df225b487abbe774db90c4af213fd357d73e"

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
