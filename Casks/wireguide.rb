cask "wireguide" do
  version "0.3.1"
  sha256 "0b257d6826f8c9f124507821ceea369d972d5d9b17a3f6c133f013007679965d"

  url "https://github.com/korjwl1/wireguide/releases/download/v#{version}/WireGuide-darwin-arm64.zip"
  name "WireGuide"
  desc "Cross-platform WireGuard VPN desktop client"
  homepage "https://github.com/korjwl1/wireguide"

  depends_on macos: ">= :catalina"

  app "WireGuide.app"

  # auto_updates true tells `brew upgrade` to defer to the
  # app's own update mechanism, which prevents brew + the
  # in-app scheduler from racing to upgrade the same install
  # (the wireguide RunUpdate path also shells out to brew, so
  # without this flag a user clicking "Update Now" while brew
  # is auto-upgrading hits a lock contention).
  auto_updates true

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/WireGuide.app"]
    system_command "/usr/bin/killall",
                   args: ["wireguide"],
                   must_succeed: false
    system_command "/bin/sleep",
                   args: ["1"],
                   must_succeed: false
    system_command "/usr/bin/open",
                   args: ["#{appdir}/WireGuide.app"],
                   must_succeed: false
  end

  uninstall quit: "com.korjwl1.wireguide"

  zap launchctl: "com.wireguide.helper",
      delete: [
        "/Library/PrivilegedHelperTools/com.wireguide.helper",
        "/Library/LaunchDaemons/com.wireguide.helper.plist",
      ],
      trash: [
        "~/Library/Application Support/WireGuide",
        "~/Library/Preferences/com.korjwl1.wireguide.plist",
        "/var/run/wireguide",
        "/var/log/wireguide-helper.log",
      ]
end
