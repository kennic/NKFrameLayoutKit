//
//  NKTripleFrameLayout.h
//  NKFrameLayout
//
//  Created by Nam Kennic on 3/27/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

#import "NKDoubleFrameLayout.h"

/**
Triple FrameLayout class that handles three views' frame
*/
@interface NKTripleFrameLayout : NKDoubleFrameLayout

@property (nonatomic, strong) NKDoubleFrameLayout	*leftContentLayout;
@property (nonatomic, strong) NKDoubleFrameLayout	*topContentLayout;
@property (nonatomic, strong) NKFrameLayout			*centerFrameLayout;

- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction andViews:(NSArray<UIView *> *)viewArray;

@end
