//
//  HapticFeedback.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 20/05/2023.
//

import SwiftUI
import CoreHaptics
import AudioToolbox // Cho các dóng máy cũ không support Haptic

struct HapticFeedback: View {
    
    private let isSupportHaptic: Bool = CHHapticEngine.capabilitiesForHardware().supportsHaptics
    /// haptic sẽ không hoạt động khi điện thoại đang sử dụng micro
    /// và người dùng cần bật tính năng haptic trên điện thoại: Settings -> Sounds & Haptics -> System Haptics
    
    private let impactFeedback: UIImpactFeedbackGenerator = .init(style: .rigid)
    /// Thường sử dụng cho các sự kiện như va chạm, khớp nối các View
    
    private let notiFeedback: UINotificationFeedbackGenerator = .init()
    /// Thường sử dụng cho các sự kiện thông báo đến người dùng kết quả của một tác vụ
    
    private let selectFeedback: UISelectionFeedbackGenerator = .init()
    /// Thường sử dụng cho các sự kiện chuyển động, thay đổi qua một loạt các giá trị khác nhau
    
    /// ==================
    /// Tạo một haptic tuỳ chỉnh (từ iOS 13 trở đi)
    @State private var engine: CHHapticEngine? = nil
    
    var body: some View {
        Button("Run haptic") {
            
            if isSupportHaptic {
                impactFeedback.impactOccurred(intensity: 1.0)
                notiFeedback.notificationOccurred(.success)
                selectFeedback.selectionChanged()
            } else {
                AudioServicesPlaySystemSound(1519)
                /// Sử dụng cho các dòng máy cũ < iPhone 7
                /// Mạnh dần lên với tham số 1520 và 1521
            }
            
        }
        .onAppear { creatHaptic() }
    }
    
    private func creatHaptic() {
        guard isSupportHaptic else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
            
            /// The engine stopped; print out why
            engine?.stoppedHandler = { reason in
                print("The engine stopped: \(reason)")
            }
            
            /// If something goes wrong, attempt to restart the engine immediately
            engine?.resetHandler = {
                print("The engine reset")
                do {
                    try engine?.start()
                } catch {
                    print("Failed to restart the engine: \(error)")
                }
            }
            
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    private func useHaptic() {
        /// Refer:
        /// https://www.hackingwithswift.com/example-code/core-haptics/how-to-play-custom-vibrations-using-core-haptics
        /// https://exyte.com/blog/creating-haptic-feedback-with-core-haptics
        
        guard isSupportHaptic else { return }
        
        guard let url = Bundle.main.url(forResource: "confirmation", withExtension: "wav") else { return }
        let resourceId = try! engine?.registerAudioResource(url, options: [:])
        let audioEvent = CHHapticEvent(audioResourceID: resourceId!, parameters: [], relativeTime: 0)
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i)) /// value nhận giá trị từ 0 đến 1
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
            /// Haptic Transient: Sử dụng như các xung lực ngắn
            /// Haptic Continuous: Haptic vẫn chạy, thời gian kéo dài tối đa đến 30s (với tham số duration)
        }
        events.append(audioEvent)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

struct HapticFeedback_Previews: PreviewProvider {
    static var previews: some View {
        HapticFeedback()
    }
}
