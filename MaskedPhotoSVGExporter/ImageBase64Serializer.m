//
//  ImageBase64Serializer.m
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 20.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import "ImageBase64Serializer.h"

@implementation ImageBase64Serializer

+ (NSString *)base64StringFromImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.8);
    NSString *result = [data base64EncodedStringWithOptions:0];
    return result;
}

@end
