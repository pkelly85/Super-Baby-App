//
//  MoviePlayer.h
//  SuperBaby
//
//  Created by MAC107 on 21/01/15.
//  Copyright (c) 2015 tatva. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

@interface MoviePlayer : MPMoviePlayerViewController
{
    NSTimer *timerDelegate;
    
    NSArray *arrAnnotation;
    NSInteger currentIndex;
}
@property(nonatomic,strong)NSDictionary *dictINFO;
@property(nonatomic,strong)NSString *strVideoID;

@property(nonatomic,strong)NSString *moviePath;
@property(nonatomic,strong)NSArray *arrAnnotation;
@end
