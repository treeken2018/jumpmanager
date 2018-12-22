//
//  HybridBridgeImpl.m
//  tk_hybrid_demo
//
//  Created by terry.guo on 2018/6/19.
//  Copyright © 2018年 Terry. All rights reserved.
//

#import "NSJSONSerialization+Shortcuts.h"

#import "JumpManager.h"
#import "HybridBridgeImpl.h"

@interface HybridBridgeImpl ()

@property (weak, nonatomic) UIViewController *viewController;

@end

@implementation HybridBridgeImpl

- (instancetype)initWithViewController:(UIViewController *)viewController {
    if (self = [super init]) {
        _viewController = viewController;
    }
    return self;
}

- (void)goTo:(NSString *)jsonString {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *params = [self convertToDictionary:jsonString];
        NSString *file = params[@"file"];
        NSString *webview = @"ui";
        if ([file isEqualToString:@"b.html"])
            webview = @"wk";
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"data/%@",file] withExtension:nil];
        NSString *filePath = [url absoluteString];
        filePath = [filePath stringByAppendingString:[NSString stringWithFormat:@"?webview=%@",webview]];
        if ([file isEqualToString:@"c.html"])
            filePath = [filePath stringByAppendingString:@"&page=tk_page_first"];
        [JumpManager openPageWithLink:filePath withObject:nil];
    });
}

- (NSDictionary *)convertToDictionary:(NSString *)jsonString {
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithString:jsonString options:kNilOptions error:nil];
    if (dictionary) {
        return dictionary;
    }
    return nil;
}

@end
