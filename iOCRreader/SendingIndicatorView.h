//
//  SendingIndicatorView.h
//  iMessageSendingAnimation
//
//  Created by Rajesh on 7/1/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendingIndicatorView : UIView

- (instancetype)initWithFrame:(CGRect)frame andIndicationColor:(UIColor *)color;
- (void)startAnimating;
- (void)stopAnimating;

@end
