cask "beacon" do
  version "0.0.6"

  on_arm do
    sha256 "ba9d17441885e956ccbc87f0dae5b44354107a644892a95118452672c4ab4cce"
    url "https://github.com/quizuncle/beacon-releases/releases/download/v#{version}/Beacon-#{version}-arm64.dmg"
  end
  on_intel do
    sha256 "344b6045acaf829ee10d40d848f1df197d822ff9136460b4792b194dac5cefcf"
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
