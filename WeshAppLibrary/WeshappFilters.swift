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
            var outputImage: CIImage = filter.valueForKey(kCIOutputImageKey) as CIImage
        
             return outputImage.imageByCroppingToRect(cropRect)
        }
    }
    
    
    
    
    
}




