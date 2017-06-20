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

/**
Double FrameLayout class that handles two views' frame
*/
@interface NKDoubleFrameLayout : NKFrameLayout <NKHorizontalLayout, NKVerticalLayout> {
	NKFrameLayout *frameLayout1;
	NKFrameLayout *frameLayout2;
}

/** First frame layout, equal to leftFrameLayout or topFrameLayout */
@property (nonatomic, retain) NKFrameLayout				*frameLayout1;	// is leftFrameLayout or topFrameLayout based on direction
/** Second frame layout, equal to rightFrameLayout or bottomFrameLayout */
@property (nonatomic, retain) NKFrameLayout				*frameLayout2;	// is rightFrameLayout or bottomFrameLayout based on direction
/** Layout Directional */
@property (nonatomic, assign) NKFrameLayoutDirection	layoutDirection;
/** Layout Alignment */
@property (nonatomic, assign) NKFrameLayoutAlignment	layoutAlignment;
/** Percentage of alignment for split alignment mode. Value is from 0.0 to 1.0, default is 0.5 (center) */
@property (nonatomic, assign) CGFloat					splitPercent;
/** Space between two frames, only used when primary-aligned frame is non-zero */
@property (nonatomic, assign) CGFloat					spacing;
/** If YES, size returned from [sizeThatFits:size] will return its intrinsicSize (real width). Default is NO */
@property (nonatomic, assign) BOOL						intrinsicSizeEnabled;
/** If YES, each frame layout will fit to its intrinsicSize. Default is NO */
@property (nonatomic, assign) BOOL						alwaysFitToIntrinsicSize;

- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction;
- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction andViews:(NSArray<UIView*>*)viewArray;

@end
