//
//  UINavigationController+StatusBarStyle.m
//  SuperBaby
//
//  Created by MAC107 on 27/01/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import "UINavigationController+StatusBarStyle.h"

@implementation UINavigationController (StatusBarStyle)
- (UIStatusBarStyle)preferredStatusBarStyle
{
    //also you may add any fancy condition-based code here
    return [[self.viewControllers lastObject] preferredStatusBarStyle];;
}
@end
