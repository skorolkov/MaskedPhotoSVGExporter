//
//  ViewResultController.m
//  MaskedPhotoSVGExporter
//
//  Created by Sergey Korolkov on 20.10.16.
//  Copyright © 2016 polecat. All rights reserved.
//

#import "ViewResultController.h"
#import "ImageBase64Serializer.h"

@import WebKit;

typedef NS_ENUM(NSInteger, ViewResultType) {
    ViewResultTypeText = 0,
    ViewResultTypeWebView,
    ViewResultTypeImage
};

@interface ViewResultController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *svgTextView;
@property (weak, nonatomic) IBOutlet UIView *webViewContainer;
@property (strong, nonatomic) WKWebView *webView;

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
    [self createWebView];
    [self setupViews];
}

#pragma mark Actions

- (IBAction)resultTypeSegmentedControlChanged:(UISegmentedControl *)sender {
    [self setupViewResultType:sender.selectedSegmentIndex];
}

#pragma mark Views Support

- (void)createWebView {
    self.webView = [[WKWebView alloc] initWithFrame:self.webViewContainer.bounds];
    [self.webViewContainer addSubview:self.webView];
    
    self.webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                     UIViewAutoresizingFlexibleHeight);
}

- (void)setupViews {
    self.imageView.image = self.image;
    
    NSString *base64String = [ImageBase64Serializer base64StringFromImage:self.image];
    NSString *svgString = [self.croppingMask svgTextWithImageBase64Data:base64String];
    
    NSString *stringToShow = [NSString stringWithFormat:@"%@...",
                              [svgString substringToIndex:MIN(300, svgString.length - 1)]];
    self.svgTextView.text = stringToShow;
    
    NSString *htmlString = [self htmlStringWithEmbeddedSVG:svgString];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    
    [self setupViewResultType:ViewResultTypeText];
}

- (void)setupViewResultType:(ViewResultType)type {
    if (type == ViewResultTypeText) {
        self.svgTextView.hidden = NO;
        self.webViewContainer.hidden = YES;
        self.imageView.hidden = YES;
    } else if (type == ViewResultTypeWebView) {
        self.svgTextView.hidden = YES;
        self.webViewContainer.hidden = NO;
        self.imageView.hidden = YES;
    } else if (type == ViewResultTypeImage) {
        self.svgTextView.hidden = YES;
        self.webViewContainer.hidden = YES;
        self.imageView.hidden = NO;
    }
}

- (NSString *)htmlStringWithEmbeddedSVG:(NSString *)svgString {
    NSString *result = [NSString stringWithFormat:
                        @"<!DOCTYPE html><html><body>"
                        "<div align=\"center\">%@</div>"
                        "</body></html>", svgString];
    return result;
}

@end
