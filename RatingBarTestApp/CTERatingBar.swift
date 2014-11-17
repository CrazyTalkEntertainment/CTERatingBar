//
//  CTERatingBar.swift
//  CTETestApp
//
//  Created by CrazyTalk Entertainment on 2014-06-14.
//  Copyright (c) 2014 CrazyTalk Entertainment. All rights reserved.
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import UIKit
import QuartzCore


protocol CTERatingBarDelegate {
    
    func didSelectRating(rating: Double, ratingBar: CTERatingBar)
}


class CTERatingBar: UIView {
    
    let backgroundImageName = "backgroundLayer"
    let tintLayerName       = "tintLayer"
    let maskLayerName       = "maskLayer"
    let defaultAnimationDuration = 0.5
    let defaultRatingTintColor = UIColor.yellowColor()
    let miniumumImageSize: CGFloat = 5.0
    
    var contentFrame: CGRect = CGRectZero
    var delegate: CTERatingBarDelegate?
    
    var maxRating: Int = 5 {
        
    didSet {
        
        if self.maxRating != oldValue {
            
            if (ratingImageUnselected != nil) {
                
                layoutRatingBar()
            }
        }
    }
    }
    
    var currentRating: CGFloat = 0.0 {
        
    didSet {
        
        tintLayer.frame = CGRect(x: 0, y: 0, width: ratingInPointsFromRating(self.currentRating, maxRating: self.maxRating), height: bounds.size.height)
    }
    }
    
    var ratingTintColor: UIColor!
    {
    willSet {
        
        if self.ratingTintColor != newValue {
            
            tintLayer.backgroundColor = newValue.CGColor
        }
    }
    }
    
    var ratingImageUnselected: UIImage?
    {
    
    didSet {
        
        if self.ratingImageUnselected != oldValue {
         
            layoutRatingBar()
        }
    }
    }
    
    var imageBufferDistance: CGFloat = 0 {
    
    didSet {
        
        if imageBufferDistance != oldValue {
           
            if (ratingImageUnselected != nil) {
               
                self.layoutRatingBar()
            }
        }
    }
    }
    
    var isRatingInteractive: Bool!
    {
    
    didSet {
        
        if isRatingInteractive != oldValue {
            
            (isRatingInteractive != nil) ? setupGestureRecognizers() : removeGestureRecognizers()
        }
    }
    }
    
    var tapGesture: UITapGestureRecognizer?
    var longPressGesture: UILongPressGestureRecognizer?
    var panGesture: UIPanGestureRecognizer?
    
    var tintLayer: CALayer!
    var ratingBackgroundLayer: CALayer!
    var maskLayer: CALayer!
    var fullRatingImage: UIImage!
    
    override var contentMode: UIViewContentMode
    {
    didSet {
        
        if (ratingImageUnselected != nil) {
            
            layoutRatingBar()
        }
    }
    }
    

    init(frame: CGRect, ratingImage: UIImage, maxRating: Int)
    {
        super.init(frame: frame)
        ratingImageUnselected = ratingImage;
        self.maxRating = maxRating
        commonInit()
        
    }
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        commonInit()
       
    }
    
    func commonInit()
    {
        contentFrame = frame
        isRatingInteractive = true;
        
        if (ratingImageUnselected != nil) {
           
            layoutRatingBar()
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        if contentFrame != frame {
            
            contentFrame = frame
            if (ratingImageUnselected != nil) {
                
                layoutRatingBar()
            }
        }
    }
    
    
    func setCurrentRating(currentRating: CGFloat, animated: Bool)
    {
        if animated {
            
            UIView.animateWithDuration(defaultAnimationDuration) {
                
                self.currentRating = currentRating
            }
        }
        else {
            
            self.currentRating = currentRating
        }
    }
    
    
    func setupGestureRecognizers()
    {
        panGesture = UIPanGestureRecognizer(target: self, action: "didSelectRatingValue:")
        addGestureRecognizer(panGesture!)
        
        tapGesture = UITapGestureRecognizer(target: self, action: "didSelectRatingValue:")
        addGestureRecognizer(tapGesture!)
    }
    
    
    func layoutRatingBar()
    {
        if !(ratingBackgroundLayer != nil) {
            
            ratingBackgroundLayer = CALayer()
            ratingBackgroundLayer.name = backgroundImageName
        }
        
        if !(tintLayer != nil) {
            
            tintLayer = CALayer()
            tintLayer.name = tintLayerName
            ratingTintColor = defaultRatingTintColor
        }
        
        if !(maskLayer != nil) {
            
            maskLayer = CALayer()
            maskLayer.name = maskLayerName
        }
        
        fullRatingImage = createFullRatingImage(ratingImageUnselected!)
        
        ratingBackgroundLayer.contentsScale = ratingImageUnselected!.scale
        ratingBackgroundLayer.contentsGravity = contentsGravityForcontentMode(contentMode)
        ratingBackgroundLayer.frame = bounds
        ratingBackgroundLayer.contents = fullRatingImage.CGImage
        layer.addSublayer(ratingBackgroundLayer)
        layer.masksToBounds = true
        
        tintLayer.backgroundColor = ratingTintColor.CGColor
        tintLayer.frame = bounds
        tintLayer.frame = CGRectMake(0, 0, ratingInPointsFromRating(currentRating, maxRating: maxRating), bounds.size.height)
        layer.addSublayer(tintLayer)
        
        maskLayer.contentsScale = ratingImageUnselected!.scale
        maskLayer.contentsGravity = ratingBackgroundLayer.contentsGravity
        maskLayer.contents = fullRatingImage.CGImage
        maskLayer.frame = ratingBackgroundLayer.bounds
        
        layer.addSublayer(maskLayer)
        
        tintLayer.mask = maskLayer
    }
    
/* creates a single image for the rating bar */
    func createFullRatingImage(image: UIImage) -> UIImage
    {
        var newSize = CGSizeZero
        var scaledBufferDistance = imageBufferDistance
        switch contentMode {
         
    //get size of new image
        case .ScaleToFill, .ScaleAspectFit, .ScaleAspectFill:
           
    //if buffer size will result in an image that is bigger that the one available then reduce the buffer size until the image is equal to the miniumum image size
            let totalBufferDistance: CGFloat = imageBufferDistance * (CGFloat(maxRating - 1))
            if (totalBufferDistance >= frame.size.width) {
                
                imageBufferDistance = (frame.size.width - (miniumumImageSize * CGFloat(maxRating))) / CGFloat(maxRating - 1)
            }
            
            scaledBufferDistance = scaledBufferImageDistanceForImage(image);
            newSize = CGSize(width: ((image.size.width * CGFloat(maxRating)) + (CGFloat(maxRating - 1) * scaledBufferDistance)), height: image.size.height)
            
        default:
            
            newSize = CGSize(width: ((image.size.width * CGFloat(maxRating)) + (CGFloat(maxRating - 1) * scaledBufferDistance)), height: image.size.height)
        }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale)
        
        image.drawInRect(CGRect(x: 0.0, y: 0.0, width: image.size.width, height: image.size.height))
        var imagePosition: CGFloat = (image.size.width + scaledBufferDistance)
        
        for index in 1...maxRating {
            
            image.drawInRect(CGRect(x: imagePosition, y: 0.0, width: image.size.width, height: image.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
            imagePosition = (imagePosition + image.size.width + scaledBufferDistance)
        }
        
        let fullImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return fullImage
    }
    
/* scales the buffer size to so that when the final image is created and scaled to fit the label it will be the desired size */
    func scaledBufferImageDistanceForImage(image: UIImage) -> CGFloat
    {
        let availableWidth: CGFloat = frame.size.width - (imageBufferDistance * CGFloat(maxRating - 1))
        let scaledImageSize: CGFloat = availableWidth / CGFloat(maxRating)
        let ratio: CGFloat = (image.size.width / scaledImageSize)
        return imageBufferDistance * ratio;
    }
    
/* converts contentMode to ContentGravity */
    func contentsGravityForcontentMode(contentMode: UIViewContentMode) -> String
    {
        switch contentMode {
            
        case .ScaleToFill:
            
            return kCAGravityResize
            
        case .ScaleAspectFit:
            
            return kCAGravityResizeAspect
            
        case .Center:
            
            return kCAGravityCenter
            
        case .ScaleAspectFill:
            
            return kCAGravityResizeAspectFill
            
        case .Top:
            
            return kCAGravityBottom
            
        case .Bottom:
            
            return kCAGravityTop
            
        case .Left:
            
            return kCAGravityLeft
            
        case .Right:
            
            return kCAGravityRight
            
        case .TopLeft:
            
            return kCAGravityBottomLeft
            
        case .TopRight:
            
            return kCAGravityBottomRight
            
        case .BottomLeft:
            
            return kCAGravityTopLeft
            
        case .BottomRight:
            
            return kCAGravityTopRight
            
        case .Redraw:
            
            return kCAGravityResize
        }
    }
    
/* converts a star rating value to a value in points (pixels * screen scale) */
    func ratingInPointsFromRating(currentRating: CGFloat, maxRating: Int) -> CGFloat
    {
        let ratingBarWidth: CGFloat = (fullRatingImage.size.width * scaleOfImageAfterContentModeResize().width) - (imageBufferDistance * CGFloat(maxRating-1))
        let singleImageWidth = (ratingBarWidth / CGFloat(maxRating))
        let imageOrigin = originOfBackgroundImage()
        let intNumOfBuffers = Int(currentRating);
        return ((singleImageWidth * currentRating) + (CGFloat(intNumOfBuffers) * imageBufferDistance) + imageOrigin.x)
    }
    
/* converts a touch point into a star rating value */
    func ratingFromTouchInPoints(touchPoint: CGFloat) -> CGFloat
    {
        let ratingBarWidth: CGFloat = (fullRatingImage.size.width * scaleOfImageAfterContentModeResize().width) - (imageBufferDistance * CGFloat(maxRating-1))
        let singleImageWidth = (ratingBarWidth / CGFloat(maxRating))
        let imageOrigin = originOfBackgroundImage()
        let tempRating: CGFloat = (touchPoint - imageOrigin.x) / (imageBufferDistance + singleImageWidth)
        let intNumberOfBuffers = Int(ceil(tempRating - 0.5))
        let finalRating: CGFloat = (touchPoint - imageOrigin.x - (CGFloat(intNumberOfBuffers) * imageBufferDistance)) / singleImageWidth
        
        return (finalRating > CGFloat(maxRating)) ? CGFloat(maxRating) : finalRating;
    }
    
/* finds the image scale after the contentMode has resized the image */
    func scaleOfImageAfterContentModeResize() -> CGSize
    {
        var scale: CGFloat = 1.0
        if !(fullRatingImage != nil) {
            
            return CGSizeMake(scale, scale)
        }
        
        let sizeX: CGFloat = (frame.size.width / fullRatingImage.size.width)
        let sizeY: CGFloat = (frame.size.height / fullRatingImage.size.height)
        
        switch contentMode {
            
        case .ScaleAspectFit:
            
            scale = fmin(sizeX, sizeY)
            return CGSize(width: scale, height: scale)
            
        case .ScaleAspectFill:
            
            scale = fmax(sizeX, sizeY)
            return CGSize(width: scale, height: scale)
            
        case .ScaleToFill:
            
            return CGSize(width: sizeX, height: sizeY)
            
        default:
            
            return CGSize(width: scale, height: scale)
        }
    }
    
/* finds the origin of the image after the contentMode has repositioned the image */
    func originOfBackgroundImage() -> CGPoint
    {
        switch contentMode {
            
        case .ScaleToFill, .Left, .TopLeft, .BottomLeft, .Redraw:
            
            return CGPointZero
            
        case .Center, .Top, .Bottom:
            
            return CGPoint(x: ((bounds.size.width - fullRatingImage.size.width) * 0.5), y: 0.0)
            
        case .ScaleAspectFit, .ScaleAspectFill:
            
            let imageScale = scaleOfImageAfterContentModeResize()
            let originX: CGFloat = ((bounds.size.width - (fullRatingImage.size.width * imageScale.width)) * 0.5)
            return CGPoint(x: originX, y: 0.0)
            
        case .Right, .TopRight, .BottomRight:
            
            return CGPoint(x: (bounds.size.width - fullRatingImage.size.width), y: 0.0)
            
        }
    }
    
/* rounds the star rating value up to the nearest half a star */
    func roundUpToNearestHalf(value: CGFloat) -> CGFloat
    {
        let roundingValue = 0.5
        let multiplier = Int(ceil(Double(value) / roundingValue))
        return (CGFloat(multiplier) * CGFloat(roundingValue))
    }
    
    
    //MARK: Interactions
    
    func removeGestureRecognizers()
    {
        if (tapGesture != nil) {
            
            removeGestureRecognizer(tapGesture!)
        }
        if (panGesture != nil) {
            
           removeGestureRecognizer(panGesture!)
        }
    }
    
    
    func gestureEqualsGesture(gesture: UIGestureRecognizer, compareGesture: UIGestureRecognizer?) -> Bool
    {
        if (compareGesture != nil) {
            
            if gesture == compareGesture! {
                
                return true
            }
            else {
                
                return false
            }
        }
        else {
            
            return false
        }
    }

    
    func didSelectRatingValue(gesture: UIGestureRecognizer)
    {
        if gestureEqualsGesture(gesture, compareGesture: tapGesture) || gestureEqualsGesture(gesture, compareGesture: panGesture) {
            
            let touchPoint = gesture.locationInView(self)
            tintLayer.frame = CGRect(x: 0.0, y: 0.0, width: touchPoint.x, height: bounds.size.height)
            
            if gesture.state == .Ended {
                
                let rating: CGFloat = ratingFromTouchInPoints(touchPoint.x)
                let roundedRating = roundUpToNearestHalf(rating)

                delegate?.didSelectRating(Double(roundedRating), ratingBar: self)
                currentRating = roundedRating
            }
        }
    }
    

}
