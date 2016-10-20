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

- (NSString *)svgTextWithImageBase64Data:(NSString *)base64Data {
    NSMutableString *svg = [NSMutableString stringWithString:@""];
    
    [svg appendString:@"<svg width=\"500px\" height=\"800px\">\n"];
    [svg appendString:@"<rect x=\"0\" y=\"0\" width=\"100%\" height=\"100%\" fill=\"lightgray\" />\n"];
    
    [svg appendFormat:
     @"<defs>"
     "<pattern id=\"image\" x=\"0%%\" y=\"0%%\" height=\"100%%\" width=\"100%%\" viewBox=\"0 0 400 400\"> "
     "<image x=\"0%%\" y=\"0%%\" width=\"400\" height=\"400\" xlink:href=\"data:image/jpg;base64,%@\"></image> "
     "</pattern> "
     "</defs>", base64Data];
    
    [svg appendString:@"<circle cx = \"50%\" cy = \"50%\" r = \"30%\" fill=\"url(#image)\"/>"];
    
    [svg appendString:@"</svg>"];
    
    return svg;
}

@end
