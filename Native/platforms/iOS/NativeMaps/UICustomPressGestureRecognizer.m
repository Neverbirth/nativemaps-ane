//
//  UICustomPressGestureRecognizer.m
//  NativeMaps
//
//  Created by Hector on 18/05/14.
//
//

#import "UICustomPressGestureRecognizer.h"

@implementation UICustomPressGestureRecognizer

-(id) init{
    if (self = [super init])
    {
        self.minimumPressDuration = .07;
    }
    return self;
}

CGPoint first;
BOOL fail;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    FREDispatchStatusEventAsync(getContext2(), (const uint8_t *)"TOUCHBEG", (const uint8_t *)"");
    first = [touches.anyObject locationInView:self.view];
    fail = NO;
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    FREDispatchStatusEventAsync(getContext2(), (const uint8_t *)"TE", (const uint8_t *)(fail == YES ? "yes": "no"));
    if (fail == YES) {
        self.cancelsTouchesInView = NO;
        self.state = UIGestureRecognizerStateCancelled;
        [self.view touchesEnded:touches withEvent:event];
    } else
        [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (fail == YES)
    {
        self.cancelsTouchesInView = NO;
        [self.view touchesMoved:touches withEvent:event];
        return;
    }
    [super touchesMoved:touches withEvent:event];
    CGPoint t = [touches.anyObject locationInView:self.view];
    FREDispatchStatusEventAsync(getContext2(), (const uint8_t *)"TM", (const uint8_t *)[[NSString stringWithFormat:@"%f, %f: %f - %f", first.x, t.x, fabs(first.x - t.x), fabs(first.y - t.y)] UTF8String]);
    if (fabs(first.x - t.x) > 4 || fabs(first.y - t.y) > 4) {
        fail = YES;
        self.state = UIGestureRecognizerStateCancelled;
        [self reset];
    }
}

/*- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return YES;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
    return YES;
}*/

/*- (id)initWithTarget:(id)target action:(SEL)action
{
    if ((self=[super initWithTarget:target action:action])) {
        _allowableMovement = 10;
        _minimumPressDuration = 0.5;
        _numberOfTapsRequired = 0;
        _numberOfTouchesRequired = 1;
    }
    return self;
}

- (void)_beginGesture
{
    _waiting = NO;
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
       // UIApplicationSendStationaryTouches();
    }
}

- (void)_cancelWaiting
{
    if (_waiting) {
        _waiting = NO;
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(_beginGesture) object:nil];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateBegan;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    const CGFloat distance = DistanceBetweenTwoPoints([touch locationInView:self.view], _beginLocation);
    
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        if (distance <= self.allowableMovement) {
            self.state = UIGestureRecognizerStateChanged;
        } else {
            self.state = UIGestureRecognizerStateCancelled;
        }
    } else if (self.state == UIGestureRecognizerStatePossible && distance > self.allowableMovement) {
        self.state = UIGestureRecognizerStateFailed;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateEnded;
    } else {
        [self _cancelWaiting];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.state == UIGestureRecognizerStateBegan || self.state == UIGestureRecognizerStateChanged) {
        self.state = UIGestureRecognizerStateCancelled;
    } else {
        [self _cancelWaiting];
    }
}

- (void)reset
{
    [self _cancelWaiting];
    [super reset];
}*/

@end