//
//  NKGridFrameLayout.h
//  Pods
//
//  Created by Nam Kennic on 7/24/18.
//

#import "NKStackFrameLayout.h"

@interface NKGridFrameLayout : NKStackFrameLayout

- (instancetype) init __deprecated_msg("Use NKStackFrameLayout instead");
- (instancetype) initWithFrame:(CGRect)frame __deprecated_msg("Use NKStackFrameLayout instead");
- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction __deprecated_msg("Use NKStackFrameLayout instead");
- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction andViews:(NSArray<UIView*>*)viewArray __deprecated_msg("Use NKStackFrameLayout instead");

@end
