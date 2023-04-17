//
//  PhotosPicker.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 26/11/2022.
//

import SwiftUI
import PhotosUI
import AVKit

// MARK: - @available(iOS 16, *)
struct PhotosPickerView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var isShowPicker: Bool = false
    @State private var uiImage: UIImage? = nil
    
    // Cách sử dụng FileTransfer để giảm thiểu RAM cần sử dụng (ko lưu 1 biến data)
    @State private var isShowVideoPicker: Bool = false
    @State private var selectedVideo: PhotosPickerItem?
    @State private var pickedVideoURL: URL?
    
    var body: some View {
        VStack(spacing: 30) {
            PhotosPicker(selection: $selectedItem,
                         matching: .images,
                         photoLibrary: .shared()) { Text("Select a photo") }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            
            if let selectedImageData, let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
            
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 250, height: 250)
            }
            
            Button("Picker") {
                isShowPicker = true
            }
            
            Button("Video Picker") {
                isShowVideoPicker = true
            }
            if let pickedVideoURL {
                VideoPlayer(player: .init(url: pickedVideoURL))
            }
        }
        .sheet(isPresented: $isShowPicker) {
            ImagePicker(image: $uiImage) // OR CameraPicker(selectedImage: $uiImage)
        }
        .photosPicker(isPresented: $isShowVideoPicker, selection: $selectedVideo, matching: .videos)
        .onChange(of: selectedVideo) { newValue in
            guard let newValue else { return }
            Task {
                do {
                    let pickedVideo = try await newValue.loadTransferable(type: VideoPickerTransferable.self)
                    pickedVideoURL = pickedVideo?.videoURL
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .onDisappear {
            deleteFile()
        }
    }
    
    private func deleteFile() {
        guard let pickedVideoURL else { return }
        do {
            try FileManager.default.removeItem(at: pickedVideoURL)
            self.pickedVideoURL = nil
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct PhotosPickerView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosPickerView()
    }
}

// MARK: - Hỗ trợ các phiên bản iOS cũ hơn, sử dụng UIKit
/*
 PHPickerViewController
 Không cần khai báo quyền trong Info.plist
 Tuy nhiên chỉ lấy được ảnh từ album
 */
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}

/*
 UIImagePickerController
 Cần khai báo quyền truy cập trong Info.plist
 Sử dụng source từ album hoặc chụp từ camera bằng cách thay sourceType
 Chỉ lấy được hình ảnh (không bao gồm video)
 */
struct CameraPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<CameraPicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<CameraPicker>) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: CameraPicker
        
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

/*
 Tạo một custom Transferable
 */
struct VideoPickerTransferable: Transferable {
    let videoURL: URL
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .video) { exportingFile in
            return .init(exportingFile.videoURL)
        } importing: { receivedTransferredFile in
            let originalFile = receivedTransferredFile.file
            let copiedFile = URL.documentsDirectory.appending(path: "videoPicker.mov")
            if FileManager.default.fileExists(atPath: copiedFile.path()) {
                try FileManager.default.removeItem(at: copiedFile)
            }
            try FileManager.default.copyItem(at: originalFile, to: copiedFile)
            return .init(videoURL: copiedFile)
        }
    }
}
