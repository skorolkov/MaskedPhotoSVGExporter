//
//  MaskOverlayView.h
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 19.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CroppingMask.h"

@interface MaskOverlayView : UIView

@property (strong, nonatomic) id<CroppingMask> croppingMask;

@end
