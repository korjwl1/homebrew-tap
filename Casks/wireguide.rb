cask "wireguide" do
  version "0.1.2"
  sha256 "331252f76088dca2b10c910a8777eba4fc9d2112033afa8aba75c8834c459ec8"

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
                   args: ["WireGuide"],
                   must_succeed: false
    system_command "/bin/sleep",
                   args: ["1"],
                   must_succeed: false
    system_command "/usr/bin/open",
                   args: ["#{appdir}/WireGuide.app"],
                   must_succeed: false
  end

  uninstall launchctl: "com.wireguide.helper",
            quit: "com.example.wireguide",
            delete: [
              "/Library/PrivilegedHelperTools/com.wireguide.helper",
              "/Library/LaunchDaemons/com.wireguide.helper.plist",
            ]

  zap trash: [
    "~/Library/Application Support/WireGuide",
    "~/Library/Preferences/com.example.wireguide.plist",
    "/var/run/wireguide",
    "/var/log/wireguide-helper.log",
  ]
end
