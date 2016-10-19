//
//  MaskPhotoController.m
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 19.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import "MaskPhotoController.h"

@interface MaskPhotoController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MaskPhotoController

- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        _image = image;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupImageInScrollView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat minimumZoomScale = 1;
    if (self.image.size.width < self.image.size.height) {
        minimumZoomScale = self.scrollView.bounds.size.width / self.image.size.width;
    } else {
        minimumZoomScale = self.scrollView.bounds.size.height / self.image.size.height;
    }
    
    if (self.scrollView.minimumZoomScale != minimumZoomScale) {
        self.scrollView.minimumZoomScale = minimumZoomScale;
        self.scrollView.zoomScale = minimumZoomScale;
    }
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark Views Support

- (void)setupImageInScrollView {
    self.imageView.image = self.image;
    self.scrollView.maximumZoomScale = 1;
}

@end
