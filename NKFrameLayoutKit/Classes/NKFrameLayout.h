//
//  NKFrameLayout.h
//  NKFrameLayoutKit
//
//  Created by Nam Kennic on 3/4/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

@import CoreGraphics;
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const UIControlContentHorizontalAlignment	UIControlContentHorizontalAlignmentFit;
extern const UIControlContentVerticalAlignment		UIControlContentVerticalAlignmentFit;
/**
Single FrameLayout class that handles one view's frame
*/
@interface NKFrameLayout : UIView

/** Returns current frame of targetView */
@property (nonatomic, readonly) CGRect		targetFrame;
/** Current view assigned to this FrameLayout */
@property (nonatomic, strong) UIView		*targetView;

@property (nonatomic, strong) UIColor		*debugColor;
/** Extend edge insets, will be added only if content size is non-zero */
@property (nonatomic, assign) UIEdgeInsets	edgeInsets;
/** Default is CGSizeZero */
@property (nonatomic, assign) CGSize		minSize;
/** Default is CGSizeZero */
@property (nonatomic, assign) CGSize		maxSize;
/** Fast way to set minSize = maxSize = value */
@property (nonatomic, assign) CGSize		fixSize;
/** `sizeThatFits` will return height value base on the ratio of width. This value will be overridden by minSize, maxSize, fixSize */
@property (nonatomic, assign) CGFloat 		heightRatio;
/** Return CGSizeZero in sizeThatFits: if targetView.hidden==YES. Default is YES. */
@property (nonatomic, assign) BOOL			ignoreHiddenView;
/** This will cache targetView's size to avoid calling sizeThatFits. Default is NO. */
@property (nonatomic, assign) BOOL			shouldCacheSize;
/** Internal use, to be used for multi-frames */
@property (nonatomic, assign) BOOL			intrinsicSizeEnabled;
/** Internal use, to be used for multi-frames */
@property (nonatomic, assign) BOOL			isFlexible;
/** Default is UIControlContentVerticalAlignmentFill */
@property (nonatomic, assign) UIControlContentVerticalAlignment		contentVerticalAlignment;
/** Default is UIControlContentHorizontalAlignmentFill */
@property (nonatomic, assign) UIControlContentHorizontalAlignment	contentHorizontalAlignment;
/** Fast way to set content alignment. Example: .contentAlignment = @"tl"; // (top-left)*/
@property (nonatomic, assign) NSString		*contentAlignment; // t=top c=center b=bottom f=fill z=fit / l=left c=center r=right f=fill z=fit

/** Show frame debug */
@property (nonatomic, assign) BOOL showFrameDebug;

/** Height of target will be grown if this frame's height is larger than target's height. NO will keep original target's height. Default is NO */
@property (nonatomic, assign) BOOL allowContentVerticalGrowing;
/** Height of target will be shrinked if this frame's height is smaller than target's height. NO will keep original target's height. Default is NO */
@property (nonatomic, assign) BOOL allowContentVerticalShrinking;
/** Width of target will be grown if this frame's width is larger than target's width. NO will keep original target's width. Default is NO */
@property (nonatomic, assign) BOOL allowContentHorizontalGrowing;
/** Width of target will be shrinked if this frame's width is smaller than target's width. NO will keep original target's width. Default is NO */
@property (nonatomic, assign) BOOL allowContentHorizontalShrinking;

@property (nonatomic, copy) void (^configurationBlock)(NKFrameLayout *frameLayout);

- (instancetype) initWithTargetView:(UIView*)view;
+ (NKFrameLayout*) frameLayoutWithTargetView:(UIView*)view;
+ (BOOL) loggingEnabled;
+ (void) setLoggingEnabled:(BOOL)value;

@end
