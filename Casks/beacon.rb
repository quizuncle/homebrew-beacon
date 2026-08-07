cask "beacon" do
  version "0.0.5"

  on_arm do
    sha256 "3ccd273def8d246cfef7853d97945d5b3dc6cb7bf3032d1f61f6bd41ec9f4c32"
    url "https://github.com/quizuncle/beacon-releases/releases/download/v#{version}/Beacon-#{version}-arm64.dmg"
  end
  on_intel do
    sha256 "5eb61f5e1c2fc4b9c9a3bbb56b97336c62dbbb79a1f8bfa69af36287bf4b7b39"
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
