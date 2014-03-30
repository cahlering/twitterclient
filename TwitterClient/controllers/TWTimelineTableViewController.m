//
//  TWTimelineTableViewController.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWTimelineTableViewController.h"
#import "../views/TWTweetCell.h"
#import "../clients/TWAPIClient.h"

@interface TWTimelineTableViewController ()


@property (strong, nonatomic) TWTweetCell *offScreenCell;

@property (strong, nonatomic) NSMutableArray *tweetList;
@end

@implementation TWTimelineTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINib *tweetCellNib = [UINib nibWithNibName:@"TWTweetCell" bundle:nil];
    [self.tableView registerNib:tweetCellNib forCellReuseIdentifier: @"TWTweetCell"];
    
    // refresh on pull
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.tableView addSubview:refreshControl];
    
    [[TWAPIClient instance]homeTimeline:^(NSArray *tweets) {
        for (TWTweet *tweet in tweets) {
            [self.tweetList addObject:tweet];
        }
    }];
}

-(void)refresh:(UIRefreshControl *)refreshControl
{
    NSLog(@"Refresh");
    sleep(1);
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWTweetCell" forIndexPath:indexPath];
    
    TWTweet *tweet = [self.tweetList objectAtIndex:indexPath.row];
    [cell setTweet:tweet];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_offScreenCell == nil) {
        _offScreenCell = [[TWTweetCell alloc]init];
    }
    TWTweet * tweet = [[TWTweet alloc]init];
    NSMutableString *tweetStr = [[NSMutableString alloc]initWithString:@"How did this get made?!"];
    for (int i = 0; i < indexPath.row; i++) {
        [tweetStr appendString:@" hpoe"];
    }
    tweet.text = [NSString stringWithString:tweetStr];
    [_offScreenCell setTweet:tweet];

    [_offScreenCell.contentView layoutSubviews];
    CGSize contentViewSize = [_offScreenCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];

    UIFont *font = [UIFont boldSystemFontOfSize:15];
    CGSize maxLabelSize = CGSizeMake(232, 9999);
    CGRect expectedLabelSize = [_offScreenCell.tweet.text boundingRectWithSize:maxLabelSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil ];
    
    //return contentViewSize.height + expectedLabelSize.size.height;
    return 150;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
