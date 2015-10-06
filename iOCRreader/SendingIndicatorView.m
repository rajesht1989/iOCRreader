//
//  SendingIndicatorView.m
//  iMessageSendingAnimation
//
//  Created by Rajesh on 7/1/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "SendingIndicatorView.h"
@interface SendingIndicatorView()
{
    UIView *indicationView;
    NSTimer *indicationTimer;
    BOOL shouldStopAnimation;
    NSTimeInterval currentInterval;
}
@end

@implementation SendingIndicatorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame andIndicationColor:(UIColor *)color
{
    frame.size.height = 2;
    if (self = [super initWithFrame:frame])
    {
        frame.size.width = 0;
        indicationView = [[UIView alloc] initWithFrame:frame];
        [indicationView setBackgroundColor:color];
        [self addSubview:indicationView];
    }
    return self;
}

- (void)startAnimating
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self setTimeIntervalForAnimation:.01];
}

- (void)animate
{
    CGRect frame = indicationView.frame;
    CGFloat afloat = frame.size.width/self.frame.size.width;
    if (!shouldStopAnimation && afloat > .5)
    {
        [self setTimeIntervalForAnimation:1.1*currentInterval];
    }
    
    if (frame.size.width < self.frame.size.width)
    {
        frame.size.width += 1;
    }
    else
    {
        shouldStopAnimation = NO;
        [indicationTimer invalidate];
        frame.size.width = 0;
    }
    [indicationView setFrame:frame];
}

- (void)stopAnimating
{
    shouldStopAnimation = YES;
    [self setTimeIntervalForAnimation:.001];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)setTimeIntervalForAnimation:(NSTimeInterval)interval
{
    currentInterval = interval;
    [indicationTimer invalidate];
    indicationTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(animate) userInfo:nil repeats:YES];
}

@end
