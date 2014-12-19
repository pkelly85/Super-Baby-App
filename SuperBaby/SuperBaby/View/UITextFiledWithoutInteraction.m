//
//  TextFiledWithoutInteraction.m
//  Within_iOS
//
//  Created by MAC236 on 21/10/14.
//  Copyright (c) 2014 MAC 227. All rights reserved.
//

#import "UITextFiledWithoutInteraction.h"

@implementation UITextFiledWithoutInteraction

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect )frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewModeAlways;
        //self.autocapitalizationType = UITextAutocapitalizationTypeWords;
        //self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        return self;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewModeAlways;
        //self.autocapitalizationType = UITextAutocapitalizationTypeWords;
        //self.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        return self;
    }
    return self;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return false;
}

@end
