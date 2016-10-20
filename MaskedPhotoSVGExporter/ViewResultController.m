//
//  ViewResultController.m
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 20.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import "ViewResultController.h"

@interface ViewResultController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) id<CroppingMask> croppingMask;

@end

@implementation ViewResultController

- (instancetype)initWithImage:(UIImage *)image croppingMask:(id<CroppingMask>)croppingMask {
    if (self = [super init]) {
        _image = image;
        _croppingMask = croppingMask;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.image;
}

@end
