cask "wireguide" do
  version "0.1.0"
  sha256 "a61572b77a0e44b99b5f650e56490d3b84ba9985545b7d94c3b91d4c10a8e746"

  url "https://github.com/korjwl1/wireguide/releases/download/v#{version}/WireGuide-v#{version}-macOS-arm64.zip"
  name "WireGuide"
  desc "Cross-platform WireGuard VPN desktop client"
  homepage "https://github.com/korjwl1/wireguide"

  depends_on macos: ">= :catalina"

  app "WireGuide.app"

  uninstall quit: "com.korjwl1.wireguide"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/WireGuide.app"]
  end

  zap trash: [
    "~/Library/Application Support/wireguide",
    "~/Library/Logs/WireGuide",
  ]
end
