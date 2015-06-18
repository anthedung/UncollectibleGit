//
//  ACNoAnimationSegue.m
//  Uncollectible
//
//  Created by Ashley Corleone on 25/4/13.
//  Copyright (c) 2013 Ashley Corleone. All rights reserved.
//

#import "ACNoAnimationSegue.h"

@implementation ACNoAnimationSegue

- (void)perform
{
    // Add your own animation code here.
    
    [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
}

@end
