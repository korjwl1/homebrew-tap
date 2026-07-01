cask "toki-monitor" do
  version "0.2.4"
  sha256 "133d59b4241c467b48e69d6ae9d714bc6f436f978346c97a41d4ec59936a786d"

  url "https://github.com/korjwl1/toki-monitor/releases/download/v#{version}/TokiMonitor-#{version}.zip"
  name "Toki Monitor"
  desc "macOS menu bar AI token usage monitor powered by toki TSDB engine"
  homepage "https://github.com/korjwl1/toki-monitor"

  depends_on formula: "korjwl1/tap/toki"
  depends_on macos: ">= :sonoma"

  # The app has its own in-app UpdateChecker. Without this flag `brew upgrade`
  # and the in-app checker both think they own updates and can race / double-
  # prompt (the root of the "update window won't close" reports). auto_updates
  # tells brew the app updates itself, so brew won't fight it.
  auto_updates true

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
