//
//  Snapshot.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 27/05/2023.
//

import SwiftUI

struct Snapshot: View {
    
    @State private var qrCode: String = ""
    @State private var capture: UIImage?
    @State private var snapshotMaker: SnapshotMaker = .init() /// fallback iOS < 16.0
    @StateObject private var imageSaver: ImageSaver = .init()
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.displayScale) private var displayScale
    
    var body: some View {
        VStack {
            TextField("Code", text: $qrCode).padding(.horizontal, 40)
            VStack {
                testView.snapshot(assign: $snapshotMaker)
                Button("Capture") {
                    let render = ImageRenderer(content: testView)
                    /// render.scale = displayScale (crash nếu view render đã có kích thước lớn, ở đây là mã QR đã được transform 100X
                    /// Đã thử và xác nhận rằng bỏ render.scale hoặc bỏ transformed(by: transform) (trong generateQRCode) thì sẽ không bị crash)
                    capture = render.uiImage
                    
                    /// fallback iOS < 16.0
                    // capture = snapshotMaker.snapshot()
                    // capture = testView.snapshot()
                }
            }
            .padding()
            
            if let image = capture {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.none)
                    .frame(width: 250, height: 250)
                
                Button("Save To Album") {
                    imageSaver.writeToPhotoAlbum(image)
                    /// Ở đây sử dụng ảnh đã được tạo dưới dạng capture để làm minh họa cho trường hợp tổng quát
                    /// Đối với ảnh QR thì sử dụng trực tiếp ảnh từ hàm generateQRCode, không phải qua bước lòng vòng Image -> View -> Image
                    /// Tuy nhiên, nếu muốn thêm ảnh hay logo đi kèm với mã QR thì vẫn cần sử dụng ảnh capture
                }
            }
            Spacer()
        }
    }
    
    private var testView: some View {
        QRCode(qrCode, tintColor: .orange)
            .environment(\.colorScheme, colorScheme)
    }
}

final class ImageSaver: NSObject, ObservableObject {
    
    func writeToPhotoAlbum(_ uiImage: UIImage) {
        UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(image), nil)
    }
    
    @objc
    private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error {
            print("Save error with \(error.localizedDescription)")
        } else {
            print("Save success")
        }
    }
}

struct Snapshot_Previews: PreviewProvider {
    static var previews: some View {
        Snapshot()
    }
}

/// Refer:
/// https://cindori.com/developer/screenshot-view-swiftui
/// https://dev.to/gualtierofr/take-screenshots-of-swiftui-views-2h8n
/// ImageRenderer có từ SwiftUI4 --> chỉ hỗ trợ từ iOS 16

/// Hỗ trợ các các iOS đời thấp hơn
/// Cách 1: Hiện tại test không hoạt động, và cách này sẽ bị thiếu Environment giống ImageRenderer của SwiftUI
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

/// Cách 2: (Test OK)
struct SnapshotBox: UIViewRepresentable {
    @Binding var snapshotMaker: SnapshotMaker
    
    func makeUIView(context: Context) -> SnapshotMaker {
        return SnapshotMaker(frame: CGRect.zero)
    }
    
    func updateUIView(_ uiView: SnapshotMaker, context: Context) {
        DispatchQueue.main.async {
            snapshotMaker = uiView
        }
    }
}

extension View {
    func snapshot(assign snapshotMaker: Binding<SnapshotMaker>) -> some View {
        let snapshotBox = SnapshotBox(snapshotMaker: snapshotMaker)
        return overlay(snapshotBox.allowsHitTesting(false))
    }
}

class SnapshotMaker: UIView {
    func snapshot() -> UIImage? {
        guard let containerView = self.superview?.superview,
              let containerSuperview = containerView.superview
        else { return nil }
        
        let renderer = UIGraphicsImageRenderer(bounds: containerView.frame)
        return renderer.image { context in
            containerSuperview.layer.render(in: context.cgContext)
        }
    }
}
