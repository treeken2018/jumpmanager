//
//  JumpManager.m
//  tk_hybrid_demo
//
//  Created by terry.guo on 2018/6/19.
//  Copyright © 2018年 Terry. All rights reserved.
//
#import "WebViewController.h"
#import "WKWebViewController.h"
#import "BaseViewController.h"

#import "JumpManager.h"

static NSString * const kWebviewIdentifier = @"webview";
static NSString * const kWKWebviewIdentifier = @"wk";
static NSString * const kUIWebviewIdentifier = @"ui";

@interface JumpManager ()

@property (strong, nonatomic) NSDictionary *mappings;

@end

@implementation JumpManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static JumpManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupMappings];
    }
    return self;
}

- (void)setupMappings {
    [self registerPage:@"IndexViewController"    identifier:@"tk_page_index"];
    [self registerPage:@"FirstViewController"    identifier:@"tk_page_first"];
    [self registerPage:@"SecondViewController"   identifier:@"tk_page_second"];
}

#pragma mark --是否拦截
+ (BOOL)canAndGoOutWithLink:(NSString *)link {
    Class class = [[JumpManager sharedInstance]classFromLink:link];
    return class != nil;
}

#pragma mark --跳转
+ (BOOL)openPageWithLink:(NSString *)link {
    return [JumpManager openPageWithLink:link withObject:nil];
}

+ (BOOL)openPageWithLink:(NSString *)link withObject:(id)anObject {
    Class class = [[JumpManager sharedInstance]classFromLink:link];
    if (class) {
        BaseViewController *viewController = [[class alloc]initWithPageLink:link withObject:anObject];
        return [[JumpManager sharedInstance]pushViewController:viewController];
    }else {
        return [JumpManager openH5PageWithLink:link];
    }
}

+ (BOOL)openH5PageWithLink:(NSString *)link {
    NSDictionary *urlParams = [self convertLinkURLtoParam:link];
    NSString *useWhichWebView = urlParams[kWebviewIdentifier];
    if ([useWhichWebView isEqualToString:kWKWebviewIdentifier]) {
        WKWebViewController *wkWebViewController = [WKWebViewController webVCWithURLString:link];
        return [[JumpManager sharedInstance]pushViewController:wkWebViewController];
    } else {
        WebViewController *webViewController = [WebViewController webVCWithURLString:link];
        return [[JumpManager sharedInstance]pushViewController:webViewController];
    }
}

+ (NSMutableDictionary *)convertLinkURLtoParam:(NSString *)linkURL {
    NSRange range = [linkURL rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        NSString *paramStr = [linkURL substringFromIndex:range.location+1];
        
        NSArray *arrParam = [paramStr componentsSeparatedByString:@"&"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        
        for (NSString *subParam in arrParam) {
            NSArray *arrsub = [subParam componentsSeparatedByString:@"="];
            NSString *value = [[arrsub objectAtIndex:1] stringByRemovingPercentEncoding];
            [dic setObject:value forKey:[arrsub objectAtIndex:0]];
        }
        
        return dic;
    }
    return nil;
}

#pragma mark --私有
- (Class)classFromLink:(NSString *)aLink {
    __block  BOOL match;
   __block NSString *key = nil;
    [[self.mappings allKeys]enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       match = [aLink rangeOfString:obj].location != NSNotFound;
        if (match) {
            key = obj;
            *stop = YES;
        }
    }];
    if (key) return NSClassFromString(self.mappings[key]);
    return nil;
}

- (void)registerPage:(NSString *)pageName
          identifier:(NSString *)identifier {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.mappings];
    if (pageName.length > 0 && identifier.length > 0)
        [dict setObject:pageName forKey:identifier];
    self.mappings = [NSDictionary dictionaryWithDictionary:dict];
}

- (BOOL)pushViewController:(UIViewController *)vc {
    if (vc == nil) {
        return NO;
    }
    
    UIApplication *app = [UIApplication sharedApplication];
    UIViewController *rootVC = [app valueForKeyPath:@"delegate.window.rootViewController"];
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *nVC = [(UITabBarController *)rootVC selectedViewController];
        
        if ([nVC isKindOfClass:[UINavigationController class]]) {
            vc.hidesBottomBarWhenPushed = YES;
            [(UINavigationController *)nVC pushViewController:vc animated:YES];
            
            return YES;
        }
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)rootVC pushViewController:vc animated:YES];
        return YES;
    }else {
        if ([rootVC respondsToSelector:@selector(selectedViewController)]) {
            UIViewController *nVC = [(UITabBarController *)rootVC selectedViewController];
            if ([nVC isKindOfClass:[UINavigationController class]]) {
                vc.hidesBottomBarWhenPushed = YES;
                [(UINavigationController *)nVC pushViewController:vc animated:YES];
                
                return YES;
            }
        }
    }
    return NO;
}

@end
