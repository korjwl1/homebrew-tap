cask "toki-monitor" do
  version "0.2.4"
  sha256 "133d59b4241c467b48e69d6ae9d714bc6f436f978346c97a41d4ec59936a786d"

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

  # This postflight is the single owner of the post-upgrade app restart. The
  # app's own in-app updater delegates its restart here so the two don't race.
  postflight do
    # Clear the quarantine flag so Gatekeeper doesn't block the freshly
    # downloaded bundle. must_succeed: false — a missing attribute is fine and
    # must not abort the rest of the postflight.
    system_command "/usr/bin/xattr",
                   args:         ["-dr", "com.apple.quarantine", "#{appdir}/TokiMonitor.app"],
                   must_succeed: false

    # Only relaunch if the app was already running. `brew upgrade` swaps the
    # bundle without killing the process, so a live process here means the user
    # had it open and expects it back on the new version. If it wasn't running,
    # leave it closed instead of launching an app they didn't ask for.
    was_running = system_command("/usr/bin/pgrep",
                                 args:         ["-x", "TokiMonitor"],
                                 must_succeed: false).exit_status.zero?
    next unless was_running

    system_command "/usr/bin/killall",
                   args:         ["TokiMonitor"],
                   must_succeed: false
    system_command "/bin/sleep",
                   args:         ["1"],
                   must_succeed: false
    system_command "/usr/bin/open",
                   args:         ["#{appdir}/TokiMonitor.app"],
                   must_succeed: false
  end

  uninstall quit: "com.toki.monitor"

  zap trash: "~/Library/Preferences/com.toki.monitor.plist"
end
