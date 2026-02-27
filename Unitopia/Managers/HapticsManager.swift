//
//  HapticsManager.swift
//  Unitopia
//
//  Created by Justin Hold on 2/27/26.
//

import CoreHaptics

/// Manages the Core Haptics engine lifecycle and playback for the app.
///
/// Create one instance and hold it as a `@State` or `@StateObject` in the owning view.
/// Call `prepare()` once on appear, then call `playResetPattern()` whenever haptic
/// feedback is needed.
class HapticsManager {

    private var engine: CHHapticEngine?

    // MARK: - Engine Lifecycle

    /// Initializes and starts the haptic engine if the hardware supports haptics.
    ///
    /// Safe to call multiple times — subsequent calls are no-ops if the engine is
    /// already running. A `resetHandler` is installed so the engine automatically
    /// restarts after system audio interruptions.
    func prepare() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        guard engine == nil else { return }

        do {
            engine = try CHHapticEngine()
            engine?.resetHandler = { [weak self] in
                try? self?.engine?.start()
            }
            try engine?.start()
        } catch {
            print("HapticsManager: failed to create engine — \(error.localizedDescription)")
        }
    }

    // MARK: - Patterns

    /// Plays a two-wave transient haptic pattern suitable for a reset action.
    ///
    /// The first wave ramps intensity up while sharpness falls; the second wave
    /// mirrors the intensity descent, producing a satisfying double-pulse feel.
    func playResetPattern() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        var events = [CHHapticEvent]()

        // First wave: increasing intensity, decreasing sharpness
        for i in stride(from: 0.0, to: 1.0, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            events.append(CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: i
            ))
        }

        // Second wave: decreasing intensity, continuing to fall in sharpness
        for i in stride(from: 0.0, to: 1.0, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            events.append(CHHapticEvent(
                eventType: .hapticTransient,
                parameters: [intensity, sharpness],
                relativeTime: 1 + i
            ))
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("HapticsManager: failed to play pattern — \(error.localizedDescription)")
        }
    }
}
