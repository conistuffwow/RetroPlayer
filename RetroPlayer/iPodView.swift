import SwiftUI
import IOKit.ps
import iTunesLibrary

enum MenuLevel {
    case root
    case music
    case allMusic
}

struct iPodView: View {
    @State private var menuLevel: MenuLevel = .root
    private let musicManager = MusicLibraryManager()
    @State private var songs: [ITLibMediaItem]
    
    public init(songs: [ITLibMediaItem]) {
        self.songs = songs
    }
    
    @Namespace private var transition
    var batteryInfo: (Int, Bool) {
        let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
        let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array

        for ps in sources {
            if let info = IOPSGetPowerSourceDescription(snapshot, ps).takeUnretainedValue() as? [String: Any],
               let currentCapacity = info[kIOPSCurrentCapacityKey as String] as? Int,
               let maxCapacity = info[kIOPSMaxCapacityKey as String] as? Int,
               let isCharging = info[kIOPSIsChargingKey as String] as? Bool {
                let percent = Int((Double(currentCapacity) / Double(maxCapacity)) * 100)
                return (percent, isCharging)
            }
        }
        return (100, false)
    }

    var batteryIcon: String {
        let (level, charging) = batteryInfo
        if charging { return "battery.100.bolt" }
        switch level {
        case 90...100: return "battery.100"
        case 60..<90: return "battery.75"
        case 30..<60: return "battery.50"
        case 10..<30: return "battery.25"
        default: return "battery.0"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if menuLevel != .root {
                    Button(action: {
                        switch menuLevel {
                        case .music: menuLevel = .root
                        case .allMusic: menuLevel = .music
                        default: break
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 12))
                        Text("Back")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Text("iPod")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.leading, 8)
                }

                Spacer()

                HStack(spacing: 4) {
                    Text("\(batteryInfo.0)%")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                    Image(systemName: batteryIcon)
                        .foregroundColor(.white)
                }
                .padding(.trailing, 8)
            }
            .frame(height: 24)
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.6))

            // Main animated content
            ZStack {
                if menuLevel == .root {
                    mainMenu
                        .transition(.move(edge: .trailing))
                }

                if menuLevel == .music {
                    musicMenu
                        .transition(.move(edge: .trailing))
                }

                if menuLevel == .allMusic {
                    allMusicMenu
                        .transition(.move(edge: .trailing))
                }
            }
            .animation(.easeInOut, value: menuLevel)

            Spacer()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.red, .black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    var mainMenu: some View {
        VStack(spacing: 0) {
            menuItem(title: "Music") {
                menuLevel = .music
            }
        }
        .padding(.top, 10)
    }

    var musicMenu: some View {
        VStack(spacing: 0) {
            menuItem(title: "All Music") {
                songs = musicManager.allSongs()
                menuLevel = .allMusic
                
            }
            menuItem(title: "Playlists") {}
                .opacity(0.5)
            menuItem(title: "Albums") {}
                .opacity(0.5)
        }
        .padding(.top, 10)
    }

    var allMusicMenu: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(songs, id: \.persistentID) { item in
                HStack {
                    Text(item.title ?? "Unknown")
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                    Spacer()
                }
                .background(Color.white.opacity(0.08))
            }
        }
        .padding(.top, 10)
    }

    func menuItem(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.6))
                    .font(.system(size: 11))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(Color.black.opacity(0.2))
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }

    var mockSongs: [String] {
        [
            "01 - Boulevard of Broken Dreams",
            "02 - Take On Me",
            "03 - Smells Like Teen Spirit",
            "04 - Africa",
            "05 - Song 2",
            "06 - Piano Man",
            "07 - Yellow Submarine"
        ]
    }
}
