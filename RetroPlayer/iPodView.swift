import SwiftUI
import IOKit.ps

struct iPodView: View {
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
                Text("iPod")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.leading, 8)

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

            VStack(spacing: 0) {
                Button(action: {
                    print("Music tapped")
                }) {
                    HStack {
                        Text("Music")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .contentShape(Rectangle())
                    .background(Color.white.opacity(0.1))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.top, 10)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)

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
}
