//
//  TWTweetCell.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWTweetCell.h"
#import "TWProfileViewController.h"
#import "UIImageView+AFNetworking.h"

@interface TWTweetCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageControl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImage;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImage;
    
- (IBAction)profileTap:(UITapGestureRecognizer *)sender;
@end

@implementation TWTweetCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTweet:(TWTweet *)tweet
{
    _tweet = tweet;
    
    self.tweetLabel.text = tweet.text;

    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
    self.nameLabel.text = tweet.user.name;
    NSURL *profileImageURL = [NSURL URLWithString:self.tweet.user.profileImage];
    NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:profileImageURL];
    UIImage *placeHolderImage = [UIImage imageNamed:@"loading"];
    
    //force the else clauses to prevent images from persisting becuase of cell re-use
    if (tweet.favorited) {
        self.favoriteImage.image = [UIImage imageNamed:@"favorite_on"];
    } else {
        self.favoriteImage.image = [UIImage imageNamed:@"favorite"];
    }
    if (tweet.retweeted) {
        self.retweetImage.image = [UIImage imageNamed:@"retweet_on"];
    } else {
        self.retweetImage.image = [UIImage imageNamed:@"retweet"];
    }
    self.timeLabel.text = [self timeSinceTweet];

    
    [self.profileImageControl setImageWithURLRequest:profileImageRequest placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImageControl.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        nil;
    }];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [_profileImageControl addGestureRecognizer:tapRecognizer];

}

- (NSString *)timeSinceTweet
{
    NSDate *now = [[NSDate alloc]init];
    NSDate *tweetTime = _tweet.createdAt;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                               fromDate:tweetTime
                                                 toDate:now
                                                options:0];
    
    NSString *intervalName;
    int intervalValue = 0;
    if (components.year > 0 ) {
        intervalName = @"y";
        intervalValue = components.year;
    } else if (components.month > 0) {
        intervalName = @"mo";
        intervalValue = components.month;
    } else if (components.day > 0) {
        intervalName = @"d";
        intervalValue = components.day;
    } else if (components.hour > 0) {
        intervalName = @"hr";
        intervalValue = components.hour;
    } else if (components.minute > 0) {
        intervalName = @"m";
        intervalValue = components.minute;
    } else {
        intervalName = @"s";
        intervalValue = components.second;
    }
    return [NSString stringWithFormat:@"%d%@", intervalValue, intervalName];
}

- (CGFloat) cellHeight
{
    UIFont *font = self.tweetLabel.font;
    CGSize maxLabelSize = CGSizeMake(self.tweetLabel.frame.size.width, 9999);
    CGRect expectedLabelSize = [_tweet.text boundingRectWithSize:maxLabelSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName: font}
                                                         context:nil ];
    
    return expectedLabelSize.size.height + 70;
    
}

- (IBAction)profileTap:(UITapGestureRecognizer *)sender {
    TWProfileViewController *profileView = [[TWProfileViewController alloc]init];
    [profileView setUser:_tweet.user];
    [_currentNavigationController pushViewController:profileView animated:YES];
}
@end
