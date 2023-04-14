//
//  GIFImageView.swift
//  SwiftNote
//
//  Created by Nguyen Tuan Anh on 14/04/2023.
//

import UIKit

// MARK: - GIFImageView
final class GIFImageView: UIImageView {
    var animator: GIFAnimator?
    
    ///Start animating with GIFInfo
    ///- Parameters:
    ///     - info: Required information to generate a GIF
    ///     - pixelSize: The maximum size of a GIF. The closer a this property is to the actual size of the imageView (or the image holder) the smaller the memory footprint and the better the CPU performance
    ///     - animationQuality: Number of frames per second
    func startGif(with info: GIFInfo, pixelSize: GIFPixelSize = .original, animationQuality: GIFAnimationQuality = .best) {
        animator?.stopPreparingAnimation()
        animator = nil
        
        animator = GIFAnimator(imageInfo: info, pixelSize: pixelSize, animationQuality: animationQuality)
        animator?.delegate = self
        animator?.prepareAnimation()
    }
    
    func resumeGif() {
        animator?.startAnimation()
    }
    
    func pauseGif() {
        animator?.pauseAnimation()
    }
}

extension GIFImageView: GIFAnimatorDelegate {
    func gifAnimatorIsReady(_ sender: GIFAnimator) {
        sender.startAnimation()
    }
    
    func imageViewForAnimator(_ sender: GIFAnimator) -> UIImageView? {
        return self
    }
    
    func gifAnimatorDidChangeImage(_ image: UIImage, sender: GIFAnimator) {
    }
}

// MARK: - GIFAnimator
protocol GIFAnimatorDelegate: AnyObject {
    func gifAnimatorIsReady(_ sender: GIFAnimator)
    func imageViewForAnimator(_ sender: GIFAnimator) -> UIImageView?
    func gifAnimatorDidChangeImage(_ image: UIImage, sender: GIFAnimator)
}

final class GIFAnimator {
    
    ///Required information to generate a GIF
    private let imageInfo: GIFInfo
    
    ///The maximum size of a GIF. The closer a this property is to the actual size of the image holder the smaller the memory footprint and the better the CPU performance
    private let pixelSize: GIFPixelSize
    
    ///Number of frames per second
    private let animationQuality: GIFAnimationQuality
    
    ///Initializes and returns a newly allocated GIFAnimator with the specified properties
    init(
        imageInfo: GIFInfo,
        pixelSize: GIFPixelSize = .original,
        animationQuality: GIFAnimationQuality = .best
    ) {
        self.imageInfo = imageInfo
        self.pixelSize = pixelSize
        self.animationQuality = animationQuality
    }
    
    weak var delegate: GIFAnimatorDelegate?
    
    private let gifQueue: DispatchQueue = .init(label: "gif.animator.queue")
    
    ///The CADisplayLink used to animate the GIF
    private(set) lazy var displayLink: CADisplayLink = {
        let displayLinkProxy: DisplayLinkProxy = .init(animator: self)
        let displayLink: CADisplayLink = .init(target: displayLinkProxy,
                                               selector: #selector(DisplayLinkProxy.animateGif(displayLink:)))
        displayLink.preferredFramesPerSecond = animationQuality.preferredFramesPerSecond
        displayLink.add(to: .main, forMode: .common)
        return displayLink
    }()
    
    //Property used to save CPU power
    ///The frames of a GIF
    private(set) var images: [UIImage] = .init()
    
    ///The lengths of each frame in a GIF
    private(set) var frameDurations: [CFTimeInterval] = .init()
    
    ///An operation used to prepare information needed to start GIF animation
    private var preparingOperation: GIFOperation?
    
    //Property used to calculate the current frame of a GIF
    private var currentIndex: Int = 0
    private var currentDuration: Double = 0
    private var oneCycleDuration: CFTimeInterval = 0
    
    ///An array of time mark to start the next frame
    private var framesStartDurations: [CFTimeInterval] = .init()
    
    ///The first frame of a GIF that can be used as a placeholder when the animator is preparing the GIF frames
    var placeholder: UIImage? {
        return images.first
    }
    
    ///A Boolean value indicating whether the GIF is being animated
    var isStarted: Bool {
        return isReady && !displayLink.isPaused
    }
    
    ///A Boolean value indicating whether the GIF generated from the input GIFInfo has one or more images
    var hasImage: Bool {
        return !images.isEmpty
    }
    
    ///A Boolean value indicating whether GIFAnimator has finished its preparation process and the GIF can be animated
    var isReady: Bool {
        return !images.isEmpty && images.count == frameDurations.count
    }
    
    ///Stops preparing GIF frames and related information
    func stopPreparingAnimation() {
        preparingOperation?.cancel()
        preparingOperation = nil
    }
    
    ///Starts preparing GIF frames and related information. Calling this method will stop the previous preparing process
    func prepareAnimation() {
        stopPreparingAnimation()
        
        preparingOperation = GIFOperation(info: imageInfo, pixelSize: pixelSize) { [weak self] images, frames in
            guard let self else { return }
            self.setupWith(images: images, frames: frames)
            self.preparingOperation = nil
        }
        
        gifQueue.async { [weak self] in
            guard let self else { return }
            self.preparingOperation?.start()
        }
    }
    
    ///Computes required properties to start animating
    private func setupWith(images: [UIImage], frames: [CFTimeInterval]) {
        self.images = images
        self.frameDurations = frames
        self.oneCycleDuration = frames.reduce(0.0, +)
        self.framesStartDurations = frames
            .indices
            .map { index -> CFTimeInterval in
                frames[0...index].reduce(0.0, +)
            }
        
        guard isReady else { return }
        delegate?.gifAnimatorIsReady(self)
    }
    
    ///Starts animating or resume animation if the GIF is in mid animation
    func startAnimation() {
        displayLink.isPaused = false
    }
    
    func pauseAnimation() {
        displayLink.isPaused = true
    }
    
    ///Calculates the next frame and update frame if needed
    @objc
    fileprivate func animateGif(displayLink: CADisplayLink) {
        guard isReady else { return }
        
        guard currentDuration < oneCycleDuration else {
            currentDuration = 0
            currentIndex = 0
            return
        }
        
        if currentDuration >= framesStartDurations[currentIndex] {
            currentIndex += 1
        }
        
        currentDuration += displayLink.duration
        delegate?.gifAnimatorDidChangeImage(images[currentIndex], sender: self)
        delegate?.imageViewForAnimator(self)?.image = images[currentIndex]
    }
    
    deinit {
        displayLink.invalidate()
    }
}

// MARK: - DisplayLinkProxy
///An object used to prevent retain cycle caused by CADisplayLink
private final class DisplayLinkProxy {
    weak var animator: GIFAnimator?
    
    init(animator: GIFAnimator) {
        self.animator = animator
    }
    
    @objc
    func animateGif(displayLink: CADisplayLink) {
        animator?.animateGif(displayLink: displayLink)
    }
}

// MARK: - GIFOperation
///An operation object used to prepare information needed to start GIF animation
private final class GIFOperation: Operation {
    let inputInfo: GIFInfo
    let pixelSize: GIFPixelSize
    var completionHandler: ([UIImage], [CFTimeInterval]) -> Void
    
    init(
        info: GIFInfo,
        pixelSize: GIFPixelSize,
        completion: @escaping ([UIImage], [CFTimeInterval]) -> Void
    ) {
        self.inputInfo = info
        self.pixelSize = pixelSize
        self.completionHandler = completion
        super.init()
    }
    
    override func main() {
        guard !isCancelled else { return }
        
        let imageSource: CGImageSource? = CGImageSource.sourceFromInfo(inputInfo)
        let frames: [CFTimeInterval] = imageSource?.frameDurations ?? []
        let images: [UIImage]
        
        switch pixelSize {
        case .original:
            images = imageSource?.fullSizeImages ?? []
        case .custom(let size):
            images = imageSource?.imagesWithMaxSize(size) ?? []
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self, !self.isCancelled else { return }
            self.completionHandler(images, frames)
        }
    }
}

// MARK: - GIF Models
enum GIFInfo {
    case name(String)
    case localPath(URL)
    case data(Data)
}

///Type used to represent the maximum size of a GIF.
///The closer it is to the actual size of the image holder the smaller the memory footprint and the better the CPU performance
enum GIFPixelSize {
    case original
    case custom(CGFloat)
}

enum GIFAnimationQuality {
    case acceptable
    case average
    case best
    case custom(Int)
    
    var preferredFramesPerSecond: Int {
        switch self {
        case .acceptable:
            return 15
        case .average:
            return 30
        case .best:
            return 0
        case .custom(let rate):
            return rate
        }
    }
}

// MARK: - CGImageSource Extension
extension CGImageSource {
    
    // MARK: - Create CGImageSource Helpers
    
    ///A dictionary that specifies additional creation options of the CGImageSource.
    static var defaultOptions: CFDictionary {
        [
            kCGImageSourceShouldCache: kCFBooleanFalse
        ] as CFDictionary
    }
    
    ///Returns a new CGImageSource from the input GIFInfo
    ///- Parameters:
    ///     - info: Required information to generate a GIF
    ///     - options: A dictionary that specifies additional creation options of the CGImageSource
    static func sourceFromInfo(_ info: GIFInfo, with options: CFDictionary = defaultOptions) -> CGImageSource? {
        switch info {
        case .name(let name):
            return sourceFromImageName(name, with: options)
        case .localPath(let url):
            return sourceFromImagePath(url, with: options)
        case .data(let data):
            return sourceFromData(data, with: options)
        }
    }
    
    ///Returns a new CGImageSource from the input GIF name
    ///- Parameters:
    ///     - name: The name of the GIF in the main Bundle
    ///     - options: A dictionary that specifies additional creation options of the CGImageSource
    static func sourceFromImageName(_ name: String, with options: CFDictionary = defaultOptions) -> CGImageSource? {
        guard let imageUrl = Bundle.main.url(forResource: name, withExtension: "gif") else { return nil }
        return sourceFromImagePath(imageUrl, with: options)
    }
    
    ///Returns a new CGImageSource from the input local path
    ///- Parameters:
    ///     - path: The local path of a GIF
    ///     - options: A dictionary that specifies additional creation options of the CGImageSource
    static func sourceFromImagePath(_ path: URL, with options: CFDictionary = defaultOptions) -> CGImageSource? {
        guard let data = try? Data(contentsOf: path) else { return nil }
        return sourceFromData(data, with: options)
    }
    
    ///Returns a new CGImageSource from the input GIF data
    ///- Parameters:
    ///     - data: GIF data
    ///     - options: A dictionary that specifies additional creation options of the CGImageSource.
    class func sourceFromData(_ data: Data, with options: CFDictionary = defaultOptions) -> CGImageSource? {
        return CGImageSourceCreateWithData(data as CFData, options)
    }
    
    // MARK: - Generate GIF Information
    
    ///Array of frame lengths of a GIF
    var frameDurations: [CFTimeInterval] {
        if #available(iOS 13.0, *) {
            guard let properties = CGImageSourceCopyProperties(self, nil) as? Dictionary<String, Any>,
                  let gifInfos = properties[kCGImagePropertyGIFDictionary as String] as? Dictionary<String, Any>,
                  let frameInfos = gifInfos[kCGImagePropertyGIFFrameInfoArray as String] as? [Dictionary<String, CGFloat>]
            else { return [] }
            
            return frameInfos
                .compactMap { $0[kCGImagePropertyGIFDelayTime as String] }
                .map { CFTimeInterval($0) }
        }
        else {
            return Array<Int>(0..<CGImageSourceGetCount(self))
                .reduce(into: []) { result, index in
                    if let properties = CGImageSourceCopyPropertiesAtIndex(self, index, nil) as? Dictionary<String, Any>,
                       let gifInfos = properties[kCGImagePropertyGIFDictionary as String] as? Dictionary<String, Any>,
                       let duration = gifInfos[kCGImagePropertyGIFUnclampedDelayTime as String] as? CFTimeInterval {
                        return result.append(duration)
                    }
                }
        }
    }
    
    ///Array of original - unresized frames of a GIF
    var fullSizeImages: [UIImage] {
        return Array<Int>(0..<CGImageSourceGetCount(self))
            .compactMap { CGImageSourceCreateImageAtIndex(self, $0, nil) }
            .map { UIImage(cgImage: $0) }
    }
    
    ///Returns an array of resized frames of a GIF
    /// - Parameters:
    ///     - size: The maximum size of generated images
    func imagesWithMaxSize(_ size: CGFloat) -> [UIImage] {
        return getResizedImages(from: self, maxSize: size)
    }
    
    ///Returns an array of resized frames of a GIF
    /// - Parameters:
    ///     - imageSource: The object that stores information of a GIF
    ///     - maxSize: The maximum size of generated images
    func getResizedImages(from imageSource: CGImageSource, maxSize: CGFloat) -> [UIImage] {
        return Array<Int>(0..<CGImageSourceGetCount(imageSource))
            .compactMap { index -> CGImage? in
                let options = [
                    kCGImageSourceThumbnailMaxPixelSize: maxSize,
                    kCGImageSourceShouldCacheImmediately: true,
                    kCGImageSourceCreateThumbnailFromImageAlways: kCFBooleanTrue!
                ] as [CFString: Any] as CFDictionary
                return CGImageSourceCreateThumbnailAtIndex(imageSource, index, options)
            }
            .map { UIImage(cgImage: $0) }
    }
}
