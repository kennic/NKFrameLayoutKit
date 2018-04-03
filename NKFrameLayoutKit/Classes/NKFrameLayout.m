//
//  NKFrameLayout.m
//  NKFrameLayoutKit
//
//  Created by Nam Kennic on 3/4/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

#import "NKFrameLayout.h"

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
		_targetView = view;
	}
	
	return self;
}

#pragma mark -

- (void) setupDefaultValues {
	self.backgroundColor				= [UIColor clearColor];
	
#if DEBUG
#if FRAME_DEBUG
	_debugColor							= [self randomColor];
#endif
#endif
	
	sizeCacheData						= [NSMutableDictionary new];
	
	self.tag							= -1;
	self.userInteractionEnabled			= NO;
	_ignoreHiddenView					= YES;
	_shouldCacheSize					= NO;
	_edgeInsets							= UIEdgeInsetsZero;
	_minSize							= CGSizeZero;
	_maxSize							= CGSizeZero;
	_contentHorizontalAlignment			 = UIControlContentHorizontalAlignmentFill;
	_contentVerticalAlignment			= UIControlContentVerticalAlignmentFill;
	_allowContentHorizontalGrowing		= NO;
	_allowContentHorizontalShrinking	= NO;
	_allowContentVerticalGrowing		= NO;
	_allowContentVerticalShrinking		= NO;
	
#if FRAME_DEBUG
	_showFrameDebug						= NO;
#else
	_showFrameDebug						= NO;
#endif
}


#pragma mark - Public Methods

- (CGSize) sizeThatFits:(CGSize)size {
	BOOL isHiddenView = !_targetView || (_targetView && _targetView.hidden && _ignoreHiddenView) || self.hidden;
	if (isHiddenView) return CGSizeZero;
	
	CGSize result;
	
	NSInteger verticalEdgeValues	= _edgeInsets.left + _edgeInsets.right;
	NSInteger horizontalEdgeValues	= _edgeInsets.top  + _edgeInsets.bottom;
	
	if (CGSizeEqualToSize(_minSize, _maxSize) && _minSize.width>0 && _minSize.height>0) {
		result = _minSize; // fixSize
	}
	else {
		CGSize contentSize = CGSizeMake(MAX(size.width - verticalEdgeValues, 0), MAX(size.height - horizontalEdgeValues, 0));
		
		if (_heightRatio > 0.0) {
			result = contentSize;
			result.height = contentSize.width * _heightRatio;
		}
		else {
			result = [self targetSizeThatFits:contentSize];
		}
		
		result.width	= MAX(_minSize.width,  result.width);
		result.height	= MAX(_minSize.height, result.height);
		if (_maxSize.width>0  && _maxSize.width>=_minSize.width)   result.width  = MIN(_maxSize.width,  result.width);
		if (_maxSize.height>0 && _maxSize.height>=_minSize.height) result.height = MIN(_maxSize.height, result.height);
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
	
	if (CGSizeEqualToSize(_minSize, _maxSize) && _minSize.width>0 && _minSize.height>0) {
		result = _minSize; // fixSize
	}
	else {
		if (_shouldCacheSize) {
			if (_targetView) {
				NSString *key = [[NSString stringWithFormat:@"%@", _targetView] stringByAppendingString:NSStringFromCGSize(size)];
				NSString *value = sizeCacheData[key];
				
				if (!value) {
					result = [_targetView sizeThatFits:size];
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
			result = [_targetView sizeThatFits:size];
		}
		
		result.width	= MAX(_minSize.width,  result.width);
		result.height	= MAX(_minSize.height, result.height);
		if (_maxSize.width>0  && _maxSize.width>=_minSize.width)   result.width  = MIN(_maxSize.width,  result.width);
		if (_maxSize.height>0 && _maxSize.height>=_minSize.height) result.height = MIN(_maxSize.height, result.height);
	}
	
	return result;
}

- (void) layoutSubviews {
	if (self.hidden || _targetView.hidden) return;
	if (self.bounds.size.width<1 || self.bounds.size.height<1) return;
	
	CGRect containerFrame	= UIEdgeInsetsInsetRect(self.bounds, _edgeInsets);
	CGSize contentSize		= _contentHorizontalAlignment!=UIControlContentHorizontalAlignmentFill || _contentVerticalAlignment!=UIControlContentVerticalAlignmentFill ? [self targetSizeThatFits:containerFrame.size] : CGSizeZero;
	
	switch (_contentHorizontalAlignment) {
		case UIControlContentHorizontalAlignmentLeft:
			if (_allowContentHorizontalGrowing) {
				_targetFrame.size.width	= MAX(containerFrame.size.width, contentSize.width);
			}
			else if (_allowContentHorizontalShrinking) {
				_targetFrame.size.width	= MIN(containerFrame.size.width, contentSize.width);
			}
			else {
				_targetFrame.size.width	= contentSize.width;
			}
			
			_targetFrame.origin.x = containerFrame.origin.x;
			break;
			
		case UIControlContentHorizontalAlignmentRight:
			if (_allowContentHorizontalGrowing) {
				_targetFrame.size.width	= MAX(containerFrame.size.width, contentSize.width);
			}
			else if (_allowContentHorizontalShrinking) {
				_targetFrame.size.width	= MIN(containerFrame.size.width, contentSize.width);
			}
			else {
				_targetFrame.size.width	= contentSize.width;
			}
			
			_targetFrame.origin.x = containerFrame.origin.x + (containerFrame.size.width - contentSize.width);
			break;
			
		case UIControlContentHorizontalAlignmentCenter:
			if (_allowContentHorizontalGrowing) {
				_targetFrame.size.width	= MAX(containerFrame.size.width, contentSize.width);
			}
			else if (_allowContentHorizontalShrinking) {
				_targetFrame.size.width	= MIN(containerFrame.size.width, contentSize.width);
			}
			else {
				_targetFrame.size.width	= contentSize.width;
			}
			
			_targetFrame.origin.x = containerFrame.origin.x + roundf(containerFrame.size.width/2 - contentSize.width/2);
			break;
			
		case UIControlContentHorizontalAlignmentFill:
			_targetFrame.origin.x	= containerFrame.origin.x;
			_targetFrame.size.width	= containerFrame.size.width;
#if DEBUG
			if (_fixSize.width>0) {
				NSLog(@"[NKFrameLayout] fixedSize.width is ignored for %@", self);
			}
			else {
				if (_minSize.width>0) {
					NSLog(@"[NKFrameLayout] minSize.width is ignored for %@", self);
				}
				if (_maxSize.width>0) {
					NSLog(@"[NKFrameLayout] maxSize.width is ignored for %@", self);
				}
			}
#endif
			break;
			
		case UIControlContentHorizontalAlignmentFit:
			_targetFrame.size.width	= MIN(containerFrame.size.width, contentSize.width);
			_targetFrame.origin.x	= containerFrame.origin.x + roundf(containerFrame.size.width/2 - _targetFrame.size.width/2);
			break;
			
		default:
			break;
	}
	
	switch (_contentVerticalAlignment) {
		case UIControlContentVerticalAlignmentTop:
			if (_allowContentVerticalGrowing) {
				_targetFrame.size.height = MAX(containerFrame.size.height, contentSize.height);
			}
			else if (_allowContentVerticalShrinking) {
				_targetFrame.size.height = MIN(containerFrame.size.height, contentSize.height);
			}
			else {
				_targetFrame.size.height = contentSize.height;
			}
			
			_targetFrame.origin.y = containerFrame.origin.y;
			break;
			
		case UIControlContentVerticalAlignmentBottom:
			if (_allowContentVerticalGrowing) {
				_targetFrame.size.height = MAX(containerFrame.size.height, contentSize.height);
			}
			else if (_allowContentVerticalShrinking) {
				_targetFrame.size.height = MIN(containerFrame.size.height, contentSize.height);
			}
			else {
				_targetFrame.size.height = contentSize.height;
			}
			
			_targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - contentSize.height);
			break;
			
		case UIControlContentVerticalAlignmentCenter:
			if (_allowContentVerticalGrowing) {
				_targetFrame.size.height = MAX(containerFrame.size.height, contentSize.height);
			}
			else if (_allowContentVerticalShrinking) {
				_targetFrame.size.height = MIN(containerFrame.size.height, contentSize.height);
			}
			else {
				_targetFrame.size.height = contentSize.height;
			}
			_targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - contentSize.height)/2;
			break;
			
		case UIControlContentVerticalAlignmentFill:
			_targetFrame.origin.y	= containerFrame.origin.y;
			_targetFrame.size.height = containerFrame.size.height;
#if DEBUG
			if (_fixSize.height>0) {
				NSLog(@"[NKFrameLayout] fixedSize.height is ignored for %@", self);
			}
			else {
				if (_minSize.height>0) {
					NSLog(@"[NKFrameLayout] minSize.height is ignored for %@", self);
				}
				if (_maxSize.height>0) {
					NSLog(@"[NKFrameLayout] maxSize.height is ignored for %@", self);
				}
			}
#endif
			break;
			
		case UIControlContentVerticalAlignmentFit:
			if (_allowContentVerticalGrowing) {
				_targetFrame.size.height = MAX(containerFrame.size.height, contentSize.height);
			}
			else if (_allowContentVerticalShrinking) {
				_targetFrame.size.height = MIN(containerFrame.size.height, contentSize.height);
			}
			else {
				_targetFrame.size.height = contentSize.height;
			}
			_targetFrame.origin.y = containerFrame.origin.y + (containerFrame.size.height - _targetFrame.size.height)/2;
			break;
			
		default:
			break;
	}
	
	_targetFrame = CGRectIntegral(_targetFrame);
	
	if (_targetView.superview == self) {
		_targetView.frame = _targetFrame;
	}
	else if (_targetView.superview) {
		if (self.window == nil) {
			_targetFrame.origin.x = self.frame.origin.x;
			_targetFrame.origin.y = self.frame.origin.y;
			
			UIView *superView = self.superview;
			while (superView != nil && [superView isKindOfClass:[NKFrameLayout class]]) {
				_targetFrame.origin.x += superView.frame.origin.x;
				_targetFrame.origin.y += superView.frame.origin.y;
				superView = superView.superview;
			}
			
			_targetView.frame = _targetFrame;
		}
		else {
			_targetView.frame = [self convertRect:_targetFrame toView:_targetView.superview];
		}
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
	debugBound = UIEdgeInsetsInsetRect(debugBound, _edgeInsets);
#endif
	
	BOOL enableDrawing = YES;
#if ONLY_DRAW_FRAME_WITH_VISIBLE_CONTENT
	enableDrawing = _targetView!=nil && !_targetView.hidden;
#else
	enableDrawing = YES;//_tag>-1;
#endif
	
	if (enableDrawing) {
		CGContextSaveGState(context);
		CGFloat dashes[] = {4.0, 2.0};
		CGContextSetStrokeColorWithColor(context, [_debugColor CGColor]);
		CGContextSetLineDash(context, 0, dashes, 2);
		CGContextStrokeRect(context, debugBound);
		CGContextRestoreGState(context);
		
		if (self.tag>-1) {
			CGContextSetFillColorWithColor(context, [_debugColor CGColor]);
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
	
	if (self.superview == nil) {
		[self layoutIfNeeded];
	}
}

- (void) setBounds:(CGRect)rect {
	if (isnan(rect.origin.x) || isnan(rect.origin.y) || isnan(rect.size.width) || isnan(rect.size.height)) return;
	if (isinf(rect.origin.x) || isinf(rect.origin.y) || isinf(rect.size.width) || isinf(rect.size.height)) return;
	
	[super setBounds:rect];
	
	[self setNeedsLayout];
#if FRAME_DEBUG
	[self setNeedsDisplay];
#endif
	
	if (self.superview == nil) {
		[self layoutIfNeeded];
	}
}

- (void) setFixSize:(CGSize)size {
	_fixSize = size;
	_minSize = _maxSize = size;
}

- (void) setSettingBlock:(void (^)(NKFrameLayout *))settingBlock {
	if (settingBlock) settingBlock(self);
}

- (void) setContentAlignment:(NSString *)value {
	if ([value length]==2) {
		NSString *vValue = [[value substringToIndex:1]	 lowercaseString]; // t=top c=center b=bottom f=fill z=fit
		NSString *hValue = [[value substringFromIndex:1] lowercaseString]; // l=left c=center r=right f=fill z=fit
		
		if ([vValue isEqualToString:@"t"]) {
			_contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
		}
		else if ([vValue isEqualToString:@"c"]) {
			_contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		}
		else if ([vValue isEqualToString:@"b"]) {
			_contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
		}
		else if ([vValue isEqualToString:@"f"]) {
			_contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
		}
		else if ([vValue isEqualToString:@"z"]) {
			_contentVerticalAlignment = UIControlContentVerticalAlignmentFit;
		}
		
		if ([hValue isEqualToString:@"l"]) {
			_contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
		}
		else if ([hValue isEqualToString:@"c"]) {
			_contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
		}
		else if ([hValue isEqualToString:@"r"]) {
			_contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
		}
		else if ([hValue isEqualToString:@"f"]) {
			_contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
		}
		else if ([hValue isEqualToString:@"z"]) {
			_contentHorizontalAlignment = UIControlContentHorizontalAlignmentFit;
		}
	}
}

- (void) setShowFrameDebug:(BOOL)value {
	if (_showFrameDebug != value) {
		_showFrameDebug = value;
		
		if (_showFrameDebug) [self setNeedsDisplay];
	}
}

- (void) setNeedsLayout {
	[super setNeedsLayout];
	[self.targetView setNeedsLayout];
}


#pragma mark -

- (void) dealloc {
	_debugColor = nil;
	_targetView = nil;
}

@end
