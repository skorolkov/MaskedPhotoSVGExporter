//
//  ImageBase64Serializer.h
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 20.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageBase64Serializer : NSObject

+ (NSString *)base64StringFromImage:(UIImage *)image;

@end
