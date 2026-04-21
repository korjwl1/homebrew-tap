cask "wireguide" do
  version "0.1.9"
  sha256 "91eb4f7b100d6e953487b7bdca7b2ed5cf0a2d565425510e32eaabeb8a2ae735"

  url "https://github.com/korjwl1/wireguide/releases/download/v#{version}/WireGuide-macOS-arm64.zip"
  name "WireGuide"
  desc "Cross-platform WireGuard VPN desktop client"
  homepage "https://github.com/korjwl1/wireguide"

  depends_on macos: ">= :catalina"

  app "WireGuide.app"

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
