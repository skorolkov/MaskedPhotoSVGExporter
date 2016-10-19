//
//  StartController.m
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 19.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import "StartController.h"

@interface StartController ()

@end

@implementation StartController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Get Started", @"start screen");
}


#pragma mark Actions

- (IBAction)pickPhotoTap {
    UIAlertController *sourceActionSheet = [self makePhotoSourceActionSheet];
    [self presentViewController:sourceActionSheet animated:YES completion:nil];
}

#pragma mark Supporting Methods

- (UIAlertController *)makePhotoSourceActionSheet {
    NSString *title = NSLocalizedString(@"Choose source", @"start screen");
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title
                                                                         message:nil
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    NSArray *sourceTypes = @[
                             @(UIImagePickerControllerSourceTypeCamera),
                             @(UIImagePickerControllerSourceTypePhotoLibrary),
                             @(UIImagePickerControllerSourceTypeSavedPhotosAlbum)
                             ];
    for (NSNumber *sourceTypeNumber in sourceTypes) {
        UIImagePickerControllerSourceType sourceType = [sourceTypeNumber integerValue];
        if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
            continue;
        }
        
        __weak typeof(self) wSelf = self;
        void (^tapHandler)(UIAlertAction *) = ^(UIAlertAction *action) {
            UIImagePickerController *picker = [wSelf makeImagePickerControllerWithSourceType:sourceType];
            [wSelf presentViewController:picker animated:YES completion:nil];
        };
        UIAlertAction *action = [UIAlertAction actionWithTitle:[self titleForImagePickerSourceType:sourceType]
                                                         style:UIAlertActionStyleDefault
                                                       handler:tapHandler];
        [actionSheet addAction:action];
    }
    
    NSString *cancelTitle = NSLocalizedString(@"Cancel", @"start screen");
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [actionSheet addAction:cancelAction];
    
    return actionSheet;
}

- (UIImagePickerController *)makeImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *picker = [UIImagePickerController new];
    picker.sourceType = sourceType;
    return picker;
}

- (NSString *)titleForImagePickerSourceType:(UIImagePickerControllerSourceType)sourceType {
    NSString *result = @"";
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        result = NSLocalizedString(@"Camera", @"start screen");
    } else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        result = NSLocalizedString(@"Photo Library", @"start screen");
    } else if (sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
        result = NSLocalizedString(@"Saved Photos", @"start screen");
    }
    
    return result;
}

@end
