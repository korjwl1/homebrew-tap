cask "wireguide" do
  version "0.1.0"
  sha256 "797c26ef00c2730fe6c181d96a9af57e91fef0690758a00881ce50de45e6af23"

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

  uninstall quit: "com.example.wireguide"

  zap trash: [
    "~/Library/Application Support/WireGuide",
    "~/Library/Preferences/com.example.wireguide.plist",
  ]
end
