//: Playground - noun: a place where people can play

import UIKit

typealias Filter = CIImage -> CIImage

/**
    functions will have the following general shape:
    func myFilter(/* parameters */) -> Filter
*/

///Blur
func blur(radius: Double) -> Filter {
    return { image in
        let parameters = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image
        ]
        let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameters)!
        return filter.outputImage!
    }
}

///Color Overlay
func colorGenerator(color: UIColor) -> Filter {
    return { _ in
        let parameters = [kCIInputImageKey: color]
        let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters)!
        return filter.outputImage!
    }
}

func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        let filter = CIFilter(name: "CISourceOverCompositing", withInputParameters: parameters)!
        let cropRect = image.extent
        return filter.outputImage!.imageByCroppingToRect(cropRect)
    }
}

func colorOverlay(color: UIColor) -> Filter {
    return { image in
        let overlay = colorGenerator(color)(image)
        return compositeSourceOver(overlay)(image)
    }
}


let url = NSURL(string: "http://www.objc.io/images/covers/16.jpg")!
let image = CIImage(contentsOfURL: url)!
let blurRadius = 5.0
let overlayColor = UIColor.redColor().colorWithAlphaComponent(0.2)
let blurredImage = blur(blurRadius)(image)
