//
//  NKFrameLayout.m
//  NKFrameLayout
//
//  Created by Nam Kennic on 3/4/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

#import "NKFrameLayout.h"
#import "CGRect_Extends.h"

#define FRAME_DEBUG 1

#if FRAME_DEBUG
#define ONLY_DRAW_FRAME_WITH_VISIBLE_CONTENT 0
#define INSET_FRAME_DEBUG 0
#endif

const UIControlContentHorizontalAlignment	UIControlContentHorizontalAlignmentFit	= 4;
const UIControlContentVerticalAlignment		UIControlContentVerticalAlignmentFit	= 4;

@implementation NKFrameLayout {
	NSMutableDictionary *sizeCacheData;
}

@synthesize targetView, targetFrame;
@synthesize edgeInsets, minSize, maxSize, ignoreHiddenView, debugColor;
@synthesize contentVerticalAlignment, contentHorizontalAlignment;


#pragma mark - Class Methods

+ (NKFrameLayout*) frameLayoutWithTargetView:(UIView*)view {
	NKFrameLayout *frameLayout = [[NKFrameLayout alloc] init];
	frameLayout.targetView = view;
	return frameLayout;
}

#pragma mark - Initialization

- (instancetype) init {
	if ((self = [super init])) {
		[self setupDefaultValues];
	}
	
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self setupDefaultValues];
	}
	
	return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self setupDefaultValues];
	}
	
	return self;
}

- (instancetype) initWithTargetView:(UIView*)view {
	if ((self = [self init])) {
		self.targetView = view;
	}
	
	return self;
}

#pragma mark -

- (void) setupDefaultValues {
	self.backgroundColor			= [UIColor clearColor];
	
#if DEBUG
#if FRAME_DEBUG
	self.debugColor					= [self randomColor];
#endif
#endif
	
	sizeCacheData					= [NSMutableDictionary new];
	
	self.tag						= -1;
	self.userInteractionEnabled		= NO;
	self.ignoreHiddenView			= YES;
	self.shouldCacheSize			= NO;
	self.edgeInsets					= UIEdgeInsetsZero;
	self.minSize					= CGSizeZero;
	self.maxSize					= CGSizeZero;
	self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
	self.contentVerticalAlignment	= UIControlContentVerticalAlignmentFill;
	self.allowContentHorizontalGrowing		= NO;
	self.allowContentHorizontalShrinking	= NO;
	self.allowContentVerticalGrowing		= NO;
	self.allowContentVerticalShrinking		= NO;
	
#if FRAME_DEBUG
	self.showFrameDebug						= NO;
#else
	self.showFrameDebug						= NO;
#endif
}


#pragma mark - Public Methods

- (CGSize) sizeThatFits:(CGSize)size {
	BOOL isHiddenView = !self.targetView || (self.targetView && self.targetView.hidden && self.ignoreHiddenView) || self.hidden;
	if (isHiddenView) return CGSizeZero;
	
	CGSize result;
	
	NSInteger verticalEdgeValues	= edgeInsets.left + edgeInsets.right;
	NSInteger horizontalEdgeValues	= edgeInsets.top  + edgeInsets.bottom;
	
	if (CGSizeEqualToSize(self.minSize, self.maxSize) && self.minSize.width>0 && self.minSize.height>0) {
		result = self.minSize;
	}
	else {
		CGSize contentSize = CGSizeMake(MAX(size.width - verticalEdgeValues, 0), MAX(size.height - horizontalEdgeValues, 0));
		
		result = [self targetSizeThatFits:contentSize];
		
		result.width	= MAX(self.minSize.width,  result.width);
		result.height	= MAX(self.minSize.height, result.height);
		if (self.maxSize.width>0  && self.maxSize.width>=self.minSize.width)   result.width  = MIN(self.maxSize.width,  result.width);
		if (self.maxSize.height>0 && self.maxSize.height>=self.minSize.height) result.height = MIN(self.maxSize.height, result.height);
	}
	
	if (result.width>0)  result.width  += verticalEdgeValues;
	if (result.height>0) result.height += horizontalEdgeValues;
	result.width  = MIN(result.width,  size.width);
	result.height = MIN(result.height, size.height);
	
	return result;
}


#pragma mark - Private Methods

- (CGSize) targetSizeThatFits:(CGSize)size {
	CGSize result;
	
	if (self.shouldCacheSize) {
		if (self.targetView) {
			NSString *key = [[NSString stringWithFormat:@"%i", (int)[self.targetView hash]] stringByAppendingString:NSStringFromCGSize(size)];
			NSString *value = sizeCacheData[key];
			
			if (!value) {
				result = [self.targetView sizeThatFits:size];
				value = NSStringFromCGSize(result);
				[sizeCacheData setObject:value forKey:key];
			}
			else {
				result = CGSizeFromString(value);
			}
		}
		else {
			result = CGSizeZero;
		}
	}
	else {
		result = [self.targetView sizeThatFits:size];
	}
	
	return result;
}

- (void) layoutSubviews {
	if (self.hidden || self.targetView.hidden) return;
	if (self.bounds.size.width<1 || self.bounds.size.height<1) return;
	
	CGRect containerFrame	= UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets);
	CGSize contentSize		= self.contentHorizontalAlignment!=UIControlContentHorizontalAlignmentFill || self.contentVerticalAlignment!=UIControlContentVerticalAlignmentFill ? [self targetSizeThatFits:containerFrame.size] : CGSizeZero;
	
	switch (self.contentHorizontalAlignment) {
		case UIControlContentHorizontalAlignmentLeft:
			if (_allowContentHorizontalGrowing) {
				targetFrame.size.width	= MAX(containerFrame.size.width, contentSize.width);
			}
			else if (_allowContentHorizontalShrinking) {
				targetFrame.size.width	= MIN(containerFrame.size.width, contentSize.width);
			}
			else {
				targetFrame.size.width	= contentSize.width;
			}
			
			targetFrame.origin.x = containerFrame.origin.x;
			break;
			
		case UIControlContentHorizontalAlignmentRight:
			if (_allowContentHorizontalGrowing) {
				targetFrame.size.width	= MAX(containerFrame.size.width, contentSize.width);
			}
			else if (_allowContentHorizontalShrinking) {
				targetFrame.size.width	= MIN(containerFrame.size.width, contentSize.width);
			}
			else {
				targetFrame.size.width	= contentSize.width;
			}
			
			targetFrame.origin.x = containerFrame.origin.x + (containerFrame.size.width - contentSize.width);
			break;
			
		case UIControlContentHorizontalAlignmentCenter:
			if (_allowContentHorizontalGrowing) {
				targetFrame.size.width	= MAX(containerFrame.size.width, contentSize.width);
			}
			else if (_allowContentHorizontalShrinking) {
				targetFrame.size.width	= MIN(containerFrame.size.width, contentSize.width);
			}
			else {
				targetFrame.size.width	= contentSize.width;
			}
			
			targetFrame.origin.x = containerFrame.origin.x + roundf(containerFrame.size.width/2 - contentSize.width/2);
			break;
			
		case UIControlContentHorizontalAlignmentFill:
			targetFrame.origin.x	= containerFrame.origin.x;
			targetFrame.size.width	= containerFrame.size.width;
			break;
			
		case UIControlContentHorizontalAlignmentFit:
			targetFrame.size.width	= MIN(containerFrame.size.width, contentSize.width);
			targetFrame.origin.x	= containerFrame.origin.x + roundf(containerFrame.size.width/2 - targetFrame.size.width/2);
			break;
	}
	
	switch (self.contentVerticalAlignment) {
		case UIControlContentVerticalAlignmentTop:
			if (_allowContentVerticalGrowing) {
				targetFrame.size.height = MAX(containerFrame.size.height, contentSize.height);
			}
			else if (_allowContentVerticalShrinking) {
				targetFrame.size.height = MIN(containerFrame.size.height, contentSize.height);
			}
			else {
				targetFrame.size.height	= contentSize.height;
			}
			
			targetFrame.origin.y = containerFrame.origin.y;
			break;
			
		case UIControlContentVerticalAlignmentBottom:
			if (_allowContentVerticalGrowing) {
				targetFrame.size.height = MAX(containerFrame.size.height, contentSize.height);
			}
			else if (_allowContentVerticalShrinking) {
				targetFrame.size.height = MIN(containerFrame.size.height, contentSize.height);
			}
			else {
				targetFrame.size.height	= contentSize.height;
			}
			
			targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - contentSize.height);
			break;
			
		case UIControlContentVerticalAlignmentCenter:
			if (_allowContentVerticalGrowing) {
				targetFrame.size.height = MAX(containerFrame.size.height, contentSize.height);
			}
			else if (_allowContentVerticalShrinking) {
				targetFrame.size.height = MIN(containerFrame.size.height, contentSize.height);
			}
			else {
				targetFrame.size.height	= contentSize.height;
			}
			targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - contentSize.height)/2;
			break;
			
		case UIControlContentVerticalAlignmentFill:
			targetFrame.origin.y	= containerFrame.origin.y;
			targetFrame.size.height = containerFrame.size.height;
			break;
			
		case UIControlContentVerticalAlignmentFit:
			if (_allowContentVerticalGrowing) {
				targetFrame.size.height = MAX(containerFrame.size.height, contentSize.height);
			}
			else if (_allowContentVerticalShrinking) {
				targetFrame.size.height = MIN(containerFrame.size.height, contentSize.height);
			}
			else {
				targetFrame.size.height	= contentSize.height;
			}
			targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - targetFrame.size.height)/2;
			break;
	}
	
	targetFrame = CGRectIntegral(targetFrame);
	
	if (self.targetView.superview==self) {
		self.targetView.frame = targetFrame;
	}
	else if (self.targetView.superview) {
		self.targetView.frame = [self convertRect:targetFrame toView:self.targetView.superview];
	}
}

#if DEBUG
#if FRAME_DEBUG
- (void) drawRect:(CGRect)rect {
	if (!_showFrameDebug) {
		[super drawRect:rect];
		return;
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect debugBound = self.bounds;
#if INSET_FRAME_DEBUG
	debugBound = UIEdgeInsetsInsetRect(debugBound, self.edgeInsets);
#endif
	
	BOOL enableDrawing = YES;
#if ONLY_DRAW_FRAME_WITH_VISIBLE_CONTENT
	enableDrawing = self.targetView!=nil && !self.targetView.hidden;
#else
	enableDrawing = YES;//self.tag>-1;
#endif
	
	if (enableDrawing) {
		CGContextSaveGState(context);
		CGFloat dashes[] = {4.0, 2.0};
		CGContextSetStrokeColorWithColor(context, [self.debugColor CGColor]);
		CGContextSetLineDash(context, 0, dashes, 2);
		CGContextStrokeRect(context, debugBound);
		CGContextRestoreGState(context);
		
		if (self.tag>-1) {
			CGContextSetFillColorWithColor(context, [self.debugColor CGColor]);
			NSString *tagText = [NSString stringWithFormat:@"%i", (int)self.tag];
			UIFont *font = [UIFont fontWithName:@"Arial" size:12];
			NSDictionary *attributes = @{NSFontAttributeName:font};
			CGRect tagTextFrame = [tagText boundingRectWithSize:debugBound.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
			tagTextFrame.origin.x = roundf(debugBound.size.width/2 - tagTextFrame.size.width/2);
			tagTextFrame.origin.y = roundf(debugBound.size.height/2 - tagTextFrame.size.height/2);
			[tagText drawInRect:tagTextFrame withAttributes:attributes];
		}
	}
}

- (UIColor*) randomColor {
	NSArray *colorArray = @[[UIColor redColor],
							[UIColor blueColor],
							[UIColor magentaColor],
							[UIColor brownColor],
							[UIColor blackColor],
							[UIColor orangeColor],
							[UIColor purpleColor]];
	
	int randomIndex = arc4random() % [colorArray count];
	return colorArray[randomIndex];
}
#endif
#endif


#pragma mark - Properties

- (void) setFrame:(CGRect)rect {
	if (isnan(rect.origin.x) || isnan(rect.origin.y) || isnan(rect.size.width) || isnan(rect.size.height)) return;
	if (isinf(rect.origin.x) || isinf(rect.origin.y) || isinf(rect.size.width) || isinf(rect.size.height)) return;
	
	[super setFrame:rect];
	
	[self setNeedsLayout];
#if FRAME_DEBUG
	[self setNeedsDisplay];
#endif
}

- (void) setBounds:(CGRect)rect {
	if (isnan(rect.origin.x) || isnan(rect.origin.y) || isnan(rect.size.width) || isnan(rect.size.height)) return;
	if (isinf(rect.origin.x) || isinf(rect.origin.y) || isinf(rect.size.width) || isinf(rect.size.height)) return;
	
	[super setBounds:rect];
	
	[self setNeedsLayout];
#if FRAME_DEBUG
	[self setNeedsDisplay];
#endif
}

- (void) setFixSize:(CGSize)size {
	_fixSize = size;
	self.minSize = self.maxSize = size;
}

- (void) setSettingBlock:(void (^)(NKFrameLayout *))settingBlock {
	if (settingBlock) settingBlock(self);
}

- (void) setContentAlignment:(NSString *)value {
	if ([value length]==2) {
		NSString *vValue = [[value substringToIndex:1]	 lowercaseString]; // t=top c=center b=bottom f=fill t=fit
		NSString *hValue = [[value substringFromIndex:1] lowercaseString]; // l=left c=center r=right f=fill t=fit
		
		if ([vValue isEqualToString:@"t"]) {
			self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
		}
		else if ([vValue isEqualToString:@"c"]) {
			self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		}
		else if ([vValue isEqualToString:@"b"]) {
			self.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
		}
		else if ([vValue isEqualToString:@"f"]) {
			self.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
		}
		else if ([vValue isEqualToString:@"t"]) {
			self.contentVerticalAlignment = UIControlContentVerticalAlignmentFit;
		}
		
		if ([hValue isEqualToString:@"l"]) {
			self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		}
		else if ([hValue isEqualToString:@"c"]) {
			self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		}
		else if ([hValue isEqualToString:@"r"]) {
			self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
		}
		else if ([hValue isEqualToString:@"f"]) {
			self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
		}
		else if ([hValue isEqualToString:@"t"]) {
			self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFit;
		}
	}
}

- (void) setShowFrameDebug:(BOOL)value {
	if (_showFrameDebug != value) {
		_showFrameDebug = value;
		
		if (_showFrameDebug) [self setNeedsDisplay];
	}
}


#pragma mark -

- (void) dealloc {
	self.debugColor = nil;
	self.targetView = nil;
}

@end
