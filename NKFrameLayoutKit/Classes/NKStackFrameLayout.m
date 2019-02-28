//
//  NKStackFrameLayout.m
//  NKFrameLayoutKit
//
//  Created by Nam Kennic on 3/8/14.
//  Copyright (c) 2014 Nam Kennic. All rights reserved.
//

#import "NKStackFrameLayout.h"

@interface NKStackFrameLayout()
	
@property (nonatomic, strong) NSMutableArray<NKFrameLayout*> *frameLayoutArray;
	
@end

@implementation NKStackFrameLayout


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
	_frameLayoutArray			= [NSMutableArray array];
}


#pragma mark - Public Methods

- (NKFrameLayout*) addFrameLayout {
	NKFrameLayout *frameLayout = [[NKFrameLayout alloc] init];
	frameLayout.showFrameDebug = self.showFrameDebug;
	[_frameLayoutArray addObject:frameLayout];
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
	frameLayout.showFrameDebug = self.showFrameDebug;
	[_frameLayoutArray insertObject:frameLayout atIndex:index];
	[self addSubview:frameLayout];
	return frameLayout;
}

- (NKFrameLayout*) addFrameLayout:(NKFrameLayout*)frameLayout {
	if (frameLayout) {
		if (![_frameLayoutArray containsObject:frameLayout]) [_frameLayoutArray addObject:frameLayout];
		[self addSubview:frameLayout];
		return frameLayout;
	}
	else {
		return nil;
	}
}

- (NKFrameLayout*) insertFrameLayout:(NKFrameLayout*)frameLayout atIndex:(NSUInteger)index {
	if (frameLayout) {
		[_frameLayoutArray insertObject:frameLayout atIndex:index];
		frameLayout.showFrameDebug = self.showFrameDebug;
		[self addSubview:frameLayout];
		return frameLayout;
	}
	else {
		return nil;
	}
}

- (void) removeFrameAtIndex:(NSUInteger)index {
	if (index<[_frameLayoutArray count]) {
		NKFrameLayout *frameLayout = [_frameLayoutArray objectAtIndex:index];
		if (frameLayout.superview==self) [frameLayout removeFromSuperview];
		if (self.autoRemoveTargetView) [frameLayout.targetView removeFromSuperview];
		frameLayout.targetView = nil;
		[_frameLayoutArray removeObjectAtIndex:index];
	}
}

- (void) removeAllFrameLayout {
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
		if (self.autoRemoveTargetView) [frameLayout.targetView removeFromSuperview];
		frameLayout.targetView = nil;
		if (frameLayout.superview==self) [frameLayout removeFromSuperview];
	}
	
	[_frameLayoutArray removeAllObjects];
}

- (NKFrameLayout*) frameLayoutAtIndex:(NSInteger)index {
	return index>=0 && index<[_frameLayoutArray count] ? _frameLayoutArray[index] : nil;
}

- (NKFrameLayout*) frameLayoutWithTag:(NSInteger)tag {
	NKFrameLayout *result = nil;
	
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
		if (frameLayout.tag==tag) {
			result = frameLayout;
			break;
		}
	}
	
	return result;
}

- (NKFrameLayout*) frameLayoutWithView:(UIView*)view {
	NKFrameLayout *result = nil;
	
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
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
	return [self frameLayoutAtIndex:[_frameLayoutArray count] - 1];
}

- (void) setClipsToBounds:(BOOL)value {
	[super setClipsToBounds:value];
	
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
		frameLayout.clipsToBounds = value;
	}
}

- (void) setShowFrameDebug:(BOOL)value {
	[super setShowFrameDebug:value];
	
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
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
		
		for (NKFrameLayout *frameLayout in _frameLayoutArray) {
			block(frameLayout, index, &stop);
			if (stop) break;
			index++;
		}
	}
}

#pragma mark -

- (void) setNumberOfFrameLayouts:(NSInteger)number {
	NSInteger count = [_frameLayoutArray count];
	
	if (number==0) {
		[self removeAllFrameLayout];
		return;
	}
	
	if (number<count) {
		while ([_frameLayoutArray count]>number) {
			[self removeFrameAtIndex:[_frameLayoutArray count]-1];
		}
	}
	else if (number>count) {
		if (!_frameLayoutArray) self.frameLayoutArray = [NSMutableArray array];
		
		while ([_frameLayoutArray count]<number) {
			[self insertFrameLayoutAtIndex:[_frameLayoutArray count]];
		}
	}
}

- (NSInteger) numberOfFrameLayouts {
	return [_frameLayoutArray count];
}

- (void) setFrameArray:(NSMutableArray *)array {
	if (_frameLayoutArray!=array) {
		[self removeAllFrameLayout];
		
		_frameLayoutArray = array;
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
		CGFloat totalSpace = 0;
		BOOL isInvertedAlignment = _layoutAlignment == NKFrameLayoutAlignmentRight || _layoutAlignment == NKFrameLayoutAlignmentBottom;
		__block NKFrameLayout *lastFrameLayout = isInvertedAlignment ? [_frameLayoutArray firstObject] : [_frameLayoutArray lastObject];
		
		if (lastFrameLayout.hidden || lastFrameLayout.targetView.hidden) {
			NSEnumerationOptions options = isInvertedAlignment ? NSEnumerationConcurrent : NSEnumerationReverse;
			[_frameLayoutArray enumerateObjectsWithOptions:options usingBlock:^(NKFrameLayout * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
					NKFrameLayout *flexibleFrame = nil;
					
					for (NKFrameLayout *frameLayout in _frameLayoutArray) {
						if (frameLayout.isFlexible) {
							flexibleFrame = frameLayout;
							lastFrameLayout = frameLayout;
							continue;
						}
						
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						frameContentSize = CGSizeMake(containerFrame.size.width - totalSpace, containerFrame.size.height);
						if (self.intrinsicSizeEnabled) {
							frameContentSize = [frameLayout sizeThatFits:frameContentSize];
						}
						
						space = (frameContentSize.width>0 && frameLayout!=lastFrameLayout ? self.spacing : 0);
						totalSpace += frameContentSize.width + space;
						maxHeight = MAX(maxHeight, frameContentSize.height);
					}
					
					if (flexibleFrame) {
						frameContentSize = CGSizeMake(containerFrame.size.width - totalSpace, containerFrame.size.height);
						frameContentSize = [flexibleFrame sizeThatFits:frameContentSize];
						
						totalSpace += frameContentSize.width;
						maxHeight = MAX(maxHeight, frameContentSize.height);
					}
				}
					break;
					
				case NKFrameLayoutAlignmentSplit:
				case NKFrameLayoutAlignmentCenter:
				{
					NKFrameLayout *flexibleFrame = nil;
					frameContentSize = CGSizeMake(containerFrame.size.width/(float)[self numberOfVisibleFrames], containerFrame.size.height);
					for (NKFrameLayout *frameLayout in _frameLayoutArray) {
						if (frameLayout.isFlexible) {
							flexibleFrame = frameLayout;
							lastFrameLayout = frameLayout;
							continue;
						}
						
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						frameContentSize = [frameLayout sizeThatFits:frameContentSize];
						
						space = (frameContentSize.width>0 && frameLayout!=lastFrameLayout ? self.spacing : 0);
						totalSpace += frameContentSize.width + space;
						maxHeight = MAX(maxHeight, frameContentSize.height);
					}
					
					if (flexibleFrame) {
						frameContentSize = CGSizeMake(containerFrame.size.width - totalSpace, containerFrame.size.height);
						frameContentSize = [flexibleFrame sizeThatFits:frameContentSize];
						
						totalSpace += frameContentSize.width;
						maxHeight = MAX(maxHeight, frameContentSize.height);
					}
				}
					break;
			}
			
			if (self.intrinsicSizeEnabled) result.width = totalSpace;
			result.height = MIN(maxHeight, size.height);
		}
		else if (direction==NKFrameLayoutDirectionVertical) {
			CGFloat maxWidth = 0;
			NKFrameLayout *flexibleFrame = nil;
			
			for (NKFrameLayout *frameLayout in _frameLayoutArray) {
				if (frameLayout.isFlexible) {
					flexibleFrame = frameLayout;
					lastFrameLayout = frameLayout;
					continue;
				}
				if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
				
				frameContentSize = CGSizeMake(containerFrame.size.width, containerFrame.size.height - totalSpace);
				if (self.intrinsicSizeEnabled) {
					frameContentSize = [frameLayout sizeThatFits:frameContentSize];
				}
				
				space = (frameContentSize.height>0 && frameLayout!=lastFrameLayout ? self.spacing : 0);
				totalSpace += frameContentSize.height + space;
				maxWidth = MAX(maxWidth, frameContentSize.width);
			}
			
			if (flexibleFrame) {
				frameContentSize = CGSizeMake(containerFrame.size.width, containerFrame.size.height - totalSpace);
				if (self.intrinsicSizeEnabled) {
					frameContentSize = [flexibleFrame sizeThatFits:frameContentSize];
				}
				
				totalSpace += frameContentSize.height;
				maxWidth = MAX(maxWidth, frameContentSize.width);
			}
			
			/*
			switch (self.layoutAlignment) {
				case NKFrameLayoutAlignmentTop:
				case NKFrameLayoutAlignmentBottom:
				{
					for (NKFrameLayout *frameLayout in _frameLayoutArray) {
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						frameContentSize = CGSizeMake(containerFrame.size.width, containerFrame.size.height - usedSpace);
						if (self.intrinsicSizeEnabled) {
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
					for (NKFrameLayout *frameLayout in _frameLayoutArray) {
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						frameContentSize = [frameLayout sizeThatFits:frameContentSize];
						
						space = (frameContentSize.height>0 && frameLayout!=lastFrameLayout ? self.spacing : 0);
						usedSpace += frameContentSize.height + space;
						maxWidth = MAX(maxWidth, frameContentSize.width);
					}
				}
					break;
			}
			*/
			
			if (self.intrinsicSizeEnabled) result.width = maxWidth;
			result.height = MIN(totalSpace, size.height);
			//result.height = MIN(usedSpace + self.edgeInsets.top + self.edgeInsets.bottom, size.height);
		}
		
		// Validating
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


#pragma mark - Keyed Subscripting

- (id) objectAtIndexedSubscript:(NSInteger)index {
	return [self frameLayoutAtIndex:index];
}

- (void) setObject:(id)object  atIndexedSubscript:(NSInteger)index {
	_frameLayoutArray[index] = object;
}


#pragma mark - Private Methods

- (void) layoutSubviews {
	[super layoutSubviews];
	if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) return;
	
	CGRect containerFrame = UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets);
	CGSize frameContentSize;
	CGRect targetFrame = containerFrame;
	CGFloat space;
	CGFloat usedSpace = 0.0;
	BOOL isInvertedAlignment = _layoutAlignment == NKFrameLayoutAlignmentRight || _layoutAlignment == NKFrameLayoutAlignmentBottom;
    __block NKFrameLayout *lastFrameLayout = isInvertedAlignment ? [_frameLayoutArray firstObject] : [_frameLayoutArray lastObject];
	
	if (lastFrameLayout.hidden || lastFrameLayout.targetView.hidden) {
		NSEnumerationOptions options = isInvertedAlignment ? NSEnumerationConcurrent : NSEnumerationReverse;
		[_frameLayoutArray enumerateObjectsWithOptions:options usingBlock:^(NKFrameLayout * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
			{
				NKFrameLayout *flexibleFrame = nil;
				CGFloat flexibleLeftEdge = 0.0;
				
				for (NKFrameLayout *frameLayout in _frameLayoutArray) {
					if ((frameLayout.hidden && self.ignoreHiddenView) || (frameLayout.targetView.hidden && frameLayout.ignoreHiddenView)) continue;
					if (frameLayout.isFlexible) {
						flexibleFrame = frameLayout;
						flexibleLeftEdge = containerFrame.origin.x + usedSpace;
						break;
					}
					
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
					
					targetFrame.origin.x	= containerFrame.origin.x + usedSpace;
					targetFrame.size.width	= frameContentSize.width;
					frameLayout.frame		= targetFrame;
					
					space = (frameContentSize.width>0 ? self.spacing : 0);
					usedSpace += frameContentSize.width + space;
				}
				
				if (flexibleFrame != nil) {
					space = 0;
					usedSpace = 0;
					
					NSArray *invertedFrameArray = [self invertArrayFromArray:_frameLayoutArray];
					
					for (NKFrameLayout *frameLayout in invertedFrameArray) {
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						if (frameLayout==flexibleFrame) {
							targetFrame.origin.x	= flexibleLeftEdge;
							targetFrame.size.width	= containerFrame.size.width - flexibleLeftEdge - usedSpace + self.edgeInsets.left;
						}
						else {
							frameContentSize 		= CGSizeMake(containerFrame.size.width - usedSpace, containerFrame.size.height);
							frameContentSize 		= [frameLayout sizeThatFits:frameContentSize];
							
							targetFrame.origin.x	= MAX(self.bounds.size.width - frameContentSize.width - self.edgeInsets.right - usedSpace, 0);
							targetFrame.size.width	= frameContentSize.width;
						}
						
						frameLayout.frame = targetFrame;
						
						if (frameLayout == flexibleFrame) {
							break;
						}
						
						space = (frameContentSize.width>0 ? self.spacing : 0);
						usedSpace += frameContentSize.width + space;
					}
				}
			}
				break;
				
			case NKFrameLayoutAlignmentRight:
			{
				NKFrameLayout *flexibleFrame = nil;
				CGFloat flexibleRightEdge = 0.0;
				
				NSArray *invertedFrameArray = [self invertArrayFromArray:_frameLayoutArray];
				
				for (NKFrameLayout *frameLayout in invertedFrameArray) {
					if ((frameLayout.hidden && self.ignoreHiddenView) || (frameLayout.targetView.hidden && frameLayout.ignoreHiddenView)) continue;
					if (frameLayout.isFlexible) {
						flexibleFrame = frameLayout;
						flexibleRightEdge = containerFrame.size.width - usedSpace;
						break;
					}
					
					if (!frameLayout.intrinsicSizeEnabled && (frameLayout==lastFrameLayout)) {
						targetFrame.origin.x	= self.edgeInsets.left;
						targetFrame.size.width	= containerFrame.size.width - usedSpace;
					}
					else {
						frameContentSize 		= CGSizeMake(containerFrame.size.width - usedSpace, containerFrame.size.height);
						frameContentSize 		= [frameLayout sizeThatFits:frameContentSize];
						
						targetFrame.origin.x	= MAX(self.bounds.size.width - frameContentSize.width - self.edgeInsets.right - usedSpace, 0);
						targetFrame.size.width	= frameContentSize.width;
					}
					
					frameLayout.frame = targetFrame;
					
					space = (frameContentSize.width>0 ? self.spacing : 0);
					usedSpace += frameContentSize.width + space;
				}
				
				if (flexibleFrame != nil) {
					space = 0;
					usedSpace = 0;
					
					for (NKFrameLayout *frameLayout in _frameLayoutArray) {
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						frameContentSize = CGSizeMake(containerFrame.size.width - usedSpace, containerFrame.size.height);
						if (frameLayout!=lastFrameLayout || self.intrinsicSizeEnabled) {
							CGSize fitSize = [frameLayout sizeThatFits:frameContentSize];
							if (!frameLayout.intrinsicSizeEnabled && (frameLayout == flexibleFrame)) {
								frameContentSize.height = fitSize.height;
							}
							else {
								frameContentSize = fitSize;
							}
						}
						
						targetFrame.origin.x = containerFrame.origin.x + usedSpace;
						
						if (frameLayout == flexibleFrame) {
							targetFrame.size.width = flexibleRightEdge - usedSpace;
						}
						else {
							targetFrame.size.width = frameContentSize.width;
						}
						
						frameLayout.frame = targetFrame;
						
						if (frameLayout == flexibleFrame) {
							break;
						}
						
						space = (frameContentSize.width>0 ? self.spacing : 0);
						usedSpace += frameContentSize.width + space;
					}
				}
			}
				break;
				
			case NKFrameLayoutAlignmentSplit:
			{
				NSInteger visibleFrames = [self numberOfVisibleFrames];
				CGFloat spaces = (visibleFrames - 1) * self.spacing;
				CGFloat cellSize = (containerFrame.size.width - spaces)/(float)visibleFrames;
                if (self.roundUpValue) cellSize = roundf(cellSize);
				
				for (NKFrameLayout *frameLayout in _frameLayoutArray) {
					if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
					
					frameContentSize		= CGSizeMake(cellSize, containerFrame.size.height);
					targetFrame.origin.x	= containerFrame.origin.x + usedSpace;
					targetFrame.size.width	= frameContentSize.width;
					frameLayout.frame		= targetFrame;
					
					usedSpace += frameContentSize.width + self.spacing;
				}
			}
				break;
				
			case NKFrameLayoutAlignmentCenter:
            {
                for (NKFrameLayout *frameLayout in _frameLayoutArray) {
                    if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
                    
                    frameContentSize = CGSizeMake(containerFrame.size.width - usedSpace, containerFrame.size.height);
                    CGSize fitSize = [frameLayout sizeThatFits:frameContentSize];
                    frameContentSize.width = fitSize.width;
                    
                    targetFrame.origin.x	= containerFrame.origin.x + usedSpace;
                    targetFrame.size		= frameContentSize;
                    frameLayout.frame		= targetFrame;
                    
                    space = (frameContentSize.width>0 ? self.spacing : 0);
                    space = frameLayout != lastFrameLayout ? space : 0.0;
                    usedSpace += frameContentSize.width + space;
                }
                
                CGFloat spaceToCenter = (containerFrame.size.width - usedSpace)/2;
                
                for (NKFrameLayout *frameLayout in _frameLayoutArray) {
                    if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
                    
                    targetFrame = frameLayout.frame;
                    targetFrame.origin.x += spaceToCenter;
                    frameLayout.frame = targetFrame;
                }
            }
                break;
                
		}
	}
	else if (direction==NKFrameLayoutDirectionVertical) {
		switch (self.layoutAlignment) {
			case NKFrameLayoutAlignmentTop:
			{
				NKFrameLayout *flexibleFrame = nil;
				CGFloat flexibleTopEdge = 0.0;
				
				for (NKFrameLayout *frameLayout in _frameLayoutArray) {
					if ((frameLayout.hidden && self.ignoreHiddenView) || (frameLayout.targetView.hidden && frameLayout.ignoreHiddenView)) continue;
					if (frameLayout.isFlexible) {
						flexibleFrame = frameLayout;
						flexibleTopEdge = containerFrame.origin.y + usedSpace;
						break;
					}
					
					frameContentSize = CGSizeMake(containerFrame.size.width, containerFrame.size.height - usedSpace);
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
				
				if (flexibleFrame != nil) {
					space = 0;
					usedSpace = 0;
					NSArray *invertedFrameArray = [self invertArrayFromArray:_frameLayoutArray];
					
					for (NKFrameLayout *frameLayout in invertedFrameArray) {
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						if (frameLayout==flexibleFrame) {
							targetFrame.origin.y	= flexibleTopEdge;
							targetFrame.size.height	= containerFrame.size.height - flexibleTopEdge - usedSpace + self.edgeInsets.top;
						}
						else {
							frameContentSize = CGSizeMake(containerFrame.size.width, containerFrame.size.height - usedSpace);
							frameContentSize = [frameLayout sizeThatFits:frameContentSize];
							
							targetFrame.origin.y = MAX(self.bounds.size.height - frameContentSize.height - self.edgeInsets.bottom - usedSpace, 0);
							targetFrame.size.height	= frameContentSize.height;
						}
						
						frameLayout.frame = targetFrame;
						
						if (frameLayout == flexibleFrame) {
							break;
						}
						
						space = (frameContentSize.height>0 ? self.spacing : 0);
						usedSpace += frameContentSize.height + space;
					}
				}
			}
				break;
				
			case NKFrameLayoutAlignmentBottom:
			{
				NKFrameLayout *flexibleFrame = nil;
				CGFloat flexibleBottomEdge = 0.0;
				
				NSArray *invertedFrameArray = [self invertArrayFromArray:_frameLayoutArray];
				
				for (NKFrameLayout *frameLayout in invertedFrameArray) {
					if ((frameLayout.hidden && self.ignoreHiddenView) || (frameLayout.targetView.hidden && frameLayout.ignoreHiddenView)) continue;
					if (frameLayout.isFlexible) {
						flexibleFrame = frameLayout;
						flexibleBottomEdge = containerFrame.size.height - usedSpace;
						break;
					}
					
					if (!frameLayout.intrinsicSizeEnabled && (frameLayout==lastFrameLayout)) {
						targetFrame.origin.y	= self.edgeInsets.top;
						targetFrame.size.height	= containerFrame.size.height - usedSpace;
					}
					else {
						frameContentSize 		= CGSizeMake(containerFrame.size.width, containerFrame.size.height - usedSpace);
						frameContentSize 		= [frameLayout sizeThatFits:frameContentSize];
						
						targetFrame.origin.y	= MAX(self.bounds.size.height - frameContentSize.height - self.edgeInsets.bottom - usedSpace, 0);
						targetFrame.size.height	= frameContentSize.height;
					}
					
					frameLayout.frame = targetFrame;
					
					space = (frameContentSize.height>0 ? self.spacing : 0);
					usedSpace += frameContentSize.height + space;
				}
				
				if (flexibleFrame != nil) {
					space = 0;
					usedSpace = 0;
					
					for (NKFrameLayout *frameLayout in _frameLayoutArray) {
						if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
						
						frameContentSize = CGSizeMake(containerFrame.size.width, containerFrame.size.height - usedSpace);
						if (frameLayout!=flexibleFrame || self.intrinsicSizeEnabled) {
							CGSize fitSize = [frameLayout sizeThatFits:frameContentSize];
							if (!frameLayout.intrinsicSizeEnabled && (frameLayout == flexibleFrame)) {
								frameContentSize.width = fitSize.width;
								
							}
							else {
								frameContentSize = fitSize;
							}
						}
						
						targetFrame.origin.y = containerFrame.origin.y + usedSpace;
						
						if (frameLayout == flexibleFrame) {
							targetFrame.size.height	= flexibleBottomEdge - usedSpace;
						}
						else {
							targetFrame.size.height	= frameContentSize.height;
						}
						
						frameLayout.frame = targetFrame;
						
						if (frameLayout == flexibleFrame) {
							break;
						}
						
						space = (frameContentSize.height>0 ? self.spacing : 0);
						usedSpace += frameContentSize.height + space;
					}
				}
			}
				break;
				
			case NKFrameLayoutAlignmentSplit:
			{
				NSInteger visibleFrames = [self numberOfVisibleFrames];
				CGFloat spaces = (visibleFrames - 1) * self.spacing;
				CGFloat cellSize = (containerFrame.size.height - spaces)/(float)visibleFrames;
				if (self.roundUpValue) cellSize = roundf(cellSize);
				
				for (NKFrameLayout *frameLayout in _frameLayoutArray) {
					if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
					
					frameContentSize			= CGSizeMake(containerFrame.size.width, cellSize);
//					if (frameLayout.intrinsicSizeEnabled) frameContentSize = [frameLayout sizeThatFits:frameContentSize];
					
					targetFrame.origin.y		= containerFrame.origin.y + usedSpace;
					targetFrame.size.height		= frameContentSize.height;
					frameLayout.frame			= targetFrame;
					
					usedSpace += frameContentSize.height + self.spacing;
				}
			}
				break;
				
            case NKFrameLayoutAlignmentCenter:
            {
                for (NKFrameLayout *frameLayout in _frameLayoutArray) {
                    if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
                    
                    frameContentSize = CGSizeMake(containerFrame.size.width, containerFrame.size.height - usedSpace);
                    CGSize fitSize = [frameLayout sizeThatFits:frameContentSize];
                    frameContentSize.height = fitSize.height;
                    
                    targetFrame.origin.y		= containerFrame.origin.y + usedSpace;
                    targetFrame.size            = frameContentSize;
                    frameLayout.frame			= targetFrame;
					
					if (frameLayout != lastFrameLayout) {
						space = (frameContentSize.height>0 ? self.spacing : 0);
					}
					else {
						space = 0.0;
					}
					
                    usedSpace += frameContentSize.height + space;
                }
                
                CGFloat spaceToCenter = (containerFrame.size.height - usedSpace)/2;
                
                for (NKFrameLayout *frameLayout in _frameLayoutArray) {
                    if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
                    
                    targetFrame = frameLayout.frame;
                    targetFrame.origin.y += spaceToCenter;
                    frameLayout.frame = targetFrame;
                }
            }
                break;
                
        }
	}
}

- (NSInteger) numberOfVisibleFrames {
	NSInteger count = 0;
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
		if (frameLayout.hidden || frameLayout.targetView.hidden) continue;
		count++;
	}
	
	return count;
}


#pragma mark - HorizontalLayout

- (NKFrameLayout*) leftFrameLayout {
	return [_frameLayoutArray count]>0 ? [_frameLayoutArray objectAtIndex:0] : nil;
}

- (NKFrameLayout*) rightFrameLayout {
	return [_frameLayoutArray count]>1 ? [_frameLayoutArray objectAtIndex:1] : nil;
}

- (void) setLeftFrameLayout:(NKFrameLayout*)frameLayout {
	[self replaceFrameLayout:frameLayout atIndex:0];
}

- (void) setRightFrameLayout:(NKFrameLayout*)frameLayout {
	[self replaceFrameLayout:frameLayout atIndex:1];
}


#pragma mark - VerticalLayout

- (NKFrameLayout*) topFrameLayout {
	return [_frameLayoutArray count]>0 ? [_frameLayoutArray objectAtIndex:0] : nil;
}

- (NKFrameLayout*) bottomFrameLayout {
	return [_frameLayoutArray count]>1 ? [_frameLayoutArray lastObject] : nil;
}

- (void) setTopFrameLayout:(NKFrameLayout*)frameLayout {
	[self replaceFrameLayout:frameLayout atIndex:0];
}

- (void) setBottomFrameLayout:(NKFrameLayout*)frameLayout {
	[self replaceFrameLayout:frameLayout atIndex:[_frameLayoutArray count] - 1];
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
		NSInteger count = [_frameLayoutArray count];
		NKFrameLayout *currentFrameLayout = nil;
		if (count>index) {
			currentFrameLayout = [_frameLayoutArray objectAtIndex:index];
		}
		
		if (currentFrameLayout!=frameLayout) {
			if (currentFrameLayout.superview==self) [currentFrameLayout removeFromSuperview];
			
			[_frameLayoutArray insertObject:frameLayout atIndex:index];
			[self addSubview:frameLayout];
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
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
		frameLayout.shouldCacheSize = value;
	}
}

- (BOOL) shouldCacheSize {
	BOOL value = YES;
	
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
		value = value && frameLayout.shouldCacheSize;
		if (!value) break;
	}
	
	return value;
}

- (void) setNeedsLayout {
	[super setNeedsLayout];
	
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
		[frameLayout setNeedsLayout];
	}
}

#pragma mark -

- (void) setAllowContentHorizontalGrowing:(BOOL)value {
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
		frameLayout.allowContentHorizontalGrowing = value;
	}
}

- (void) setAllowContentVerticalGrowing:(BOOL)value {
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
		frameLayout.allowContentVerticalGrowing = value;
	}
}

- (void) setAllowContentHorizontalShrinking:(BOOL)value {
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
		frameLayout.allowContentHorizontalShrinking = value;
	}
}

- (void) setAllowContentVerticalShrinking:(BOOL)value {
	for (NKFrameLayout *frameLayout in _frameLayoutArray) {
		frameLayout.allowContentVerticalShrinking = value;
	}
}


#pragma mark -

- (void) dealloc {
	[_frameLayoutArray removeAllObjects];
	self.frameLayoutArray = nil;
}

@end
