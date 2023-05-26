//
//  QRScannerView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 26/05/2023.
//

import SwiftUI
import AVKit

struct QRScannerView: View {
    
    @State private var isScanning: Bool = false
    
    @State private var session: AVCaptureSession = .init()
    @State private var qrOutput: AVCaptureMetadataOutput = .init()
    @State private var cameraPermission: Permission = .idle
    
    @StateObject private var qrDelegate: QRScannerDelegate = .init()
    @State private var scannedCode: String = "QR Code"
    
    @State private var errorMessage: String = ""
    @State private var isShowError: Bool = false
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        
        VStack(spacing: 8) {
            Button {
                
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            Text("Place the QR code inside the area")
                .font(.title3)
                .foregroundColor(.primary.opacity(0.8))
                .padding(.top, 20)
            
            Text("Scanning will start automatically")
                .font(.callout)
                .foregroundColor(.gray)
            
            Text(scannedCode)
                .font(.title2)
                .foregroundColor(.red.opacity(0.8))
                .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            // Scanner
            /// ==========
            GeometryReader { proxy in
                let size = proxy.size
                
                ZStack {
                    CameraView(session: $session, size: CGSize(width: size.width, height: size.width))
                        .scaleEffect(0.98)
                    
                    ForEach(0...4, id: \.self) { index in
                        let rotation = Double(index) * 90.0
                        RoundedRectangle(cornerRadius: 2,style: .continuous)
                            .trim(from: 0.61, to: 0.64)
                            .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                            .rotationEffect(.degrees(rotation))
                    }
                }
                .frame(width: size.width, height: size.width)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(.blue)
                        .frame(height: 2.5)
                        .shadow(color: .gray, radius: 8, x: 0, y: isScanning ? -15 : 15)
                        .offset(y: isScanning ? size.width : 0)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.horizontal, 45)
            /// ==========
            
            Spacer(minLength: 15)
            
            Button {
                if !session.isRunning && cameraPermission == .approved {
                    scannedCode = ""
                    reactivateCamera()
                    activeScannerAnimation()
                }
            } label: {
                Image(systemName: "qrcode.viewfinder")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            
            Spacer(minLength: 45)
        }
        .alert(errorMessage, isPresented: $isShowError) {
            if cameraPermission == .denied {
                Button("Settings") {
                    let settingsURLString = UIApplication.openSettingsURLString
                    guard let settingsURL = URL(string: settingsURLString) else { return }
                    openURL(settingsURL)
                }
                
                Button("Cancel", role: .cancel) { }
            }
        }
        .onAppear {
            checkCameraPermission()
        }
        .onDisappear {
            session.stopRunning()
        }
        .onChange(of: qrDelegate.scannedCode) { newValue in
            guard let code = newValue, scannedCode != code
            else { return }
            
            scannedCode = code
            session.stopRunning()
            deActiveScannerAnimation()
            qrDelegate.scannedCode = nil
        }
    }
    
    private func reactivateCamera() {
        DispatchQueue.global(qos: .background).async {
            session.startRunning()
        }
    }
    
    private func activeScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85).delay(0.1).repeatForever(autoreverses: true)) {
            isScanning = true
        }
    }
    
    private func deActiveScannerAnimation() {
        withAnimation(.easeInOut(duration: 0.85)) {
            isScanning = false
        }
    }
    
    private func checkCameraPermission() {
        Task {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                if await AVCaptureDevice.requestAccess(for: .video) {
                    cameraPermission = .approved
                } else {
                    cameraPermission = .denied
                    presentError("Please Provide access camera for scanning codes")
                }
            case .restricted, .denied:
                cameraPermission = .denied
                presentError("Please Provide access camera for scanning codes")
            case .authorized:
                cameraPermission = .approved
                if session.inputs.isEmpty {
                    setupCamera()
                } else {
                    reactivateCamera()
                }
            @unknown default:
                cameraPermission = .idle
            }
        }
    }
    
    private func setupCamera() {
        do {
            guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first
            else {
                presentError("Unknow DEVICE Error")
                return
            }
            let input = try AVCaptureDeviceInput(device: device)
            guard session.canAddInput(input), session.canAddOutput(qrOutput)
            else {
                presentError("Unknow INPUT/OUTPUT Error")
                return
            }
            session.beginConfiguration()
            session.addInput(input)
            session.addOutput(qrOutput)
            qrOutput.metadataObjectTypes = [.qr]
            qrOutput.setMetadataObjectsDelegate(qrDelegate, queue: .main)
            session.commitConfiguration()
            DispatchQueue.global(qos: .background).async {
                session.startRunning()
            }
            activeScannerAnimation()
        } catch {
            presentError(error.localizedDescription)
        }
    }
    
    private func presentError(_ message: String) {
        errorMessage = message
        isShowError = true
    }
}

// MARK: - Previews
struct QRScannerView_Previews: PreviewProvider {
    static var previews: some View {
        QRScannerView()
            .preferredColorScheme(.light)
    }
}

// MARK: - Permission
enum Permission: String {
    case idle       = "Not Determined"
    case approved   = "Access Granted"
    case denied     = "Access Denied"
}

// MARK: - Camera View
struct CameraView: UIViewRepresentable {
    
    @Binding var session: AVCaptureSession
    var size: CGSize
    
    func makeUIView(context: Context) -> UIView {
        let view = UIViewType(frame: CGRect(origin: .zero, size: size))
        view.backgroundColor = .clear
        
        let cameraLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraLayer.frame = .init(origin: .zero, size: size)
        cameraLayer.videoGravity = .resizeAspectFill
        cameraLayer.masksToBounds = true
        view.layer.addSublayer(cameraLayer)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

// MARK: - QRScanner Delegate
class QRScannerDelegate: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    
    @Published var scannedCode: String?
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard let metaObject = metadataObjects.first,
              let readableObject = metaObject as? AVMetadataMachineReadableCodeObject,
              let code = readableObject.stringValue
        else { return }
        
        self.scannedCode = code
    }
}
