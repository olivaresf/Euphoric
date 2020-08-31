//
//  UIImage.swift
//  Euphoric
//
//  Created by Diego Oruna on 16/08/20.
//

import UIKit

extension UIImage {
    
    enum SFSymbols {
        case magnifyingglass
        case download
        case settings
        case microphone
        case dots
        case play
        case pause
        case info
        case share
        case forward30
        
        var description:String{
            switch self {
            case .magnifyingglass:
                return "magnifyingglass"
            case .download:
                return "square.and.arrow.down"
            case .settings:
                return "gear"
            case .microphone:
                return "mic"
            case .dots:
                return "ellipsis.circle"
            case .play:
                return "play.fill"
            case .pause:
                return "pause.fill"
            case .info:
                return "info.circle"
            case .share:
                return "square.and.arrow.up"
            case .forward30:
                return "goforward.30"
            }
        }
    }
    
    static func withSymbol(type:SFSymbols, size:CGFloat = 22, weight: UIImage.SymbolWeight) -> UIImage{
        return  UIImage(systemName: type.description, withConfiguration: UIImage.SymbolConfiguration(pointSize: size, weight: weight, scale: .default)) ?? UIImage()
    }
    
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
    
}
