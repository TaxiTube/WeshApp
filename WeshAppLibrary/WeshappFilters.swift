//
//  WeshappFilters.swift
//  WeshApp
//
//  Created by Zuka on 1/23/15.
//  Copyright (c) 2015 WeshApp. All rights reserved.
//

public typealias Filter = CIImage -> CIImage

public class WeshappFilters {
    
    public class func compositeSourceOver(wallpaperImage: CIImage) -> Filter{
        
         return { faceImage in
            
            let filter = CIFilter(name:"CISourceAtopCompositing")
            filter.setValue(faceImage, forKey: "InputImage")
            filter.setValue(wallpaperImage, forKey: "inputBackgroundImage")
            let cropRect = faceImage.extent()
            var outputImage: CIImage = filter.valueForKey(kCIOutputImageKey) as! CIImage
        
             return outputImage.imageByCroppingToRect(cropRect)
        }
    }
    
    //TODO: Perform this on backgroun thread!
    public class func roundImage(image: UIImage) -> UIImage{
        
        let borderWidth: CGFloat = 0.0
        let cornerRadius:CGFloat = image.size.width / 2
        
        // Create a multiplier to scale up the corner radius and border
        // width you decided on relative to the imageViewer frame such
        // that the corner radius and border width can be converted to
        // the UIImage's scale.
        let multiplier:CGFloat = image.size.height/image.size.height > image.size.width/image.size.width ?
            image.size.height/image.size.height :
            image.size.width/image.size.width
        
        let borderWidthMultiplied:CGFloat = borderWidth * multiplier
        let cornerRadiusMultiplied:CGFloat = cornerRadius * multiplier
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, 0)
        
        let path = UIBezierPath(roundedRect: CGRectInset(CGRectMake(0, 0, image.size.width, image.size.height),
            borderWidthMultiplied / 2, borderWidthMultiplied / 2), cornerRadius: cornerRadiusMultiplied)
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSaveGState(context)
        // Clip the drawing area to the path
        path.addClip()
        
        // Draw the image into the context
        image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
        CGContextRestoreGState(context)
        
        // Configure the stroke
        UIColor.blackColor().setStroke()
        path.lineWidth = borderWidthMultiplied
        
        // Stroke the border
        path.stroke()
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return newImage
        
    }
   public class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}




