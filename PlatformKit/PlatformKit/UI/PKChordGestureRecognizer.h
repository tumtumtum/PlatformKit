//
//  ChordGestureRecognizer.h
//
//  Created by Thong Nguyen on 04/01/2016.
//  Copyright (c) 2016 Thong Nguyen. All rights reserved.
//

#if !TARGET_OS_WATCH && !TARGET_OS_MAC

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum
{
    GestureStateNil,
	GestureStateRotateLeft,
	GestureStateRotateRight	
}
GestureState;

@class PKChordGestureRecognizer;

@protocol PKChordGestureRecognizerDelegate<NSObject>
-(void) chordGestureRecognised:(PKChordGestureRecognizer*)recognizer;
@end

@interface PKChordGestureRecognizer : NSObject
{
@private
    __weak UIView* view;
    float lastRotation;
    NSMutableArray* actions;
    NSMutableArray* actionsToRecognize;
    UITapGestureRecognizer* tapRecognizer;
    UIRotationGestureRecognizer* rotationGestureRecogniser;
}

@property (readwrite, weak) id<PKChordGestureRecognizerDelegate> delegate;

-(id) initWithView:(UIView*)viewIn andGestures:(GestureState)state1, ...;

@end

#endif