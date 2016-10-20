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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cImageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cImageViewHeightConstraint;

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupNavigationItem];
    [self setupImageInScrollView];
    [self setupMaskOverlay];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect croppingRect = [self.maskOverlayView.croppingMask croppingPathRectForRect:self.view.bounds];
    
    UIEdgeInsets scrollViewInsets = UIEdgeInsetsZero;
    scrollViewInsets.top = croppingRect.origin.y;
    scrollViewInsets.left = croppingRect.origin.x;
    scrollViewInsets.right = self.view.bounds.size.width - CGRectGetMaxX(croppingRect);
    scrollViewInsets.bottom = self.view.bounds.size.height - CGRectGetMaxY(croppingRect);
    if (!UIEdgeInsetsEqualToEdgeInsets(self.scrollView.contentInset, scrollViewInsets)) {
        self.scrollView.contentInset = scrollViewInsets;
    }
    
    CGFloat minimumZoomScale = 1;
    if (self.imageView.bounds.size.width < self.imageView.bounds.size.height) {
        minimumZoomScale = croppingRect.size.width / self.imageView.bounds.size.width;
    } else {
        minimumZoomScale = croppingRect.size.height / self.imageView.bounds.size.height;
    }
    
    if (self.scrollView.minimumZoomScale != minimumZoomScale) {
        self.scrollView.minimumZoomScale = minimumZoomScale;
        self.scrollView.zoomScale = minimumZoomScale;
        [self centerImageInScrollView];
    }
}

#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark Actions

- (void)submitButtonTap {
    CGRect maskRect = [self.maskOverlayView.croppingMask croppingPathRectForRect:self.scrollView.bounds];
    
    CGRect visibleRect = CGRectZero;
    visibleRect.origin.x = self.scrollView.contentOffset.x + maskRect.origin.x;
    visibleRect.origin.y = self.scrollView.contentOffset.y + maskRect.origin.y;
    visibleRect.size = maskRect.size;
    
    CGFloat scaling = 1.0 / self.scrollView.zoomScale;
    visibleRect.origin.x *= scaling;
    visibleRect.origin.y *= scaling;
    visibleRect.size.width *= scaling;
    visibleRect.size.height *= scaling;
    
    NSLog(@"%@", NSStringFromCGRect(visibleRect));
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
    
    [self scaleImageViewToFillCropingMask:self.maskOverlayView.croppingMask];
}

- (void)setupMaskOverlay {
    id<CroppingMask> mask = [CircularCroppingMask new];
    self.maskOverlayView.croppingMask = mask;
    
    [self scaleImageViewToFillCropingMask:mask];
}

- (void)scaleImageViewToFillCropingMask:(id<CroppingMask>)croppingMask {
    const CGSize imageSize = self.imageView.image.size;
    
    void (^scaleImageViewWithCoefficient)(CGFloat) = ^(CGFloat coefficient) {
        self.cImageViewWidthConstraint.constant = imageSize.width * coefficient;
        self.cImageViewHeightConstraint.constant = imageSize.height * coefficient;
        [self.view layoutIfNeeded];
    };
    
    if (!croppingMask) {
        scaleImageViewWithCoefficient(1);
        return;
    }
    
    const CGSize maskSize = [croppingMask croppingPathRectForRect:self.scrollView.bounds].size;
    
    CGFloat resultingCoefficient = 1;
    
    CGFloat widthCoefficient = maskSize.width / imageSize.width;
    CGFloat heightCoefficient = maskSize.height / imageSize.height;
    if (widthCoefficient > 1 || heightCoefficient > 1) {
        resultingCoefficient = MAX(widthCoefficient, heightCoefficient);
    }
    
    scaleImageViewWithCoefficient(resultingCoefficient);
}

- (void)centerImageInScrollView {
    CGPoint offset = CGPointZero;
    offset.x = (self.scrollView.contentSize.width - self.scrollView.bounds.size.width) / 2;
    offset.y = (self.scrollView.contentSize.height - self.scrollView.bounds.size.height) / 2;
    [self.scrollView setContentOffset:offset];
}

@end
