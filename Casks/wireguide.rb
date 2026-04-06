cask "wireguide" do
  version "0.1.1"
  sha256 "4843990de5342c298c9cf7387adafea3141e4afadca5f23ef207aa816ec15788"

  url "https://github.com/korjwl1/wireguide/releases/download/v#{version}/WireGuide-macOS-arm64.zip"
  name "WireGuide"
  desc "Cross-platform WireGuard VPN desktop client"
  homepage "https://github.com/korjwl1/wireguide"

  depends_on macos: ">= :catalina"

  app "WireGuide.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/WireGuide.app"]
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
