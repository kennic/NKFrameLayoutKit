//
//  NKDoubleFrameLayout.h
//  NKFrameLayout
//
//  Created by Nam Kennic on 3/6/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

#import "NKFrameLayout.h"

@protocol NKHorizontalLayout <NSObject>

@required
@property (nonatomic, retain) NKFrameLayout *leftFrameLayout;
@property (nonatomic, retain) NKFrameLayout *rightFrameLayout;

@end

#pragma mark -

@protocol NKVerticalLayout <NSObject>

@required
@property (nonatomic, retain) NKFrameLayout *topFrameLayout;
@property (nonatomic, retain) NKFrameLayout *bottomFrameLayout;

@end

#pragma mark -

typedef NS_ENUM(NSInteger, NKFrameLayoutAlignment) {
	NKFrameLayoutAlignmentTop = 0,
	NKFrameLayoutAlignmentBottom,
	NKFrameLayoutAlignmentLeft  = NKFrameLayoutAlignmentTop,
	NKFrameLayoutAlignmentRight = NKFrameLayoutAlignmentBottom,
	NKFrameLayoutAlignmentSplit, // aligned based on splitPercent value
	NKFrameLayoutAlignmentCenter // align center both contents of both frameLayout to center of main frame
};

typedef NS_ENUM(NSInteger, NKFrameLayoutDirection) {
	NKFrameLayoutDirectionHorizontal = 0,	// left - right
	NKFrameLayoutDirectionVertical,			// top - bottom
	NKFrameLayoutDirectionAuto				// auto detect base on main size
};

#define FrameLayoutAlignmentIsHorizontal(layoutAlignment)  ((layoutAlignment) == NKFrameLayoutAlignmentLeft || (layoutAlignment) == NKFrameLayoutAlignmentRight)
#define FrameLayoutAlignmentIsVertical(layoutAlignment)    ((layoutAlignment) == NKFrameLayoutAlignmentTop  || (layoutAlignment) == NKFrameLayoutAlignmentBottom)

@interface NKDoubleFrameLayout : NKFrameLayout <NKHorizontalLayout, NKVerticalLayout> {
	NKFrameLayout *frameLayout1;
	NKFrameLayout *frameLayout2;
}

@property (nonatomic, retain) NKFrameLayout				*frameLayout1;	// is leftFrameLayout or topFrameLayout based on direction
@property (nonatomic, retain) NKFrameLayout				*frameLayout2;	// is rightFrameLayout or bottomFrameLayout based on direction
@property (nonatomic, assign) NKFrameLayoutDirection	layoutDirection;
@property (nonatomic, assign) NKFrameLayoutAlignment	layoutAlignment;
@property (nonatomic, assign) CGFloat					splitPercent;	// 0.0 ... 1.0, default is 0.5 (center)
@property (nonatomic, assign) CGFloat					spacing;		// space between two frames, only used when primary-aligned frame is non-zero
@property (nonatomic, assign) BOOL						intrinsicSizeEnabled; // Default is NO. If YES, size returned from [sizeThatFits:size] will returns its intrinsicSize (real width)
@property (nonatomic, assign) BOOL						alwaysFitToIntrinsicSize; // Default is NO. If YES, each frame layout will fit to its intrinsicSize
@property (nonatomic, assign) BOOL						shouldCacheSize;

- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction;
- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction andViews:(NSArray<UIView*>*)viewArray;

@end
