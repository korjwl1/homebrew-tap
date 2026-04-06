cask "wireguide" do
  version "0.1.1"
  sha256 "a59d005ed3d04e8560f168eac3c44253157b495a68e8b5286ce0364e6c7ea14f"

  url "https://github.com/korjwl1/wireguide/releases/download/v#{version}/WireGuide-macOS-arm64.zip"
  name "WireGuide"
  desc "Cross-platform WireGuard VPN desktop client"
  homepage "https://github.com/korjwl1/wireguide"

  depends_on macos: ">= :catalina"

  app "WireGuide.app"

  postflight do
    # Remove quarantine flag
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/WireGuide.app"]

    # Install LaunchDaemon for password-free helper lifecycle.
    # Copies the binary to /Library/PrivilegedHelperTools/ and the plist
    # to /Library/LaunchDaemons/, then loads the daemon. After this,
    # the helper starts at boot and the app never asks for a password.
    helper_src = "#{appdir}/WireGuide.app/Contents/MacOS/WireGuide"
    helper_dst = "/Library/PrivilegedHelperTools/com.wireguide.helper"
    plist_src = "#{staged_path}/WireGuide.app/Contents/Resources/com.wireguide.helper.plist"
    plist_dst = "/Library/LaunchDaemons/com.wireguide.helper.plist"

    # Copy binary
    system_command "/bin/cp", args: ["-f", helper_src, helper_dst], sudo: true
    system_command "/usr/sbin/chown", args: ["root:wheel", helper_dst], sudo: true
    system_command "/bin/chmod", args: ["755", helper_dst], sudo: true

    # Copy and template plist with current user UID
    uid = Process.uid.to_s
    plist_content = File.read("#{appdir}/WireGuide.app/Contents/MacOS/../Resources/com.wireguide.helper.plist") rescue nil
    if plist_content.nil?
      # Plist not bundled in Resources — use the one from build/darwin/ via staged_path
      plist_content = File.read(plist_src) rescue nil
    end
    if plist_content
      plist_content.gsub!("__UID__", uid)
      File.write("/tmp/com.wireguide.helper.plist", plist_content)
      system_command "/bin/cp", args: ["-f", "/tmp/com.wireguide.helper.plist", plist_dst], sudo: true
      system_command "/usr/sbin/chown", args: ["root:wheel", plist_dst], sudo: true
      system_command "/bin/chmod", args: ["644", plist_dst], sudo: true
      system_command "/bin/rm", args: ["-f", "/tmp/com.wireguide.helper.plist"]
    end

    # Load daemon
    system_command "/bin/launchctl", args: ["load", "-w", plist_dst], sudo: true
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
