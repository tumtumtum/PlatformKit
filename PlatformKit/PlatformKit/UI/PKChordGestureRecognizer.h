//
//  ChordGestureRecognizer.h
//
//  Created by Thong Nguyen on 04/01/2016.
//  Copyright (c) 2016 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS && !TARGET_OS_WATCH

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PKChordGesture)
{
	PKChordGestureNil,
	PKChordGestureRotateLeft,
	PKChordGestureRotateRight,
	PKChordGestureOneFingerTap,
	PKChordGestureTwoFingerTap,
	PKChordGestureThreeFingerTap,
	PKChordGestureOneFingerDoubleTap,
	PKChordGestureTwoFingerDoubleTap,
	PKChordGestureThreeFingerDoubleTap,
	PKChordGestureOneFingerPanUp,
	PKChordGestureTwoFingerPanUp,
	PKChordGestureThreeFingerPanUp,
	PKChordGestureOneFingerPanDown,
	PKChordGestureTwoFingerPanDown,
	PKChordGestureThreeFingerPanDown,
	PKChordGestureOneFingerPanLeft,
	PKChordGestureTwoFingerPanLeft,
	PKChordGestureThreeFingerPanLeft,
	PKChordGestureOneFingerPanRight,
	PKChordGestureTwoFingerPanRight,
	PKChordGestureThreeFingerPanRight
};

@class PKChordGestureRecognizer;

@protocol PKChordGestureRecognizerDelegate<NSObject>
-(void) chordGestureRecognised:(PKChordGestureRecognizer*)recognizer;
@end

@interface PKChordGestureRecognizer : NSObject

@property (readwrite) Float32 panThreshold;
@property (readwrite, weak) id<PKChordGestureRecognizerDelegate> delegate;

-(id) initWithView:(UIView*)viewIn andGestures:(PKChordGesture)state1, ...;
-(id) initWithView:(UIView*)viewIn andGesturesArray:(NSArray*)gestures;
@end

#endif