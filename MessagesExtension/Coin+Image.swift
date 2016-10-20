//
//  Coin+Image.swift
//  CoinFlip
//
//  Created by Tim Rayle on 10/4/16.
//  Copyright © 2016 Knoable. All rights reserved.
//

import UIKit

extension Coin {
    
    private struct StickerProperties {

        // The desired size of a coin sticker image.
        static let size = CGSize(width: 300.0, height: 300.0)
        
        // The amount of padding to apply to a sticker when drawn with an opaque background.
        static let opaquePadding = CGSize(width: 60.0, height: 10.0)
    }
    
    var stickerImage: UIImage {
        var imageName = "coinFlip.jpg"
        if isComplete {
            imageName = heads ? "coinHead.jpg" : "coinTail.jpg"
        }
        guard let image = UIImage(named: imageName) else { fatalError("Unable to find image named \(imageName)") }
        return image
    }
    
    func renderSticker(opaque: Bool) -> UIImage? {
        
        // Determine the size to draw as a sticker.
        let outputSize: CGSize
        let coinSize: CGSize
                
        if opaque {
            // Scale the coin image to fit in the center of the sticker.
            let scale = min((StickerProperties.size.width - StickerProperties.opaquePadding.width) / stickerImage.size.height,
                            (StickerProperties.size.height - StickerProperties.opaquePadding.height) / stickerImage.size.width)
            coinSize = CGSize(width: stickerImage.size.width * scale, height: stickerImage.size.height * scale)
            outputSize = StickerProperties.size
        }
        else {
            // Scale the coin to fit it's height into the sticker.
            let scale = StickerProperties.size.width / stickerImage.size.height
            coinSize = CGSize(width: stickerImage.size.width * scale, height: stickerImage.size.height * scale)
            outputSize = coinSize
        }
        
        // Scale the coin image to the correct size.
        let renderer = UIGraphicsImageRenderer(size: outputSize)
        let image = renderer.image { context in
            let backgroundColor: UIColor
            if opaque {
                // Give the image a colored background.
                backgroundColor = UIColor(red: 250.0 / 255.0, green: 225.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
            }
            else {
                // Give the image a clear background
                backgroundColor = UIColor.clear
            }
            
            // Draw the background
            backgroundColor.setFill()
            context.fill(CGRect(origin: CGPoint.zero, size: StickerProperties.size))
            
            // Draw the scaled composited image.
            var drawRect = CGRect.zero
            drawRect.size = coinSize
            drawRect.origin.x = (outputSize.width / 2.0) - (coinSize.width / 2.0)
            drawRect.origin.y = (outputSize.height / 2.0) - (coinSize.height / 2.0)
            
            stickerImage.draw(in: drawRect)
        }
        
        return image
    }
    
}
