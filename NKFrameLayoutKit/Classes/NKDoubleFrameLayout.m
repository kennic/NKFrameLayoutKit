//
//  NKDoubleFrameLayout.m
//  NKFrameLayoutKit
//
//  Created by Nam Kennic on 3/6/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

#import "NKDoubleFrameLayout.h"

@implementation NKDoubleFrameLayout
@synthesize frameLayout1, frameLayout2;

#pragma mark - Initialization

- (instancetype) init {
	if ((self = [super init])) {
		[self setupFrameLayouts];
	}
	
	return self;
}

- (instancetype) initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self setupFrameLayouts];
	}
	
	return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self setupFrameLayouts];
	}
	
	return self;
}

- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction {
	if ((self = [self init])) {
		_layoutDirection = direction;
	}
	
	return self;
}

- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction andViews:(NSArray<UIView*>*)viewArray {
	if ((self = [self initWithDirection:direction])) {
		NSInteger count = [viewArray count];
		if (count>0) {
			UIView *targetView = viewArray[0];
			
			if ([targetView isKindOfClass:[NKFrameLayout class]] && targetView.superview==nil) {
				self.frameLayout1 = (NKFrameLayout*)targetView;
			}
			else {
				self.frameLayout1.targetView = targetView;
			}
			
			if (count>1) {
				targetView = viewArray[1];
				if ([targetView isKindOfClass:[NKFrameLayout class]] && targetView.superview==nil) {
					self.frameLayout2 = (NKFrameLayout*)targetView;
				}
				else {
					self.frameLayout2.targetView = targetView;
				}
			}
		}
	}
	
	return self;
}


#pragma mark -

- (void) setupFrameLayouts {
	self.intrinsicSizeEnabled	= NO;
	_alwaysFitToIntrinsicSize	= NO;
	_splitPercent				= 0.5;
	_spacing					= 0.0;
	_layoutDirection			= NKFrameLayoutDirectionAuto;
	_layoutAlignment			= NKFrameLayoutAlignmentLeft; // this is equal to NKFrameLayoutAlignmentTop in Vertical mode
	
	if (!frameLayout1) {
		frameLayout1 = [[NKFrameLayout alloc] init];
		[self addSubview:frameLayout1];
	}
	
	if (!frameLayout2) {
		frameLayout2 = [[NKFrameLayout alloc] init];
		[self addSubview:frameLayout2];
	}
}


#pragma mark - Public Methods

- (CGSize) sizeThatFits:(CGSize)size {
	CGSize result;
	
	if (CGSizeEqualToSize(self.minSize, self.maxSize) && (self.minSize.width>0 && self.minSize.height>0)) {
		// don't do calculating size if user set fixed size, to improve performance
		result = self.minSize;
	}
	else {
		CGRect containerFrame = CGRectMake(0, 0, size.width, size.height);
		containerFrame = UIEdgeInsetsInsetRect(containerFrame, self.edgeInsets);
		
		CGSize frame1ContentSize, frame2ContentSize;
		CGFloat space;
		NKFrameLayoutDirection direction = _layoutDirection;
		if (direction==NKFrameLayoutDirectionAuto) direction = size.width<size.height ? NKFrameLayoutDirectionVertical : NKFrameLayoutDirectionHorizontal;
		
		if (direction==NKFrameLayoutDirectionHorizontal) {
			switch (_layoutAlignment) {
				case NKFrameLayoutAlignmentLeft:
					frame1ContentSize	= [self.frameLayout1 sizeThatFits:containerFrame.size];
					
					space = (frame1ContentSize.width>0 ? _spacing : 0);
					
					frame2ContentSize	= CGSizeMake(containerFrame.size.width - frame1ContentSize.width - space, containerFrame.size.height);
					frame2ContentSize	= [self.frameLayout2 sizeThatFits:frame2ContentSize];
					break;
					
				case NKFrameLayoutAlignmentRight:
					frame2ContentSize	= [self.frameLayout2 sizeThatFits:containerFrame.size];
					
					space = (frame2ContentSize.width>0 ? _spacing : 0);
					
					frame1ContentSize	= CGSizeMake(containerFrame.size.width - frame2ContentSize.width - space, containerFrame.size.height);
					frame1ContentSize	= [self.frameLayout1 sizeThatFits:frame1ContentSize];
					break;
					
				case NKFrameLayoutAlignmentSplit:
				{
					CGFloat splitValue = _splitPercent;
					CGFloat spaceValue = _spacing;
					
					if (self.frameLayout1.hidden || self.frameLayout1.targetView.hidden || !self.frameLayout1.targetView) {
						splitValue = 0.0;
						spaceValue = 0.0;
					}
					
					if (self.frameLayout2.hidden || self.frameLayout2.targetView.hidden || !self.frameLayout2.targetView) {
						splitValue = 1.0;
						spaceValue = 0.0;
					}
					
					frame1ContentSize	= CGSizeMake((containerFrame.size.width - spaceValue) * splitValue, containerFrame.size.height);
					frame1ContentSize	= [self.frameLayout1 sizeThatFits:frame1ContentSize];
					
					space = (frame1ContentSize.width>0 ? spaceValue : 0);
					
					frame2ContentSize	= CGSizeMake(containerFrame.size.width - frame1ContentSize.width - space, containerFrame.size.height);
					frame2ContentSize	= [self.frameLayout2 sizeThatFits:frame2ContentSize];
					break;
				}
					
				case NKFrameLayoutAlignmentCenter:
					frame1ContentSize	= [self.frameLayout1 sizeThatFits:containerFrame.size];
					
					space = (frame1ContentSize.width>0 ? _spacing : 0);
					
					frame2ContentSize	= CGSizeMake(containerFrame.size.width - frame1ContentSize.width - space, containerFrame.size.height);
					frame2ContentSize	= [self.frameLayout2 sizeThatFits:frame2ContentSize];
					break;
			}
			
			if (self.intrinsicSizeEnabled) {
				space = (frame1ContentSize.width>0 && frame2ContentSize.width>0 ? _spacing : 0);
				result.width = roundf(frame1ContentSize.width + frame2ContentSize.width + space);
			}
			else {
				result.width = size.width;
			}
			
			result.height = MAX(frame1ContentSize.height, frame2ContentSize.height);
		}
		else if (direction==NKFrameLayoutDirectionVertical) {
			switch (_layoutAlignment) {
				case NKFrameLayoutAlignmentTop:
					frame1ContentSize	= [self.frameLayout1 sizeThatFits:containerFrame.size];
					space = (frame1ContentSize.height>0 ? _spacing : 0);
					
					frame2ContentSize	= CGSizeMake(containerFrame.size.width, containerFrame.size.height - frame1ContentSize.height - space);
					frame2ContentSize	= [self.frameLayout2 sizeThatFits:frame2ContentSize];
					break;
					
				case NKFrameLayoutAlignmentBottom:
					frame2ContentSize	= [self.frameLayout2 sizeThatFits:containerFrame.size];
					space = (frame2ContentSize.height>0 ? _spacing : 0);
					
					frame1ContentSize	= CGSizeMake(containerFrame.size.width, containerFrame.size.height - frame2ContentSize.height - space);
					frame1ContentSize	= [self.frameLayout1 sizeThatFits:frame1ContentSize];
					break;
					
				case NKFrameLayoutAlignmentSplit:
				{
					CGFloat splitValue = _splitPercent;
					CGFloat spaceValue = _spacing;
					
					if (self.frameLayout1.hidden || self.frameLayout1.targetView.hidden || !self.frameLayout1.targetView) {
						splitValue = 0.0;
						spaceValue = 0.0;
					}
					
					if (self.frameLayout2.hidden || self.frameLayout2.targetView.hidden || !self.frameLayout2.targetView) {
						splitValue = 1.0;
						spaceValue = 0.0;
					}
					
					frame1ContentSize	= CGSizeMake(containerFrame.size.width, (containerFrame.size.height - spaceValue) * splitValue);
					frame1ContentSize	= [self.frameLayout1 sizeThatFits:frame1ContentSize];
					
					space = (frame1ContentSize.height>0 ? spaceValue : 0);
					
					frame2ContentSize	= CGSizeMake(containerFrame.size.width, containerFrame.size.height - frame1ContentSize.height - space);
					frame2ContentSize	= [self.frameLayout2 sizeThatFits:frame2ContentSize];
					break;
				}
					
				case NKFrameLayoutAlignmentCenter:
					frame1ContentSize	= [self.frameLayout1 sizeThatFits:containerFrame.size];
					frame2ContentSize	= [self.frameLayout2 sizeThatFits:containerFrame.size];
					break;
			}
			
			result.width = self.intrinsicSizeEnabled ? MAX(frame1ContentSize.width, frame2ContentSize.width) : size.width;
			space = (frame1ContentSize.height>0 && frame2ContentSize.height>0 ? _spacing : 0);
			result.height = roundf(frame1ContentSize.height + frame2ContentSize.height + space);
		}
		else {
			result = size;
		}
		
		result.width	= MAX(self.minSize.width,  result.width);
		result.height	= MAX(self.minSize.height, result.height);
		if (self.maxSize.width>0  && self.maxSize.width>=self.minSize.width)   result.width  = MIN(self.maxSize.width,  result.width);
		if (self.maxSize.height>0 && self.maxSize.height>=self.minSize.height) result.height = MIN(self.maxSize.height, result.height);
	}
	
	if (result.width>0)  result.width  += self.edgeInsets.left + self.edgeInsets.right;
	if (result.height>0) result.height += self.edgeInsets.top  + self.edgeInsets.bottom;
	result.width  = MIN(result.width,  size.width);
	result.height = MIN(result.height, size.height);
	
	return result;
}


#pragma mark - Private Methods

- (void) layoutSubviews {
	[super layoutSubviews];
	
	CGRect containerFrame = UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets);
	if (containerFrame.size.width<1 || containerFrame.size.height<1) return;
	
	CGSize frame1ContentSize, frame2ContentSize;
	
	CGRect targetFrame1 = containerFrame;
	CGRect targetFrame2 = containerFrame;
	CGFloat space;
	
	NKFrameLayoutDirection direction = _layoutDirection;
	if (direction==NKFrameLayoutDirectionAuto) direction = self.bounds.size.width<self.bounds.size.height ? NKFrameLayoutDirectionVertical : NKFrameLayoutDirectionHorizontal;
	
	if (direction==NKFrameLayoutDirectionHorizontal) {
		switch (_layoutAlignment) {
			case NKFrameLayoutAlignmentLeft:
				frame1ContentSize			= [self.frameLayout1 sizeThatFits:containerFrame.size];
				targetFrame1.origin.x		= containerFrame.origin.x;
				targetFrame1.size.width		= frame1ContentSize.width;
				
				space = (frame1ContentSize.width>0 ? _spacing : 0);
				
				frame2ContentSize			= CGSizeMake(containerFrame.size.width - frame1ContentSize.width - space, containerFrame.size.height);
				if (_alwaysFitToIntrinsicSize) {
					frame2ContentSize		 = [self.frameLayout2 sizeThatFits:frame2ContentSize];
					targetFrame2.size.height = frame2ContentSize.height;
					targetFrame1.size.height = frame1ContentSize.height;
				}
				
				targetFrame2.origin.x		= containerFrame.origin.x + frame1ContentSize.width + space;
				targetFrame2.size.width		= frame2ContentSize.width;
				break;
				
			case NKFrameLayoutAlignmentRight:
				frame2ContentSize			= [self.frameLayout2 sizeThatFits:containerFrame.size];
				targetFrame2.origin.x		= containerFrame.origin.x + (containerFrame.size.width - frame2ContentSize.width);
				targetFrame2.size.width		= frame2ContentSize.width;
				
				space = (frame2ContentSize.width>0 ? _spacing : 0);
				
				frame1ContentSize			= CGSizeMake(containerFrame.size.width - frame2ContentSize.width - space, containerFrame.size.height);
				
				if (_alwaysFitToIntrinsicSize) {
					frame1ContentSize		 = [self.frameLayout1 sizeThatFits:frame1ContentSize];
					targetFrame1.origin.x	 = (targetFrame2.origin.x - frame1ContentSize.width - space);
					targetFrame1.size.height = frame1ContentSize.height;
					targetFrame2.size.height = frame2ContentSize.height;
				}
				else {
					targetFrame1.origin.x	= containerFrame.origin.x;
				}
				
				targetFrame1.size.width		= frame1ContentSize.width;
				break;
				
			case NKFrameLayoutAlignmentSplit:
			{
				CGFloat splitValue = _splitPercent;
				CGFloat spaceValue = _spacing;
				
				if (self.frameLayout1.hidden || self.frameLayout1.targetView.hidden || !self.frameLayout1.targetView) {
					splitValue = 0.0;
					spaceValue = 0.0;
				}
				
				if (self.frameLayout2.hidden || self.frameLayout2.targetView.hidden || !self.frameLayout2.targetView) {
					splitValue = 1.0;
					spaceValue = 0.0;
				}
				
				frame1ContentSize			= CGSizeMake((containerFrame.size.width - spaceValue) * splitValue, containerFrame.size.height);
				if (_alwaysFitToIntrinsicSize) frame1ContentSize = [self.frameLayout1 sizeThatFits:frame1ContentSize];
				targetFrame1.origin.x		= containerFrame.origin.x;
				targetFrame1.size.width		= frame1ContentSize.width;
				
				space = (frame1ContentSize.width>0 ? spaceValue : 0);
				
				frame2ContentSize			= CGSizeMake(containerFrame.size.width - frame1ContentSize.width - space, containerFrame.size.height);
				if (_alwaysFitToIntrinsicSize) {
					frame2ContentSize		 = [self.frameLayout2 sizeThatFits:frame2ContentSize];
					targetFrame2.size.height = frame2ContentSize.height;
					targetFrame1.size.height = frame1ContentSize.height;
				}
				
				targetFrame2.origin.x		= containerFrame.origin.x + frame1ContentSize.width + space;
				targetFrame2.size.width		= frame2ContentSize.width;
				break;
			}
				
			case NKFrameLayoutAlignmentCenter:
				frame1ContentSize			= [self.frameLayout1 sizeThatFits:containerFrame.size];
				space = (frame1ContentSize.width>0 ? _spacing : 0);
				frame2ContentSize			= CGSizeMake(containerFrame.size.width - frame1ContentSize.width - space, containerFrame.size.height);
				frame2ContentSize			= [self.frameLayout2 sizeThatFits:frame2ContentSize];
				
				CGFloat totalWidth			= frame1ContentSize.width + frame2ContentSize.width + space;
				
				targetFrame1.origin.x		= containerFrame.origin.x + roundf(containerFrame.size.width/2 - totalWidth/2);
				targetFrame1.size.width		= frame1ContentSize.width;
				
				targetFrame2.origin.x		= targetFrame1.origin.x + frame1ContentSize.width + space;
				targetFrame2.size.width		= frame2ContentSize.width;
				
				if (_alwaysFitToIntrinsicSize) {
					targetFrame2.size.height = frame2ContentSize.height;
					targetFrame1.size.height = frame1ContentSize.height;
				}
				break;
		}
	}
	else if (direction==NKFrameLayoutDirectionVertical) {
		switch (_layoutAlignment) {
			case NKFrameLayoutAlignmentTop:
				frame1ContentSize			= [self.frameLayout1 sizeThatFits:containerFrame.size];
				targetFrame1.origin.y		= containerFrame.origin.y;
				targetFrame1.size.height	= frame1ContentSize.height;
				
				space = (frame1ContentSize.height>0 ? _spacing : 0);
				
				frame2ContentSize			= CGSizeMake(containerFrame.size.width, containerFrame.size.height - frame1ContentSize.height - space);
				if (_alwaysFitToIntrinsicSize) {
					frame2ContentSize		= [self.frameLayout2 sizeThatFits:frame2ContentSize];
					targetFrame2.size.width = frame2ContentSize.width;
					targetFrame1.size.width = frame1ContentSize.width;
				}
				
				targetFrame2.origin.y		= containerFrame.origin.y + frame1ContentSize.height + space;
				targetFrame2.size.height	= frame2ContentSize.height;
				break;
				
			case NKFrameLayoutAlignmentBottom:
				frame2ContentSize			= [self.frameLayout2 sizeThatFits:containerFrame.size];
				targetFrame2.origin.y		= containerFrame.origin.y + (containerFrame.size.height - frame2ContentSize.height);
				targetFrame2.size.height	= frame2ContentSize.height;
				
				space = (frame2ContentSize.height>0 ? _spacing : 0);
				
				frame1ContentSize			= CGSizeMake(containerFrame.size.width, containerFrame.size.height - frame2ContentSize.height - space);
				targetFrame1.origin.y		= containerFrame.origin.y;
				if (_alwaysFitToIntrinsicSize) {
					frame1ContentSize		= [self.frameLayout1 sizeThatFits:frame1ContentSize];
                    targetFrame1.origin.y	+= (containerFrame.size.height - frame2ContentSize.height - space - frame1ContentSize.height);
					targetFrame2.size.width = frame2ContentSize.width;
					targetFrame1.size.width = frame1ContentSize.width;
				}
				
				targetFrame1.size.height	= frame1ContentSize.height;
				break;
				
			case NKFrameLayoutAlignmentSplit:
			{
				CGFloat splitValue = _splitPercent;
				CGFloat spaceValue = _spacing;
				
				if (self.frameLayout1.hidden || self.frameLayout1.targetView.hidden || !self.frameLayout1.targetView) {
					splitValue = 0.0;
					spaceValue = 0.0;
				}
				
				if (self.frameLayout2.hidden || self.frameLayout2.targetView.hidden || !self.frameLayout2.targetView) {
					splitValue = 1.0;
					spaceValue = 0.0;
				}
				
				frame1ContentSize			= CGSizeMake(containerFrame.size.width, (containerFrame.size.height - spaceValue) * splitValue);
				if (_alwaysFitToIntrinsicSize) {
					frame1ContentSize		= [self.frameLayout1 sizeThatFits:frame1ContentSize];
					targetFrame1.size.width = frame1ContentSize.width;
				}
				
				targetFrame1.origin.y		= containerFrame.origin.y;
				targetFrame1.size.height	= frame1ContentSize.height;
				
				space = (frame1ContentSize.height>0 ? spaceValue : 0);
				
				frame2ContentSize			= CGSizeMake(containerFrame.size.width, containerFrame.size.height - frame1ContentSize.height - space);
				if (_alwaysFitToIntrinsicSize) {
					frame2ContentSize		= [self.frameLayout2 sizeThatFits:frame2ContentSize];
					targetFrame2.size.width = frame2ContentSize.width;
					
				}
				
				targetFrame2.origin.y		= containerFrame.origin.y + targetFrame1.size.height + space;
				targetFrame2.size.height	= frame2ContentSize.height;
				break;
			}
				
			case NKFrameLayoutAlignmentCenter:
				frame1ContentSize			= [self.frameLayout1 sizeThatFits:containerFrame.size];
				space = (frame1ContentSize.height>0 ? _spacing : 0);
				frame2ContentSize			= CGSizeMake(containerFrame.size.width, containerFrame.size.height - frame1ContentSize.height - space);
				frame2ContentSize			= [self.frameLayout2 sizeThatFits:frame2ContentSize];
				
				CGFloat totalHeight			= frame1ContentSize.height + frame2ContentSize.height + space;
				
				targetFrame1.origin.y		= containerFrame.origin.y + roundf(containerFrame.size.height/2 - totalHeight/2);
				targetFrame1.size.height	= frame1ContentSize.height;
				
				targetFrame2.origin.y		= targetFrame1.origin.y + frame1ContentSize.height + space;
				targetFrame2.size.height	= frame2ContentSize.height;
				
				if (_alwaysFitToIntrinsicSize) {
					targetFrame2.size.width = frame2ContentSize.width;
					targetFrame1.size.width = frame1ContentSize.width;
				}
				break;
		}
	}
	
	self.frameLayout1.frame	= CGRectIntegral(targetFrame1);
	self.frameLayout2.frame	= CGRectIntegral(targetFrame2);
}


#pragma mark - HorizontalLayout

- (NKFrameLayout*) leftFrameLayout {
	return self.frameLayout1;
}

- (NKFrameLayout*) rightFrameLayout {
	return self.frameLayout2;
}

- (void) setLeftFrameLayout:(NKFrameLayout*)frameLayout {
	[self setFrameLayout1:frameLayout];
}

- (void) setRightFrameLayout:(NKFrameLayout*)frameLayout {
	[self setFrameLayout2:frameLayout];
}


#pragma mark - VerticalLayout

- (NKFrameLayout*) topFrameLayout {
	return self.frameLayout1;
}

- (NKFrameLayout*) bottomFrameLayout {
	return self.frameLayout2;
}

- (void) setTopFrameLayout:(NKFrameLayout*)frameLayout {
	[self setFrameLayout1:frameLayout];
}

- (void) setBottomFrameLayout:(NKFrameLayout*)frameLayout {
	[self setFrameLayout2:frameLayout];
}


#pragma mark - Properties

- (void) setFrameLayout1:(NKFrameLayout *)frameLayout {
	if (frameLayout1!=frameLayout) {
		if (frameLayout1) {
			if (frameLayout1.superview==self) [frameLayout1 removeFromSuperview];
			frameLayout1 = nil;
		}
		
		if (frameLayout && frameLayout!=self) {
			frameLayout1 = frameLayout;
			[self addSubview:frameLayout1];
		}
		else {
			frameLayout1 = nil;
		}
	}
}

- (void) setFrameLayout2:(NKFrameLayout *)frameLayout {
	if (frameLayout2!=frameLayout) {
		if (frameLayout2) {
			if (frameLayout2.superview==self) [frameLayout2 removeFromSuperview];
			frameLayout2 = nil;
		}
		
		if (frameLayout && frameLayout!=self) {
			frameLayout2 = frameLayout;
			[self addSubview:frameLayout2];
		}
		else {
			frameLayout2 = nil;
		}
	}
}

- (void) setFrame:(CGRect)rect {
	[super setFrame:rect];
	[self setNeedsLayout];
}

- (void) setBounds:(CGRect)rect {
	[super setBounds:rect];
	[self setNeedsLayout];
}

- (void) setShouldCacheSize:(BOOL)value {
	self.frameLayout1.shouldCacheSize = value;
	self.frameLayout2.shouldCacheSize = value;
}

- (BOOL) shouldCacheSize {
	return self.frameLayout1.shouldCacheSize && self.frameLayout2.shouldCacheSize;
}

- (void) setSpacing:(CGFloat)value {
	if (_spacing != value) {
		_spacing = value;
		[self setNeedsLayout];
	}
}

- (void) setShowFrameDebug:(BOOL)value {
	[super setShowFrameDebug:value];
	
	self.frameLayout1.showFrameDebug = value;
	self.frameLayout2.showFrameDebug = value;
}

- (void) setIgnoreHiddenView:(BOOL)value {
	[super setIgnoreHiddenView:value];
	
	self.frameLayout1.ignoreHiddenView = value;
	self.frameLayout2.ignoreHiddenView = value;
}


#pragma mark -

- (void) setAllowContentHorizontalGrowing:(BOOL)value {
	self.frameLayout1.allowContentHorizontalGrowing = value;
	self.frameLayout2.allowContentHorizontalGrowing = value;
}

- (void) setAllowContentVerticalGrowing:(BOOL)value {
	self.frameLayout1.allowContentVerticalGrowing = value;
	self.frameLayout2.allowContentVerticalGrowing = value;
}

- (void) setAllowContentHorizontalShrinking:(BOOL)value {
	self.frameLayout1.allowContentHorizontalShrinking = value;
	self.frameLayout2.allowContentHorizontalShrinking = value;
}

- (void) setAllowContentVerticalShrinking:(BOOL)value {
	self.frameLayout1.allowContentVerticalShrinking = value;
	self.frameLayout2.allowContentVerticalShrinking = value;
}


#pragma mark -

- (void) dealloc {
	self.frameLayout1.targetView = nil;
	self.frameLayout1 = nil;
	
	self.frameLayout2.targetView = nil;
	self.frameLayout2 = nil;
}

@end
