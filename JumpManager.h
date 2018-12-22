//
//  JumpManager.h
//  tk_hybrid_demo
//
//  Created by terry.guo on 2018/6/19.
//  Copyright © 2018年 Terry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JumpManager : NSObject

+ (BOOL)canAndGoOutWithLink:(NSString *)link;

+ (BOOL)openPageWithLink:(NSString *)link;

+ (BOOL)openPageWithLink:(NSString *)link withObject:(id)anObject;

+ (NSMutableDictionary *)convertLinkURLtoParam:(NSString *)linkURL;

@end
