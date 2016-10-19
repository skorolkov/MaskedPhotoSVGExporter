//
//  MaskOverlayView.m
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 19.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import "MaskOverlayView.h"

@implementation MaskOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setupView];
    }
    return self;
}

- (void)setCroppingMask:(id<CroppingMask>)croppingMask {
    _croppingMask = croppingMask;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    // Create a path around the entire view
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.bounds];
    
    UIColor *tintColor = [UIColor blackColor];
    if (self.croppingMask != nil) {
        UIBezierPath *path = [self.croppingMask croppingPathForRect:self.bounds];
        [clipPath appendPath:path];
        
        tintColor = [self.croppingMask croppingPathOuterColor];
    }
    
    clipPath.usesEvenOddFillRule = YES;
    [clipPath addClip];
    
    [tintColor setFill];
    [clipPath fill];
}

#pragma mark Support

- (void)setupView {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.contentMode = UIViewContentModeRedraw;
}

#pragma mark Touch Handling

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //Pass all touches through
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self) {
        return nil;
    }
    
    return hitView;
}

@end
