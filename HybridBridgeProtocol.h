//
//  HybridBridgeProtocol.h
//  tk_hybrid_demo
//
//  Created by terry.guo on 2018/6/19.
//  Copyright © 2018年 Terry. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>
#import <Foundation/Foundation.h>

@protocol HybridBridgeProtocol <JSExport>

- (void)goTo:(NSString *)jsonString;

@end
