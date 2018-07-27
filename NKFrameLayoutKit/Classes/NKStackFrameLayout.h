//
//  NKStackFrameLayout.h
//  NKFrameLayoutKit
//
//  Created by Nam Kennic on 3/8/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

#import "NKDoubleFrameLayout.h"
#import "NKFrameLayout.h"

/**
Grid FrameLayout class that handles multi views' frame
*/
@interface NKStackFrameLayout : NKFrameLayout

@property (nonatomic, readonly) NSArray<NKFrameLayout*> *frameLayoutArray;
@property (nonatomic, assign) NSInteger					numberOfFrameLayouts;
@property (nonatomic, assign) NKFrameLayoutDirection	layoutDirection;
@property (nonatomic, assign) NKFrameLayoutAlignment	layoutAlignment;
/** Space between frames, will be applied only when primary-aligned frame is non-zero */
@property (nonatomic, assign) CGFloat					spacing;
///** Set to YES to returns total contents width, NO to use specified width in sizeThatFits. Default is YES. */
//@property (nonatomic, assign) BOOL						intrinsicSizeEnabled;
/** Set to YES to auto remove targetView from its superview when removing its frameLayout. Default is NO. */
@property (nonatomic, assign) BOOL						autoRemoveTargetView;
/** YES to round cell size using roundf(), default is NO */
@property (nonatomic, assign) BOOL						roundUpValue;

- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction;
- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction andViews:(NSArray<UIView*>*)viewArray;

- (NKFrameLayout*) addFrameLayout;
- (NKFrameLayout*) addFrameLayout:(NKFrameLayout*)frameLayout;
- (NKFrameLayout*) addFrameLayoutWithTargetView:(UIView*)view;
- (NKFrameLayout*) insertFrameLayoutAtIndex:(NSUInteger)index;
- (NKFrameLayout*) frameLayoutAtIndex:(NSInteger)index;
- (NKFrameLayout*) frameLayoutWithTag:(NSInteger)tag;
- (NKFrameLayout*) frameLayoutWithView:(UIView*)view;

- (NKFrameLayout*) firstFrameLayout;
- (NKFrameLayout*) lastFrameLayout;

// Keyed-Subscripting
- (id) objectAtIndexedSubscript:(NSInteger)index;
- (void) setObject:(id)object atIndexedSubscript:(NSInteger)index;

- (NKFrameLayout*) insertFrameLayout:(NKFrameLayout*)frameLayout atIndex:(NSUInteger)index;
- (void) replaceFrameLayout:(NKFrameLayout*)frameLayout atIndex:(NSUInteger)index;
- (void) removeFrameAtIndex:(NSUInteger)index;
- (void) removeAllFrameLayout;
- (void) enumerateFrameLayoutUsingBlock:(void (NS_NOESCAPE ^)(NKFrameLayout *frameLayout, NSUInteger idx, BOOL *stop))block;

@end
