//
//  NKTripleFrameLayout.h
//  NKFrameLayoutKit
//
//  Created by Nam Kennic on 3/27/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

#import "NKDoubleFrameLayout.h"

/**
Triple FrameLayout class that handles three views' frame
*/
@interface NKTripleFrameLayout : NKDoubleFrameLayout

@property (nonatomic, readonly) NKDoubleFrameLayout	*leftContentLayout;
@property (nonatomic, readonly) NKDoubleFrameLayout	*topContentLayout;
@property (nonatomic, strong) NKFrameLayout			*centerFrameLayout;

- (instancetype) init __deprecated_msg("Use NKStackFrameLayout instead");
- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction __deprecated_msg("Use NKStackFrameLayout instead");
- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction andViews:(NSArray<UIView *> *)viewArray __deprecated_msg("Use NKStackFrameLayout instead");

@end
