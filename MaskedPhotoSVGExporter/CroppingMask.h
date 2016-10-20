//
//  CroppingMask.h
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 19.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CroppingMask <NSObject>

- (UIColor *)croppingPathOuterColor;

- (UIBezierPath *)croppingPathForRect:(CGRect)rect;
- (CGRect)croppingPathRectForRect:(CGRect)rect;

- (NSString *)svgTextWithImageBase64Data:(NSString *)base64Data;

@end
