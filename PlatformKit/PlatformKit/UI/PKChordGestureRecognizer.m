//
//  ChordGestureRecognizer.h
//
//  Created by Thong Nguyen on 04/01/2016.
//  Copyright (c) 2016 Thong Nguyen. All rights reserved.
//

#if !TARGET_OS_WATCH && !TARGET_OS_MAC

#import "PKChordGestureRecognizer.h"

@implementation PKChordGestureRecognizer

-(id) initWithView:(UIView*)viewIn andGestures:(GestureState)state1, ...
{
    if (self = [super init])
    {
        view = viewIn;

        va_list args;
        va_start(args, state1);
        
        actionsToRecognize = [[NSMutableArray alloc] init];
        
        GestureState state;
        
        while ((state = va_arg(args, GestureState)))
        {
            [actionsToRecognize addObject: [NSNumber numberWithInt: state]];
        }

        va_end(args);
        
        actions = [[NSMutableArray alloc] initWithCapacity:actionsToRecognize.count];
		
		rotationGestureRecogniser = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onRotationGesture:)];
        
        [view addGestureRecognizer:rotationGestureRecogniser];
        
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTwoFingeredTapGesture:)];
        tapRecognizer.numberOfTouchesRequired = 2;
        tapRecognizer.numberOfTapsRequired = 2;
        
        [view addGestureRecognizer:tapRecognizer];
    }
    
    return self;
}

-(BOOL) gestureRecognized
{
	if (actions.count != actionsToRecognize.count)
	{
		return NO;
	}
	
	for (int i = 0; i < actionsToRecognize.count; i++)
	{
		int intValue = ((NSNumber*)[actions objectAtIndex:i]).intValue;
		
		if (intValue != ((NSNumber*)[actionsToRecognize objectAtIndex:i]).intValue)
		{
			return NO;
		}
	}
	
	return YES;
}

-(void) onTwoFingeredTapGesture:(UIRotationGestureRecognizer*)gestureRecogniser
{
	if ([self gestureRecognized])
	{
		[actions removeAllObjects];
        
        [self.delegate chordGestureRecognised:self];
		
		return;
	}	
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
		
		[actions addObject:[NSNumber numberWithInt:GestureStateRotateLeft]];
	}
	else if (gestureRecogniser.rotation > 0)
	{
		if (lastRotation > 0)
		{
			return;
		}
		
		lastRotation = gestureRecogniser.rotation;
		
		[actions addObject:[NSNumber numberWithInt:GestureStateRotateRight]];
	}
	
	while (actions.count > actionsToRecognize.count)
	{
		[actions removeObjectAtIndex:0];
	}
}

@end

#endif