//
//  NKGridFrameLayout.m
//  NKFrameLayoutKit
//
//  Created by Nam Kennic on 3/8/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

#import "NKGridFrameLayout.h"

@implementation NKGridFrameLayout


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
		self.layoutDirection = direction;
	}
	
	return self;
}

- (instancetype) initWithDirection:(NKFrameLayoutDirection)direction andViews:(NSArray<UIView*>*)viewArray {
	if ((self = [self initWithDirection:direction])) {
		for (UIView *view in viewArray) {
			if ([view isKindOfClass:[NKFrameLayout class]] && view.superview==nil) {
				[self addFrameLayout:(NKFrameLayout*)view];
			}
			else {
				[self addFrameLayoutWithTargetView:view];
			}
		}
	}
	
	return self;
}


#pragma mark -

- (void) setupFrameLayouts {
	self.spacing				= 0;
	self.intrinsicSizeEnabled	= YES;
	self.autoRemoveTargetView	= NO;
	self.roundUpValue			= NO;
	self.layoutDirection		= NKFrameLayoutDirectionAuto;
	self.layoutAlignment		= NKFrameLayoutAlignmentTop;
	self.frameArray				= [NSMutableArray array];
}


#pragma mark - Public Methods

- (NKFrameLayout*) addFrameLayout {
	NKFrameLayout *frameLayout = [[NKFrameLayout alloc] init];
	frameLayout.showFrameDebug = self.showFrameDebug;
	[_frameArray addObject:frameLayout];
	[self addSubview:frameLayout];
	return frameLayout;
}

- (NKFrameLayout*) addFrameLayoutWithTargetView:(UIView*)view {
	if (view) {
		NKFrameLayout *frameLayout = [self addFrameLayout];
		frameLayout.targetView = view;
		return frameLayout;
	}
	else {
		return nil;
	}
}

- (NKFrameLayout*) andEmptySpaceWithSize:(CGSize)size {
	NKFrameLayout *frameLayout = [self addFrameLayout];
	frameLayout.fixSize = size;
	return frameLayout;
}

- (NKFrameLayout*) insertFrameLayoutAtIndex:(NSUInteger)index {
	NKFrameLayout *frameLayout = [[NKFrameLayout alloc] init];
	[_frameArray insertObject:frameLayout atIndex:index];
	[self addSubview:frameLayout];
	return frameLayout;
}

- (NKFrameLayout*) addFrameLayout:(NKFrameLayout*)frameLayout {
	if (frameLayout) {
		if (![_frameArray containsObject:frameLayout]) [_frameArray addObject:frameLayout];
		[self addSubview:frameLayout];
		return frameLayout;
	}
	else {
		return nil;
	}
}

- (NKFrameLayout*) insertFrameLayout:(NKFrameLayout*)frameLayout atIndex:(NSUInteger)index {
	if (frameLayout) {
		[_frameArray insertObject:frameLayout atIndex:index];
		[self addSubview:frameLayout];
		return frameLayout;
	}
	else {
		return nil;
	}
}

- (void) removeFrameAtIndex:(NSUInteger)index {
	if (index<[_frameArray count]) {
		NKFrameLayout *frameLayout = [_frameArray objectAtIndex:index];
		if (frameLayout.superview==self) [frameLayout removeFromSuperview];
		if (self.autoRemoveTargetView) [frameLayout.targetView removeFromSuperview];
		frameLayout.targetView = nil;
		[_frameArray removeObjectAtIndex:index];
	}
}

- (void) removeAllFrameLayout {
	for (NKFrameLayout *frameLayout in _frameArray) {
		if (self.autoRemoveTargetView) [frameLayout.targetView removeFromSuperview];
		frameLayout.targetView = nil;
		if (frameLayout.superview==self) [frameLayout removeFromSuperview];
	}
	
	[_frameArray removeAllObjects];
}

- (NKFrameLayout*) frameLayoutAtIndex:(NSInteger)index {
	return index>=0 && index<[_frameArray count] ? _frameArray[index] : nil;
}

- (NKFrameLayout*) frameLayoutWithTag:(NSInteger)tag {
	NKFrameLayout *result = nil;
	
	for (NKFrameLayout *frameLayout in _frameArray) {
		if (frameLayout.tag==tag) {
			result = frameLayout;
			break;
		}
	}
	
	return result;
}

- (NKFrameLayout*) frameLayoutWithView:(UIView*)view {
	NKFrameLayout *result = nil;
	
	for (NKFrameLayout *frameLayout in _frameArray) {
		if (frameLayout.targetView==view) {
			result = frameLayout;
			break;
		}
	}
	
	return result;
}

- (NKFrameLayout*) firstFrameLayout {
	return [self frameLayoutAtIndex:0];
}

- (NKFrameLayout*) lastFrameLayout {
	return [self frameLayoutAtIndex:[_frameArray count] - 1];
}

- (void) setClipsToBounds:(BOOL)value {
	[super setClipsToBounds:value];
	
	for (NKFrameLayout *frameLayout in _frameArray) {
		frameLayout.clipsToBounds = value;
	}
}

- (void) setShowFrameDebug:(BOOL)value {
	[super setShowFrameDebug:value];
	
	for (NKFrameLayout *frameLayout in _frameArray) {
		frameLayout.showFrameDebug = value;
	}
}

- (void) setSpacing:(CGFloat)value {
	BOOL changed = _spacing != value;
	_spacing = value;
	if (changed) [self setNeedsLayout];
}

#pragma mark - Enumerating

- (void) enumerateFrameLayoutUsingBlock:(void (NS_NOESCAPE ^)(NKFrameLayout *frameLayout, NSUInteger idx, BOOL *stop))block {
	if (block) {
		BOOL stop = NO;
		NSInteger index = 0;
		
		for (NKFrameLayout *frameLayout in _frameArray) {
			block(frameLayout, index, &stop);
			if (stop) break;
			index++;
		}
	}
}

#pragma mark -

- (void) setNumberOfFrames:(NSInteger)number {
	NSInteger count = [_frameArray count];
	
	if (number==0) {
		[self removeAllFrameLayout];
		return;
	}
	
	if (number<count) {
		while ([_frameArray count]>number) {
			[self removeFrameAtIndex:[_frameArray count]-1];
		}
	}
	else if (number>count) {
		if (!self.frameArray) self.frameArray = [NSMutableArray array];
		
		while ([_frameArray count]<number) {
			[self insertFrameLayoutAtIndex:[_frameArray count]];
		}
	}
}

- (NSInteger) numberOfFrames {
	return [_frameArray count];
}

- (void) setFrameArray:(NSMutableArray *)array {
	if (_frameArray!=array) {
		[self removeAllFrameLayout];
		
		_frameArray = array;
	}
}

- (CGSize) sizeThatFits:(CGSize)size {
	CGSize result = size;
	
	if (CGSizeEqualToSize(self.minSize, self.maxSize) && (self.minSize.width>0 && self.minSize.height>0)) {
		// don't do calculating size if user set fixed size, to improve performance
		result = self.minSize;
	}
	else {
		CGRect containerFrame = UIEdgeInsetsInsetRect(CGRectMake(0, 0, size.width, size.height), self.edgeInsets);
		CGSize frameContentSize;
		CGFloat space;
		CGFloat usedSpace = 0;
		__block NKFrameLayout *lastFrameLayout = [_frameArray lastObject];
		
		if (lastFrameLayout.hidden || lastFrameLayout.targetView.hidden) {
			[_frameArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NKFrameLayout * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
				if (!obj.hidden && !obj.targetView.hidden) {
					lastFrameLayout = obj;
					*stop = YES;
				}
			}];
		}
		
		NKFrameLayoutDirection direction = self.layoutDirection;
		if (direction==NKFrameLayoutDirectionAuto) direction = size.width>size.height ? NKFrameLayoutDirectionVertical : NKFrameLayoutDirectionHorizontal;
		
		if (direction==NKFrameLayoutDirectionHorizontal) {
			CGFloat maxHeight = 0;
			
			switch (self.layoutAlignment) {
				case NKFrameLayoutAlignmentLeft:
				case NKFrameLayoutAlignmentRight:
				{
					for (NKFrameLayout *frameLayout in _frameArray) {
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						frameContentSize = CGSizeMake(containerFrame.size.width - usedSpace, containerFrame.size.height);
						if (frameLayout!=lastFrameLayout || self.intrinsicSizeEnabled) {
							CGSize fitSize = [frameLayout sizeThatFits:frameContentSize];
							if (frameLayout == lastFrameLayout) {
								frameContentSize.height = fitSize.height;
							}
							else {
								frameContentSize = fitSize;
							}
						}
						
						space = (frameContentSize.width>0 && frameLayout!=lastFrameLayout ? self.spacing : 0);
						usedSpace += frameContentSize.width + space;
						maxHeight = MAX(maxHeight, frameContentSize.height);
					}
				}
					break;
					
				case NKFrameLayoutAlignmentSplit:
				case NKFrameLayoutAlignmentCenter:
				{
					frameContentSize = CGSizeMake(containerFrame.size.width/(float)[self numberOfVisibleFrames], containerFrame.size.height);
					for (NKFrameLayout *frameLayout in _frameArray) {
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						frameContentSize = [frameLayout sizeThatFits:frameContentSize];
						
						space = (frameContentSize.width>0 && frameLayout!=lastFrameLayout ? self.spacing : 0);
						usedSpace += frameContentSize.width + space;
						maxHeight = MAX(maxHeight, frameContentSize.height);
					}
				}
					break;
			}
			
			if (self.intrinsicSizeEnabled) result.width = usedSpace;
			result.height = MIN(maxHeight + self.edgeInsets.bottom + self.edgeInsets.top, size.height);
		}
		else if (direction==NKFrameLayoutDirectionVertical) {
			CGFloat maxWidth = 0;
			
			switch (self.layoutAlignment) {
				case NKFrameLayoutAlignmentTop:
				case NKFrameLayoutAlignmentBottom:
				{
					for (NKFrameLayout *frameLayout in _frameArray) {
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						frameContentSize = CGSizeMake(containerFrame.size.width, containerFrame.size.height - usedSpace);
						if (frameLayout!=lastFrameLayout || self.intrinsicSizeEnabled) {
							frameContentSize = [frameLayout sizeThatFits:frameContentSize];
						}
						
						space = (frameContentSize.height>0 && frameLayout!=lastFrameLayout ? self.spacing : 0);
						usedSpace += frameContentSize.height + space;
						maxWidth = MAX(maxWidth, frameContentSize.width);
					}
				}
					break;
					
				case NKFrameLayoutAlignmentSplit:
				case NKFrameLayoutAlignmentCenter:
				{
					frameContentSize = CGSizeMake(containerFrame.size.width, containerFrame.size.height/(float)[self numberOfVisibleFrames]);
					for (NKFrameLayout *frameLayout in _frameArray) {
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						frameContentSize = [frameLayout sizeThatFits:frameContentSize];
						
						space = (frameContentSize.height>0 && frameLayout!=lastFrameLayout ? self.spacing : 0);
						usedSpace += frameContentSize.height + space;
						maxWidth = MAX(maxWidth, frameContentSize.width);
					}
				}
					break;
			}
			
			if (self.intrinsicSizeEnabled) result.width = maxWidth;
			result.height = MIN(usedSpace, size.height);
			//result.height = MIN(usedSpace + self.edgeInsets.top + self.edgeInsets.bottom, size.height);
			
			// Validating
			result.width	= MAX(self.minSize.width,  result.width);
			result.height	= MAX(self.minSize.height, result.height);
			if (self.maxSize.width>0  && self.maxSize.width>=self.minSize.width)   result.width  = MIN(self.maxSize.width,  result.width);
			if (self.maxSize.height>0 && self.maxSize.height>=self.minSize.height) result.height = MIN(self.maxSize.height, result.height);
		}
	}
	
	result.width  = MIN(result.width,  size.width);
	result.height = MIN(result.height, size.height);
	if (result.width>0)  result.width  += self.edgeInsets.left + self.edgeInsets.right;
	if (result.height>0) result.height += self.edgeInsets.top  + self.edgeInsets.bottom;
	return result;
}


#pragma mark - Keyed Subscripting

- (id) objectAtIndexedSubscript:(NSInteger)index {
	return [self frameLayoutAtIndex:index];
}

- (void) setObject:(id)object  atIndexedSubscript:(NSInteger)index {
	_frameArray[index] = object;
}


#pragma mark - Private Methods

- (void) layoutSubviews {
	[super layoutSubviews];
	if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) return;
	
	CGRect containerFrame	= UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets);
	CGSize frameContentSize;
	CGRect targetFrame = containerFrame;
	CGFloat space;
	CGFloat usedSpace = 0.0;
	__block NKFrameLayout *lastFrameLayout = [_frameArray lastObject];
	
	if (lastFrameLayout.hidden || lastFrameLayout.targetView.hidden) {
		[_frameArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NKFrameLayout * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			if (!obj.hidden && !obj.targetView.hidden) {
				lastFrameLayout = obj;
				*stop = YES;
			}
		}];
	}
	
	NKFrameLayoutDirection direction = self.layoutDirection;
	if (direction==NKFrameLayoutDirectionAuto) direction = self.frame.size.width>self.frame.size.height ? NKFrameLayoutDirectionVertical : NKFrameLayoutDirectionHorizontal;
	
	if (direction==NKFrameLayoutDirectionHorizontal) {
		switch (self.layoutAlignment) {
			case NKFrameLayoutAlignmentLeft:
				for (NKFrameLayout *frameLayout in _frameArray) {
					if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
					
					frameContentSize = CGSizeMake(containerFrame.size.width - usedSpace, containerFrame.size.height);
					if (frameLayout!=lastFrameLayout || self.intrinsicSizeEnabled) {
						CGSize fitSize = [frameLayout sizeThatFits:frameContentSize];
						if (!frameLayout.intrinsicSizeEnabled && (frameLayout == lastFrameLayout)) {
							frameContentSize.height = fitSize.height;
						}
						else {
							frameContentSize = fitSize;
						}
					}
					
					targetFrame.origin.x		= containerFrame.origin.x + usedSpace;
					targetFrame.size.width		= frameContentSize.width;
					frameLayout.frame			= targetFrame;
					
					space = (frameContentSize.width>0 ? self.spacing : 0);
					usedSpace += frameContentSize.width + space;
				}
				break;
				
			case NKFrameLayoutAlignmentRight:
			{
				NSArray *invertedFrameArray = [self invertArrayFromArray:_frameArray];
				lastFrameLayout = [invertedFrameArray lastObject];
				
				for (NKFrameLayout *frameLayout in invertedFrameArray) {
					if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
					
					if (!frameLayout.intrinsicSizeEnabled && (frameLayout==lastFrameLayout)) {
						targetFrame.origin.x	= self.edgeInsets.left;
						targetFrame.size.width	= containerFrame.size.width - usedSpace;
					}
					else {
						frameContentSize		= CGSizeMake(containerFrame.size.width - usedSpace, containerFrame.size.height);
						if (frameLayout==lastFrameLayout || self.intrinsicSizeEnabled) {
							frameContentSize	= [frameLayout sizeThatFits:frameContentSize];
						}
						
						targetFrame.origin.x	= MAX(self.bounds.size.width - frameContentSize.width - self.edgeInsets.right - usedSpace, 0);
						targetFrame.size.width	= frameContentSize.width;
					}
					
					frameLayout.frame = targetFrame;
					
					space = (frameContentSize.width>0 ? self.spacing : 0);
					usedSpace += frameContentSize.width + space;
				}
			}
				break;
				
			case NKFrameLayoutAlignmentSplit:
			{
				NSInteger visibleFrames = [self numberOfVisibleFrames];
				CGFloat spaces = (visibleFrames - 1) * self.spacing;
				CGFloat cellSize = (containerFrame.size.width - spaces)/(float)visibleFrames;
				
				for (NKFrameLayout *frameLayout in _frameArray) {
					if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
					
					frameContentSize			= CGSizeMake(cellSize, containerFrame.size.height);
//					if (self.intrinsicSizeEnabled) [frameLayout sizeThatFits:frameContentSize];
					
					targetFrame.origin.x		= containerFrame.origin.x + usedSpace;
					targetFrame.size.width		= frameContentSize.width;
					frameLayout.frame			= targetFrame;
					
					usedSpace += frameContentSize.width + self.spacing;
				}
			}
				break;
				
			case NKFrameLayoutAlignmentCenter:
			{
				NSInteger visibleFrames = [self numberOfVisibleFrames];
				CGFloat spaces = (visibleFrames - 1) * self.spacing;
				CGFloat cellSize = (containerFrame.size.width - spaces)/(float)visibleFrames;
				if (self.roundUpValue) cellSize = roundf(cellSize);
				
				for (NKFrameLayout *frameLayout in _frameArray) {
					if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
					
					frameContentSize			= CGSizeMake(cellSize, containerFrame.size.height);
					targetFrame.origin.x		= containerFrame.origin.x + usedSpace;
					targetFrame.size.width		= frameContentSize.width;
					frameLayout.frame			= targetFrame;
					
					usedSpace += frameContentSize.width + self.spacing;
				}
			}
				break;
		}
	}
	else if (direction==NKFrameLayoutDirectionVertical) {
		switch (self.layoutAlignment) {
			case NKFrameLayoutAlignmentTop:
				for (NKFrameLayout *frameLayout in _frameArray) {
					if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
					
					frameContentSize			= CGSizeMake(containerFrame.size.width, containerFrame.size.height - usedSpace);
					if (frameLayout!=lastFrameLayout || self.intrinsicSizeEnabled) {
						CGSize fitSize = [frameLayout sizeThatFits:frameContentSize];
						if (!frameLayout.intrinsicSizeEnabled && (frameLayout == lastFrameLayout)) {
							frameContentSize.width = fitSize.width;
						}
						else {
							frameContentSize = fitSize;
						}
					}
					
					targetFrame.origin.y	= containerFrame.origin.y + usedSpace;
					targetFrame.size.height	= frameContentSize.height;
					frameLayout.frame		= targetFrame;
					
					space = (frameContentSize.height>0 ? self.spacing : 0);
					usedSpace += frameContentSize.height + space;
				}
				break;
				
			case NKFrameLayoutAlignmentBottom:
			{
				NSArray *invertedFrameArray = [self invertArrayFromArray:_frameArray];
				lastFrameLayout = [invertedFrameArray lastObject];
				
				for (NKFrameLayout *frameLayout in invertedFrameArray) {
					if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
					
					if (!frameLayout.intrinsicSizeEnabled && (frameLayout==lastFrameLayout)) {
						targetFrame.origin.y	= self.edgeInsets.top;
						targetFrame.size.height	= containerFrame.size.height - usedSpace;
					}
					else {
						frameContentSize			= CGSizeMake(containerFrame.size.width, containerFrame.size.height - usedSpace);
						if (frameLayout==lastFrameLayout || self.intrinsicSizeEnabled) {
							frameContentSize		= [frameLayout sizeThatFits:frameContentSize];
						}
						
						targetFrame.origin.y	= MAX(self.bounds.size.height - frameContentSize.height - self.edgeInsets.bottom - usedSpace, 0);
						targetFrame.size.height	= frameContentSize.height;
					}
					
					frameLayout.frame = targetFrame;
					
					space = (frameContentSize.height>0 ? self.spacing : 0);
					usedSpace += frameContentSize.height + space;
				}
			}
				break;
				
			case NKFrameLayoutAlignmentSplit:
			{
				NSInteger visibleFrames = [self numberOfVisibleFrames];
				CGFloat spaces = (visibleFrames - 1) * self.spacing;
				CGFloat cellSize = (containerFrame.size.height - spaces)/(float)visibleFrames;
				if (self.roundUpValue) cellSize = roundf(cellSize);
				
				for (NKFrameLayout *frameLayout in _frameArray) {
					if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
					
					frameContentSize			= CGSizeMake(containerFrame.size.width, cellSize);
					if (self.intrinsicSizeEnabled) [frameLayout sizeThatFits:frameContentSize];
					
					targetFrame.origin.y		= containerFrame.origin.y + usedSpace;
					targetFrame.size.height		= frameContentSize.height;
					frameLayout.frame			= targetFrame;
					
					usedSpace += frameContentSize.height + self.spacing;
				}
			}
				break;
				
			case NKFrameLayoutAlignmentCenter:
			{
				NSInteger visibleFrames = [self numberOfVisibleFrames];
				CGFloat spaces = (visibleFrames - 1) * self.spacing;
				CGFloat cellSize = (containerFrame.size.height - spaces)/(float)visibleFrames;
				if (self.roundUpValue) cellSize = roundf(cellSize);
				
				for (NKFrameLayout *frameLayout in _frameArray) {
					if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
					
					frameContentSize			= CGSizeMake(containerFrame.size.width, cellSize);
					targetFrame.origin.y		= containerFrame.origin.y + usedSpace;
					targetFrame.size.height		= frameContentSize.height;
					frameLayout.frame			= targetFrame;
					
					usedSpace += frameContentSize.height + self.spacing;
				}
			}
				break;
		}
	}
}

- (NSInteger) numberOfVisibleFrames {
	NSInteger count = 0;
	for (NKFrameLayout *frameLayout in _frameArray) {
		if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
		count++;
	}
	
	return count;
}


#pragma mark - HorizontalLayout

- (NKFrameLayout*) leftFrameLayout {
	return [_frameArray count]>0 ? [_frameArray objectAtIndex:0] : nil;
}

- (NKFrameLayout*) rightFrameLayout {
	return [_frameArray count]>1 ? [_frameArray objectAtIndex:1] : nil;
}

- (void) setLeftFrameLayout:(NKFrameLayout*)frameLayout {
	[self replaceFrameLayout:frameLayout atIndex:0];
}

- (void) setRightFrameLayout:(NKFrameLayout*)frameLayout {
	[self replaceFrameLayout:frameLayout atIndex:1];
}


#pragma mark - VerticalLayout

- (NKFrameLayout*) topFrameLayout {
	return [_frameArray count]>0 ? [_frameArray objectAtIndex:0] : nil;
}

- (NKFrameLayout*) bottomFrameLayout {
	return [_frameArray count]>1 ? [_frameArray lastObject] : nil;
}

- (void) setTopFrameLayout:(NKFrameLayout*)frameLayout {
	[self replaceFrameLayout:frameLayout atIndex:0];
}

- (void) setBottomFrameLayout:(NKFrameLayout*)frameLayout {
	[self replaceFrameLayout:frameLayout atIndex:[_frameArray count] - 1];
}


#pragma mark -

- (NSArray*) invertArrayFromArray:(NSArray*)array {
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[array count]];
	NSEnumerator *enumerator = [array reverseObjectEnumerator];
	for (id element in enumerator) {
		[result addObject:element];
	}
	
	return result;
}


#pragma mark - Properties

- (void) replaceFrameLayout:(NKFrameLayout*)frameLayout atIndex:(NSUInteger)index {
	if (frameLayout) {
		NSInteger count = [_frameArray count];
		NKFrameLayout *currentFrameLayout = nil;
		if (count>index) {
			currentFrameLayout = [_frameArray objectAtIndex:index];
		}
		
		if (currentFrameLayout!=frameLayout) {
			if (currentFrameLayout.superview==self) [currentFrameLayout removeFromSuperview];
			
			if (frameLayout) {
				[_frameArray insertObject:frameLayout atIndex:index];
				[self addSubview:frameLayout];
			}
		}
		else if (index==count) {
			[self insertFrameLayoutAtIndex:index];
		}
	}
	else {
		[self removeFrameAtIndex:index];
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
	for (NKFrameLayout *frameLayout in _frameArray) {
		frameLayout.shouldCacheSize = value;
	}
}

- (BOOL) shouldCacheSize {
	BOOL value = YES;
	
	for (NKFrameLayout *frameLayout in _frameArray) {
		value = value && frameLayout.shouldCacheSize;
		if (!value) break;
	}
	
	return value;
}

#pragma mark -

- (void) setAllowContentHorizontalGrowing:(BOOL)value {
	for (NKFrameLayout *frameLayout in self.frameArray) {
		frameLayout.allowContentHorizontalGrowing = value;
	}
}

- (void) setAllowContentVerticalGrowing:(BOOL)value {
	for (NKFrameLayout *frameLayout in self.frameArray) {
		frameLayout.allowContentVerticalGrowing = value;
	}
}

- (void) setAllowContentHorizontalShrinking:(BOOL)value {
	for (NKFrameLayout *frameLayout in self.frameArray) {
		frameLayout.allowContentHorizontalShrinking = value;
	}
}

- (void) setAllowContentVerticalShrinking:(BOOL)value {
	for (NKFrameLayout *frameLayout in self.frameArray) {
		frameLayout.allowContentVerticalShrinking = value;
	}
}


#pragma mark -

- (void) dealloc {
	self.frameArray = nil;
}

@end
