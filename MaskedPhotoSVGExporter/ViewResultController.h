//
//  ViewResultController.h
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 20.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CroppingMask.h"

@interface ViewResultController : UIViewController

- (instancetype)initWithImage:(UIImage *)image croppingMask:(id<CroppingMask>)croppingMask;

@end
