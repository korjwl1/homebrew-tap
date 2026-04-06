cask "wireguide" do
  version "0.1.0"
  sha256 "797c26ef00c2730fe6c181d96a9af57e91fef0690758a00881ce50de45e6af23"

  url "https://github.com/korjwl1/wireguide/releases/download/v#{version}/WireGuide-macOS-arm64.zip"
  name "WireGuide"
  desc "Cross-platform WireGuard VPN desktop client"
  homepage "https://github.com/korjwl1/wireguide"

  app "WireGuide.app"

  zap trash: [
    "~/Library/Application Support/WireGuide",
    "~/Library/Preferences/com.example.wireguide.plist",
  ]
end
