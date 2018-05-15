//
//  NKTripleFrameLayout.m
//  NKFrameLayoutKit
//
//  Created by Nam Kennic on 3/27/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

#import "NKTripleFrameLayout.h"

@implementation NKTripleFrameLayout


#pragma mark - Initialization

- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction {
	if ((self = [super initWithDirection:direction])) {
		_leftContentLayout = [[NKDoubleFrameLayout alloc] initWithDirection:direction];
		_leftContentLayout.layoutAlignment = NKFrameLayoutAlignmentLeft;
		_leftContentLayout.intrinsicSizeEnabled = YES;
		
//		self.layoutAlignment = NKFrameLayoutAlignmentRight;
//		self.intrinsicSizeEnabled = NO;
		self.frameLayout1 = _leftContentLayout;
	}
	
	return self;
}

- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction andViews:(NSArray<UIView *> *)viewArray {
	if ((self = [self initWithDirection:direction])) {
		NSInteger index = 1;
		NSInteger count = [viewArray count];
		NKFrameLayout *targetFrameLayout;
		
		for (UIView *view in viewArray) {
			targetFrameLayout = index==1 ? self.leftFrameLayout : (index==2 ? self.centerFrameLayout : self.rightFrameLayout);
			
			if ([view isKindOfClass:[NKFrameLayout class]] && view.superview==nil) {
				NKFrameLayout *frameLayout = (NKFrameLayout*)view;
				if (index==1) {
					self.leftFrameLayout = frameLayout;
				}
				else if (index==2) {
					self.centerFrameLayout = frameLayout;
				}
				else if (index==3) {
					self.rightFrameLayout = frameLayout;
				}
			}
			else {
				targetFrameLayout.targetView = view;
			}
			
			if (index>=count) break;
			index++;
		}
	}
	
	return self;
}


#pragma mark - Properties
	
- (NKFrameLayout*) topContentLayout {
	return _leftContentLayout;
}

- (NKFrameLayout*) leftFrameLayout {
	return _leftContentLayout.frameLayout1;
}

- (void) setLeftFrameLayout:(NKFrameLayout *)frameLayout {
	_leftContentLayout.frameLayout1 = frameLayout;
}

- (NKFrameLayout*) topFrameLayout {
	return _leftContentLayout.frameLayout1;
}

- (void) setTopFrameLayout:(NKFrameLayout *)frameLayout {
	_leftContentLayout.frameLayout1 = frameLayout;
}

- (NKFrameLayout*) centerFrameLayout {
	return _leftContentLayout.frameLayout2;
}

- (void) setCenterFrameLayout:(NKFrameLayout*)frameLayout {
	_leftContentLayout.frameLayout2 = frameLayout;
}

- (void) setSpacing:(CGFloat)value {
	BOOL changed = self.spacing != value;
	[super setSpacing:value];
	
	_leftContentLayout.spacing = value;
	if (changed) [self setNeedsLayout];
}

- (void) setShouldCacheSize:(BOOL)value {
	[super setShouldCacheSize:value];
	_leftContentLayout.shouldCacheSize = value;
}

- (void) setShowFrameDebug:(BOOL)value {
	[super setShowFrameDebug:value];
	
	_leftContentLayout.showFrameDebug = value;
	self.rightFrameLayout.showFrameDebug = value;
}

- (void) setLayoutAlignment:(NKFrameLayoutAlignment)layoutAlignment {
    [super setLayoutAlignment:layoutAlignment];
    _leftContentLayout.layoutAlignment = layoutAlignment;
}

- (void) setIgnoreHiddenView:(BOOL)value {
	[super setIgnoreHiddenView:value];
	
	_leftContentLayout.ignoreHiddenView = value;
}

- (void) setNeedsLayout {
	[super setNeedsLayout];
	
	[self.frameLayout1 setNeedsLayout];
	[self.frameLayout2 setNeedsLayout];
}

@end

