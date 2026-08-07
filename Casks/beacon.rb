cask "beacon" do
  version "0.0.5"

  on_arm do
    sha256 "c489a52dcf3e226a766bd495e43607225d838db9b0358d6b48e48f4aa31b9519"
    url "https://github.com/quizuncle/beacon-releases/releases/download/v#{version}/Beacon-#{version}-arm64.dmg"
  end
  on_intel do
    sha256 "18abee2d9590f7298ada4c17955d5c4967328e4df6f3ea8d59a06644eee02a4f"
    url "https://github.com/quizuncle/beacon-releases/releases/download/v#{version}/Beacon-#{version}.dmg"
  end

  name "Beacon"
  desc "Keyboard-first desktop API client (Postman-style)"
  homepage "https://github.com/quizuncle/beacon-releases"

  # Beacon.app's Info.plist sets LSMinimumSystemVersion 12.0, so declare the same
  # floor here. Without it, Homebrew installs happily onto older macOS and the app
  # then fails to launch, and "brew audit --online" fails the cask outright with
  # "Artifact defined :monterey ... but the cask declared no minimum".
  depends_on macos: ">= :monterey"

  app "Beacon.app"

  # Beacon isn't notarized (no paid Apple Developer subscription) — clear the
  # quarantine flag Gatekeeper attaches on download so the app opens normally
  # instead of macOS refusing to launch it as "from an unidentified developer".
  postflight do
    system_command "/usr/bin/xattr",
                    args: ["-cr", "#{appdir}/Beacon.app"],
                    sudo: false
  end

  zap trash: [
    "~/Library/Application Support/Beacon",
    "~/Library/Saved Application State/com.vivek.beacon.savedState",
    "~/Library/Preferences/com.vivek.beacon.plist",
  ]
end
