//
//  ChordGestureRecognizer.h
//
//  Created by Thong Nguyen on 04/01/2016.
//  Copyright (c) 2016 Thong Nguyen. All rights reserved.
//

#import "Foundation/Foundation.h"

#if TARGET_OS_IOS && !TARGET_OS_WATCH

#import "PKChordGestureRecognizer.h"

@interface PKChordGestureRecognizer()
{
	__weak UIView* view;
	float lastRotation;
	NSMutableArray* actions;
	NSMutableArray* actionsToRecognize;
	UITapGestureRecognizer* oneFingerTapRecognizer;
	UITapGestureRecognizer* oneFingerDoubleTapRecognizer;
	UITapGestureRecognizer* twoFingerTapRecognizer;
	UITapGestureRecognizer* twoFingerDoubleTapRecognizer;
	UITapGestureRecognizer* threeFingerTapRecognizer;
	UITapGestureRecognizer* threeFingerDoubleTapRecognizer;
	UIRotationGestureRecognizer* rotationGestureRecogniser;
	UIPanGestureRecognizer* panGestureRecognizer;
}
@end

@implementation PKChordGestureRecognizer

-(id) initWithView:(UIView*)viewIn andGestures:(PKChordGesture)state1, ...
{
	va_list args;
	va_start(args, state1);
	
	NSMutableArray* array = [[NSMutableArray alloc] init];
	
	PKChordGesture state;
	
	while ((state = va_arg(args, PKChordGesture)))
	{
		[array addObject:@(state)];
	}
	
	id retval = [self initWithView:viewIn andGesturesArray:array];
	
	va_end(args);
	
	return retval;
	
}

-(id) initWithView:(UIView*)viewIn andGesturesArray:(NSArray*)gestures
{
	if (self = [super init])
	{
		view = viewIn;
		
		self.panThreshold = 60;
		
		actionsToRecognize = [[NSMutableArray alloc] init];
		
		[actionsToRecognize addObjectsFromArray:gestures];
		
		actions = [[NSMutableArray alloc] initWithCapacity:actionsToRecognize.count];
		
		if ([actionsToRecognize containsObject:@(PKChordGestureRotateLeft)] || [actionsToRecognize containsObject:@(PKChordGestureRotateRight)])
		{
			rotationGestureRecogniser = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onRotationGesture:)];
			[view addGestureRecognizer:rotationGestureRecogniser];
		}
		
		oneFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onOneFingerTap:)];
		oneFingerTapRecognizer.numberOfTouchesRequired = 1;
		oneFingerTapRecognizer.numberOfTapsRequired = 1;
		[view addGestureRecognizer:oneFingerTapRecognizer];
		
		oneFingerDoubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onOneFingerDoubleTap:)];
		oneFingerDoubleTapRecognizer.numberOfTouchesRequired = 1;
		oneFingerDoubleTapRecognizer.numberOfTapsRequired = 2;
		[view addGestureRecognizer:oneFingerDoubleTapRecognizer];
		
		twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTwoFingerTap:)];
		twoFingerTapRecognizer.numberOfTouchesRequired = 2;
		twoFingerTapRecognizer.numberOfTapsRequired = 1;
		[view addGestureRecognizer:twoFingerTapRecognizer];
		
		twoFingerDoubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTwoFingerDoubleTap:)];
		twoFingerDoubleTapRecognizer.numberOfTouchesRequired = 2;
		twoFingerDoubleTapRecognizer.numberOfTapsRequired = 2;
		[view addGestureRecognizer:twoFingerDoubleTapRecognizer];
		
		threeFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onThreeFingerTap:)];
		threeFingerTapRecognizer.numberOfTouchesRequired = 3;
		threeFingerTapRecognizer.numberOfTapsRequired = 1;
		[view addGestureRecognizer:threeFingerTapRecognizer];
		
		threeFingerDoubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onThreeFingerDoubleTap:)];
		threeFingerDoubleTapRecognizer.numberOfTouchesRequired = 3;
		threeFingerDoubleTapRecognizer.numberOfTapsRequired = 2;
		[view addGestureRecognizer:threeFingerDoubleTapRecognizer];
		
		if ([actionsToRecognize containsObject:@(PKChordGestureOneFingerPanUp)] || [actionsToRecognize containsObject:@(PKChordGestureOneFingerPanDown)]
			|| [actionsToRecognize containsObject:@(PKChordGestureTwoFingerPanUp)] || [actionsToRecognize containsObject:@(PKChordGestureTwoFingerPanDown)]
			|| [actionsToRecognize containsObject:@(PKChordGestureThreeFingerPanUp)] || [actionsToRecognize containsObject:@(PKChordGestureThreeFingerPanDown)])
		{
			if (rotationGestureRecogniser == nil)
			{
				panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
				panGestureRecognizer.minimumNumberOfTouches = 1;
				panGestureRecognizer.maximumNumberOfTouches = 3;
				[view addGestureRecognizer:panGestureRecognizer];
			}
		}
		
		[oneFingerTapRecognizer requireGestureRecognizerToFail:oneFingerDoubleTapRecognizer];
		[oneFingerDoubleTapRecognizer requireGestureRecognizerToFail:twoFingerTapRecognizer];
		[twoFingerTapRecognizer requireGestureRecognizerToFail:twoFingerDoubleTapRecognizer];
		[twoFingerDoubleTapRecognizer requireGestureRecognizerToFail:threeFingerTapRecognizer];
		[threeFingerTapRecognizer requireGestureRecognizerToFail:threeFingerDoubleTapRecognizer];
	}
	
	return self;
}

-(void) recognizeGesture
{
	if (actions.count < actionsToRecognize.count)
	{
		return;
	}
	
	while (actions.count > actionsToRecognize.count)
	{
		[actions removeObjectAtIndex:0];
	}
	
	for (int i = (int)actionsToRecognize.count - 1; i >= 0; i--)
	{
		int intValue = ((NSNumber*)[actions objectAtIndex:i]).intValue;
		
		if (intValue != ((NSNumber*)[actionsToRecognize objectAtIndex:i]).intValue)
		{
			return;
		}
	}
	
	[actions removeAllObjects];
	[self.delegate chordGestureRecognised:self];
}

-(void) onPan:(UIPanGestureRecognizer*)gestureRecogniser
{
	CGFloat threshold = self.panThreshold;
	CGPoint distance = [gestureRecogniser translationInView:view];
	
	if (!((fabs(distance.x) > threshold || fabs(distance.y) > threshold)))
	{
		return;
	}
	
	PKChordGesture value;
	
	if (distance.y < -threshold)
	{
		switch (gestureRecogniser.numberOfTouches)
		{
			case 1:
				value = PKChordGestureOneFingerPanUp;
				break;
			case 2:
				value = PKChordGestureTwoFingerPanUp;
				break;
			case 3:
				value = PKChordGestureThreeFingerPanUp;
				break;
		}
		
		if ([actions.lastObject intValue] != value)
		{
			[actions addObject:@(value)];
			
			[self recognizeGesture];
		}
	}
	else if (distance.y > threshold)
	{
		switch (gestureRecogniser.numberOfTouches)
		{
			case 1:
				value = PKChordGestureOneFingerPanDown;
				break;
			case 2:
				value = PKChordGestureTwoFingerPanDown;
				break;
			case 3:
				value = PKChordGestureThreeFingerPanDown;
				break;
		}
		
		if ([actions.lastObject intValue] != value)
		{
			[actions addObject:@(value)];
			
			[self recognizeGesture];
		}
	}
	else if (distance.x > threshold)
	{
		switch (gestureRecogniser.numberOfTouches)
		{
			case 1:
				value = PKChordGestureOneFingerPanRight;
				break;
			case 2:
				value = PKChordGestureTwoFingerPanRight;
				break;
			case 3:
				value = PKChordGestureThreeFingerPanRight;
				break;
		}
		
		if ([actions.lastObject intValue] != value)
		{
			[actions addObject:@(value)];
			
			[self recognizeGesture];
		}
	}
	else if (distance.x < -threshold)
	{
		switch (gestureRecogniser.numberOfTouches)
		{
			case 1:
				value = PKChordGestureOneFingerPanLeft;
				break;
			case 2:
				value = PKChordGestureTwoFingerPanLeft;
				break;
			case 3:
				value = PKChordGestureThreeFingerPanLeft;
				break;
		}
		
		if ([actions.lastObject intValue] != value)
		{
			[actions addObject:@(value)];
			
			[self recognizeGesture];
		}
	}
}

-(void) onOneFingerTap:(UIRotationGestureRecognizer*)gestureRecogniser
{
	[actions addObject:@(PKChordGestureOneFingerTap)];
	
	[self recognizeGesture];
}

-(void) onOneFingerDoubleTap:(UIRotationGestureRecognizer*)gestureRecogniser
{
	[actions addObject:@(PKChordGestureOneFingerDoubleTap)];
	
	[self recognizeGesture];
}

-(void) onTwoFingerTap:(UIRotationGestureRecognizer*)gestureRecogniser
{
	[actions addObject:@(PKChordGestureTwoFingerTap)];
	
	[self recognizeGesture];
}

-(void) onTwoFingerDoubleTap:(UIRotationGestureRecognizer*)gestureRecogniser
{
	[actions addObject:@(PKChordGestureTwoFingerDoubleTap)];
	
	[self recognizeGesture];
}

-(void) onThreeFingerTap:(UIRotationGestureRecognizer*)gestureRecogniser
{
	[actions addObject:@(PKChordGestureThreeFingerTap)];
	
	[self recognizeGesture];
}

-(void) onThreeFingerDoubleTap:(UIRotationGestureRecognizer*)gestureRecogniser
{
	[actions addObject:@(PKChordGestureThreeFingerDoubleTap)];
	
	[self recognizeGesture];
}

-(void) onRotationGesture:(UIRotationGestureRecognizer*)gestureRecogniser
{
	if (gestureRecogniser.rotation < 0)
	{
		if (lastRotation < 0)
		{
			return;
		}
		
		lastRotation = gestureRecogniser.rotation;
		
		[actions addObject:@(PKChordGestureRotateLeft)];
	}
	else if (gestureRecogniser.rotation > 0)
	{
		if (lastRotation > 0)
		{
			return;
		}
		
		lastRotation = gestureRecogniser.rotation;
		
		[actions addObject:@(PKChordGestureRotateRight)];
	}
	
	[self recognizeGesture];
}

@end

#endif