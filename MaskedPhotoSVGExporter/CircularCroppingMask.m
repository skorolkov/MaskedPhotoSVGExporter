//
//  CircularCroppingMask.m
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 19.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import "CircularCroppingMask.h"

@implementation CircularCroppingMask

- (UIColor *)croppingPathOuterColor {
    return [UIColor lightGrayColor];
}

- (UIBezierPath *)croppingPathForRect:(CGRect)rect {
    CGRect rectToDrawPath = [self croppingPathRectForRect:rect];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rectToDrawPath];
    
    return path;
}

- (CGRect)croppingPathRectForRect:(CGRect)rect {
    CGRect bounds = rect;
    bounds.origin = CGPointZero;
    
    CGFloat boundsLesserSide = MIN(bounds.size.width, bounds.size.height);
    CGFloat sideMargin = 30.0;
    
    CGRect result = CGRectZero;
    result.size = CGSizeMake(boundsLesserSide - sideMargin,
                             boundsLesserSide - sideMargin);
    result.origin = CGPointMake((bounds.size.width - result.size.width) / 2,
                                (bounds.size.height - result.size.height) / 2);
    return result;
}

@end
