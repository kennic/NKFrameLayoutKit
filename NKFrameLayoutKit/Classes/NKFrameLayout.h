//
//  NKFrameLayout.h
//  NKFrameLayout
//
//  Created by Nam Kennic on 3/4/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

@import CoreGraphics;
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern const UIControlContentHorizontalAlignment	UIControlContentHorizontalAlignmentFit;
extern const UIControlContentVerticalAlignment		UIControlContentVerticalAlignmentFit;

@interface NKFrameLayout : UIView

@property (nonatomic, readonly) CGRect		targetFrame; // returns current frame of targetView
@property (nonatomic, retain) UIView		*targetView;
@property (nonatomic, retain) UIColor		*debugColor;
@property (nonatomic, assign) UIEdgeInsets	edgeInsets; // extend edge insets, will be added only if content size is non-zero
@property (nonatomic, assign) CGSize		minSize;	// Default is CGSizeZero
@property (nonatomic, assign) CGSize		maxSize;	// Default is CGSizeZero
@property (nonatomic, assign) CGSize		fixSize;	// fast way to set minSize = maxSize = value
@property (nonatomic, assign) BOOL			ignoreHiddenView; // Default is YES. Return CGSizeZero in sizeThatFits: if targetView.hidden==YES.
@property (nonatomic, assign) BOOL			shouldCacheSize; // Default is NO. This will cache targetView's size to avoid calling sizeThatFits.
@property (nonatomic, assign) BOOL			intrinsicSizeEnabled; // Internal use, to be used for multi-frames
@property (nonatomic, assign) UIControlContentVerticalAlignment		contentVerticalAlignment;	// default is UIControlContentVerticalAlignmentFill
@property (nonatomic, assign) UIControlContentHorizontalAlignment	contentHorizontalAlignment; // default is UIControlContentHorizontalAlignmentFill
@property (nonatomic, assign) NSString		*contentAlignment;

@property (nonatomic, assign) BOOL showFrameDebug;

@property (nonatomic, assign) BOOL allowContentVerticalGrowing;		// Height of target will be grown if this frame's height was larger than target's height. NO will keep original target's height. Default is NO
@property (nonatomic, assign) BOOL allowContentVerticalShrinking;	// Height of target will be shrinked if this frame's height was smaller than target's height. NO will keep original target's height. Default is NO
@property (nonatomic, assign) BOOL allowContentHorizontalGrowing;	// same as above, but set to width
@property (nonatomic, assign) BOOL allowContentHorizontalShrinking;	// same as above, but set to width

@property (nonatomic, copy) void (^settingBlock)(NKFrameLayout *frameLayout);

- (instancetype) initWithTargetView:(UIView*)view;
+ (NKFrameLayout*) frameLayoutWithTargetView:(UIView*)view;

@end
