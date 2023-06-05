//
//  AppIconView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 16/03/2023.
//

import SwiftUI

struct AppIconView: View {
    @StateObject var viewModel = ChangeAppIconViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 11) {
                    ForEach(ChangeAppIconViewModel.AppIcon.allCases) { appIcon in
                        HStack(spacing: 16) {
                            Image(uiImage: appIcon.preview)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .cornerRadius(12)
                            Text(appIcon.description)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                        .background(viewModel.selectedAppIcon == appIcon ? Color.green.opacity(0.6) : Color.gray)
                        .cornerRadius(20)
                        .onTapGesture {
                            withAnimation {
                                viewModel.updateAppIcon(to: appIcon)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 40)
            }
        }
        .background(Color(UIColor.darkGray).ignoresSafeArea())
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView()
    }
}

// MARK: - ViewModel
final class ChangeAppIconViewModel: ObservableObject {
    
    @Published private(set) var selectedAppIcon: AppIcon
    
    init() {
        if let iconName = UIApplication.shared.alternateIconName, let appIcon = AppIcon(rawValue: iconName) {
            selectedAppIcon = appIcon
        } else {
            selectedAppIcon = .primary
        }
    }
    
    func updateAppIcon(to icon: AppIcon) {
        guard UIApplication.shared.alternateIconName != icon.iconName else {
            /// No need to update since we're already using this icon.
            return
        }
        
        let previousAppIcon = selectedAppIcon
        selectedAppIcon = icon
        
        Task { @MainActor in
            do {
                try await UIApplication.shared.setAlternateIconName(icon.iconName)
            } catch {
                /// We're only logging the error here and not actively handling the app icon failure
                /// since it's very unlikely to fail.
                print("Updating icon to \(String(describing: icon.iconName)) failed.")
                /// Restore previous app icon
                selectedAppIcon = previousAppIcon
            }
        }
    }
    
    // Cẩn thận khi sử dụng vì dùng private API, có thể bị Apple reject khi review lên AppStore
    func updateAppIconWithoutAlert(to icon: AppIcon) {
        guard UIApplication.shared.alternateIconName != icon.iconName else {
            /// No need to update since we're already using this icon.
            return
        }
        
        let previousAppIcon = selectedAppIcon
        selectedAppIcon = icon
        
        if UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) &&
            UIApplication.shared.supportsAlternateIcons {
            typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString?, @escaping (NSError) -> ()) -> ()
            
            let selectorString = "_setAlternateIconName:completionHandler:"
            let selector = NSSelectorFromString(selectorString)
            let imp = UIApplication.shared.method(for: selector)
            let method = unsafeBitCast(imp, to: setAlternateIconName.self)
            
            method(UIApplication.shared, selector, icon.iconName as NSString?) { _ in }
        } else {
            selectedAppIcon = previousAppIcon
        }
    }
    
    // MARK: - AppIcon
    enum AppIcon: String, CaseIterable, Identifiable {
        case primary = "AppIcon"
        case darkMode = "AppIcon-TE"
        
        var id: String { rawValue }
        var iconName: String? {
            switch self {
            case .primary:
                /// `nil` is used to reset the app icon back to its primary icon.
                return nil
            default:
                return rawValue
            }
        }
        
        var description: String {
            switch self {
            case .primary:
                return "Default"
            case .darkMode:
                return "Tuan Em"
            }
        }
        
        var preview: UIImage {
            UIImage(named: rawValue) ?? UIImage()
        }
    }
    
    // MARK: - Settings
    /*
     Step 1: Thêm các AppIcon mong muốn và Assets
     Step 2: Vào Project -> Build Settings -> Asset Catalog Compiler - Options
        Tại đây có 2 tuỳ chọn để lựa chọn
        + Thứ nhất: Alternate App Icon Sets
          (Khuyên dùng) Khai báo thủ công các AppIcon sẽ được sử dụng
        + Thứ hai: Include All App Icon Assets
          Tự động thêm tất cả các AppIcon vào project
     
        Thay đổi icon mặc định ban đầu bằng key: Primary App Icon Set Name
     */
}
