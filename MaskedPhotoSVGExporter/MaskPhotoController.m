//
//  MaskPhotoController.m
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 19.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import "MaskPhotoController.h"
#import "MaskOverlayView.h"
#import "CircularCroppingMask.h"

@interface MaskPhotoController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet MaskOverlayView *maskOverlayView;

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
    [self setupNavigationItem];
    [self setupImageInScrollView];
    [self setupMaskOverlay];
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
        [self centerImageInScrollView];
    }
    
    CGRect croppingRect = [self.maskOverlayView.croppingMask croppingPathRectForRect:self.view.bounds];
    UIEdgeInsets scrollViewInsets = UIEdgeInsetsZero;
    scrollViewInsets.top = croppingRect.origin.y;
    scrollViewInsets.left = croppingRect.origin.x;
    scrollViewInsets.right = self.view.bounds.size.width - CGRectGetMaxX(croppingRect);
    scrollViewInsets.bottom = self.view.bounds.size.height - CGRectGetMaxY(croppingRect);
    if (!UIEdgeInsetsEqualToEdgeInsets(self.scrollView.contentInset, scrollViewInsets)) {
        self.scrollView.contentInset = scrollViewInsets;
    }
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark Actions

- (void)submitButtonTap {
    
}

#pragma mark Views Support

- (void)setupNavigationItem {
    self.title = NSLocalizedString(@"Pan & Zoom", @"mask screen");
    
    NSString *buttonTitle = NSLocalizedString(@"Submit", @"mask screen");
    UIBarButtonItem *submitButton = [[UIBarButtonItem alloc] initWithTitle:buttonTitle
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(submitButtonTap)];
    self.navigationItem.rightBarButtonItem = submitButton;
}

- (void)setupImageInScrollView {
    self.imageView.image = self.image;
    self.scrollView.maximumZoomScale = 1;
}

- (void)setupMaskOverlay {
    self.maskOverlayView.croppingMask = [CircularCroppingMask new];
}

- (void)centerImageInScrollView {
    CGPoint offset = CGPointZero;
    offset.x = (self.scrollView.contentSize.width - self.scrollView.bounds.size.width) / 2;
    offset.y = (self.scrollView.contentSize.height - self.scrollView.bounds.size.height) / 2;
    [self.scrollView setContentOffset:offset];
}

@end
