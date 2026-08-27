cask "toki-monitor" do
  version "0.3.0"
  sha256 "8942875ed8f7d85d8f1f530e17487c172480eb049d185d8fb60597b666d763de"

  url "https://github.com/korjwl1/toki-monitor/releases/download/v#{version}/TokiMonitor-#{version}.zip"
  name "Toki Monitor"
  desc "Menu bar AI token usage monitor powered by toki TSDB engine"
  homepage "https://github.com/korjwl1/toki-monitor"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The app has its own in-app UpdateChecker. Without this flag `brew upgrade`
  # and the in-app checker both think they own updates and can race / double-
  # prompt (the root of the "update window won't close" reports). auto_updates
  # tells brew the app updates itself, so brew won't fight it.
  auto_updates true
  depends_on formula: "korjwl1/tap/toki"
  depends_on macos: :sonoma

  app "TokiMonitor.app"

  postflight do
    # Clear the quarantine flag so Gatekeeper doesn't block the freshly
    # downloaded bundle. must_succeed: false — a missing attribute is fine and
    # must not abort the rest of the postflight.
    system_command "/usr/bin/xattr",
                   args:         ["-dr", "com.apple.quarantine", "#{appdir}/TokiMonitor.app"],
                   must_succeed: false
  end

  # `uninstall quit` is the single owner of the upgrade restart: brew quits the
  # app by bundle id before swapping the bundle and reopens it afterwards only
  # if it was running (and respects `--no-quit`). The app's in-app updater
  # delegates its restart here so the two don't race.
  uninstall quit: "com.toki.monitor"

  zap trash: "~/Library/Preferences/com.toki.monitor.plist"
end
