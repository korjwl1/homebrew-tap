cask "wireguide" do
  version "0.4.0"
  sha256 "58fac8897eab924518d1720cf23d72d345f80e4a1970b18d2c6e5f6e49c2dd71"

  url "https://github.com/korjwl1/wireguide/releases/download/v#{version}/WireGuide-darwin-arm64.zip"
  name "WireGuide"
  desc "Cross-platform WireGuard VPN desktop client"
  homepage "https://github.com/korjwl1/wireguide"

  depends_on macos: ">= :catalina"

  app "WireGuide.app"

  # Symlink the CLI onto PATH (Homebrew's bin), so users get a
  # global `wireguide ctl ...` after `brew install` instead of
  # the in-bundle `/Applications/WireGuide.app/Contents/MacOS/wireguide`.
  binary "#{appdir}/WireGuide.app/Contents/MacOS/wireguide"

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
