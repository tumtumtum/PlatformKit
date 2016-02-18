//
//  ChordGestureRecognizer.h
//
//  Created by Thong Nguyen on 04/01/2016.
//  Copyright (c) 2016 Thong Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS && !TARGET_OS_WATCH

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PKChordGestureRecognizerState)
{
    PKChordGestureRecognizerStateNil,
	PKChordGestureRecognizerStateLeft,
	PKChordGestureRecognizerStateRight
};

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

-(id) initWithView:(UIView*)viewIn andGesturesList:(va_list)gestures;
-(id) initWithView:(UIView*)viewIn andGestures:(PKChordGestureRecognizerState)state1, ...;

@end

#endif