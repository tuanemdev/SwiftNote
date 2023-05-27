//
//  QRCode.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 25/05/2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCode: View {
    
    private let string: String
    private let tintColor: Color
    init(
        _ string: String,
        tintColor: Color = .black
    ) {
        self.string = string
        self.tintColor = tintColor
    }
    
    var body: some View {
        Image(uiImage: generateQRCode(from: string, tintColor: tintColor))
            .resizable()
            .interpolation(.none)
            .scaledToFit()
    }
    
    private func generateQRCode(from string: String, tintColor: Color) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)
        filter.setValue("H", forKey: "inputCorrectionLevel") /// L: 7%, M: 15%, Q: 25%, H: 30% (tính năng tự sửa lỗi của mã QR) (default value: M)
        
        /// Similarly
        let barFilter = CIFilter.code128BarcodeGenerator()
        barFilter.message = Data(string.utf8)
        
        let pdfFilter = CIFilter.pdf417BarcodeGenerator()
        pdfFilter.message = Data(string.utf8)
        
        let aztecFilter = CIFilter.aztecCodeGenerator()
        aztecFilter.message = Data(string.utf8)
        
        let transform = CGAffineTransform(scaleX: 100, y: 100) /// Sử dụng để tăng độ phân giải của hình ảnh, mặc định sẽ chỉ dùng 1px cho mỗi điểm của QR
        /// Nếu chỉ để hiển thị thì không cần thiết dùng đến vì đã sử dụng .interpolation(.none), tuy nhiên mục đích chính của việc này là lấy một UIImage độ phân giải cao lưu vào thư viện ảnh
        /// Ngoài cách set cố định thì có thể tính toán hiển thị dựa trên size của hình ảnh cần hiển thị (Không cần thiết với SwiftUI vì đã có .interpolation(.none))
        /// guard let qrImage = filter.outputImage else { return UIImage() }
        /// let scaleX = imageView.frame.size.width / qrImage.extent.size.width
        /// let scaleY = imageView.frame.size.height / qrImage.extent.size.height
        guard let outputImage = filter.outputImage?.transformed(by: transform),
              let tintedImage = outputImage.tinted(using: UIColor(tintColor)),
              let cgImage = context.createCGImage(tintedImage, from: tintedImage.extent)
        else { return UIImage(systemName: "xmark.circle") ?? UIImage() }
        
        return UIImage(cgImage: cgImage)
    }
}

struct QRCode_Previews: PreviewProvider {
    static var previews: some View {
        QRCode("Một mã code QR dùng để test tính năng", tintColor: .red)
            .background {
                Image("image04")
                    .resizable()
                    .scaledToFill()
            }
            .overlay {
                Image("image02")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
            }
    }
}

extension CIImage {
    
    /// Combines the current image with the given image centered.
    func combined(with image: CIImage) -> CIImage? {
        guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
        let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2),
                                                y: extent.midY - (image.extent.size.height / 2))
        combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
        combinedFilter.setValue(self, forKey: "inputBackgroundImage")
        return combinedFilter.outputImage
    }
    
    /// Applies the given color as a tint color.
    func tinted(using color: UIColor) -> CIImage? {
        guard let transparentImage = transparent,
              let filter = CIFilter(name: "CIMultiplyCompositing"),
              let colorFilter = CIFilter(name: "CIConstantColorGenerator")
        else { return nil }
        
        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage
        
        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentImage, forKey: kCIInputBackgroundImageKey)
        
        return filter.outputImage
    }
    
    /// Inverts the colors and creates a transparent image by converting the mask to alpha.
    /// Input image should be black and white.
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }
    
    /// Inverts the colors.
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }
    
    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
}

/**
 Lưu ý:
 1. QR gốc mặc định là nền trắng mã vạch màu đen
 Code phía trên đã chuyển thành nền trong suốt và mã vạch theo tintColor được đưa vào (mặc định màu đen)
 
 2. Trong preview phía trên sử dụng 1 ảnh làm nền tuy nhiên không nên sử dụng vì có thể ảnh hưởng đến khả năng đọc code của camera do màu quá phức tạp
 làm camera khó nhận biết phần nội dung mã vạch. Nên để đơn màu hoặc không làm gì nếu background đã OK.
 
 3. Có thể chèn 1 logo nhỏ đè lên mã QR do QR có tính năng tự sửa lỗi, nếu mất 1 phần nội dung thì nó vẫn có thể khôi phục và đọc được
 Tốt nhất vẫn là không đè gì lên phần mã vạch, nếu sử dụng thì nên để kích thước nhỏ và test kỹ khả năng còn đọc được mã vạch của camera
 https://www.qrcode.com/en/about/error_correction.html
 Có hàm combined(with: ) trong extension CIImage phía trên phục vụ điều này nhưng việc sử dụng .overlay tiện lợi và linh hoạt hơn.
 Nó sẽ thuận tiện hơn trong UIKit chứ SwiftUI thì không cần thiết.
 
 Sử dụng: Đầu tiên là UIImage -> CGImage -> CIImage
 let logo = UIImage(named: "logo")
 let cgLogo = logo?.cgImage
 let ciLogo = CIImage(cgImage: cgLogo)
 Thêm vào hàm generateQRCode đẻ sử dụng
 
 4. Đối với Barcode thì sẽ chỉ nhận các ký tự thông thường: bảng chữ cái tiếng anh và số. Nếu không thì CIFilter.outputImage sẽ trả về nil
 */

/// Cách tiếp cận khác
extension Image {
    
    enum BarCode {
        case qrCode
        case code128Barcode
        case pdf417Barcode
        case aztecCode
    }
    
    init(code: String, _ type: BarCode) {
        let context = CIContext()
        let filter: CIFilter
        switch type {
        case .qrCode:
            let aFilter = CIFilter.qrCodeGenerator()
            aFilter.message = Data(code.utf8)
            filter = aFilter
        case .code128Barcode:
            let aFilter = CIFilter.code128BarcodeGenerator()
            aFilter.message = Data(code.utf8)
            filter = aFilter
        case .pdf417Barcode:
            let aFilter = CIFilter.pdf417BarcodeGenerator()
            aFilter.message = Data(code.utf8)
            filter = aFilter
        case .aztecCode:
            let aFilter = CIFilter.aztecCodeGenerator()
            aFilter.message = Data(code.utf8)
            filter = aFilter
        }
        
        if let ciImage = filter.outputImage,
           let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            self.init(cgImage, scale: 1, label: Text("BarCode"))
        } else {
            self.init(systemName: "xmark.circle")
        }
        
    }
}
