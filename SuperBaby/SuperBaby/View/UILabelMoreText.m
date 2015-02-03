//
//  UILabelExtended.m
//  SuperBaby
//
//  Created by MAC107 on 30/01/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import "UILabelMoreText.h"
#import "AppConstant.h"
#define kNumberOfLines 2
#define ellipsis @" ...More"

@interface UILabelMoreText()  {
    NSString *string;
}

@end
@implementation UILabelMoreText
@synthesize delegate;
#pragma Public Methods

- (void)setTruncatingText:(NSString *) txt {
    [self setTruncatingText:txt forNumberOfLines:kNumberOfLines withMoreColor:self.textColor];
}

- (void)setTruncatingText:(NSString *) txt forNumberOfLines:(int)lines withMoreColor:(UIColor *)color{
    string = txt;
    self.numberOfLines = 0;
    NSMutableString *truncatedString = [txt mutableCopy];
    if ([self numberOfLinesNeeded:truncatedString] > lines)
    {
        [truncatedString appendString:ellipsis];
        NSRange range = NSMakeRange(truncatedString.length - (ellipsis.length + 1), 1);
        while ([self numberOfLinesNeeded:truncatedString] > lines)
        {
            [truncatedString deleteCharactersInRange:range];
            range.location--;
        }
        [truncatedString deleteCharactersInRange:range];  //need to delete one more to make it fit
        CGRect labelFrame = self.frame;
        
        CGRect newSize = [@"A" boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil];
        
        labelFrame.size.height = newSize.size.height * lines;
        self.frame = labelFrame;
        self.text = truncatedString;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(expand:)];
        [self addGestureRecognizer:tapper];
        
        
        
        NSMutableAttributedString *stringText = [[NSMutableAttributedString alloc] initWithString:self.text];
        [stringText addAttribute: NSFontAttributeName value: self.font range:[self.text rangeOfString:ellipsis]];
        [stringText addAttribute: NSForegroundColorAttributeName value:color range:[self.text rangeOfString:ellipsis]];
        
        self.attributedText = stringText;
    }
    else
    {
        CGRect labelFrame = self.frame;
        CGRect newSize = [@"A" boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil];
        
        labelFrame.size.height = newSize.size.height * lines;
        self.frame = labelFrame;
        self.text = txt;
    }
}

#pragma Private Methods

-(int)numberOfLinesNeeded:(NSString *)s{
    
    CGRect newSize = [@"A" boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil];

    
    float oneLineHeight = newSize.size.height;
    
    float totalHeight = [s boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil] .size.height;
    return nearbyint(totalHeight/oneLineHeight);
}

-(void)expand:(UITapGestureRecognizer *) tapper
{
    int linesNeeded = [self numberOfLinesNeeded:string];
    CGRect labelFrame = self.frame;
    CGRect newSize = [@"A" boundingRectWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:nil context:nil];

    labelFrame.size.height = newSize.size.height * linesNeeded;
    self.frame = labelFrame;
    self.text = string;
    
    if ([self.delegate respondsToSelector:@selector(expandLabelNow)]) {
        [self.delegate expandLabelNow];
    }
}
@end
