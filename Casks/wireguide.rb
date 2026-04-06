cask "wireguide" do
  version "0.1.4"
  sha256 "5b9a094ba2f8411b9e90d907ba1e7ba7fed720e231439278a4d0435f8f0ce030"

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
