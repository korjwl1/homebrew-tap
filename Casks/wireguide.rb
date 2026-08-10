cask "wireguide" do
  version "0.5.0"
  sha256 "d6487bb1fced12bc616bdf0caaff969aa05651d153fe4053cabfefa3bf981eee"

  url "https://github.com/korjwl1/wireguide/releases/download/v#{version}/WireGuide-darwin-arm64.zip"
  name "WireGuide"
  desc "Cross-platform WireGuard VPN desktop client"
  homepage "https://github.com/korjwl1/wireguide"

  depends_on macos: :catalina

  app "WireGuide.app"

  # Symlink the CLI onto PATH (Homebrew's bin), so users get a
  # global `wireguide ctl ...` after `brew install` instead of
  # the in-bundle `/Applications/WireGuide.app/Contents/MacOS/wireguide`.
  binary "#{appdir}/WireGuide.app/Contents/MacOS/wireguide"

  # NOTE: deliberately NOT auto_updates. The app has no self-updater
  # (its in-app "Update Now" shells out to brew), so the flag's only
  # real effect was making `brew upgrade` skip this cask — and on older
  # Homebrew even a named `brew upgrade wireguide` skipped it with exit
  # 0, stranding installs on old versions while reporting success
  # (korjwl1/wireguide#38: an install pinned at 0.3.1 for three months).
  # Brew's own lock handles concurrent upgrade attempts; re-add the flag
  # only if the app ever ships a real self-updater.

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
