//
//  TWTimelineTableViewController.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWLandingViewController.h"
#import "TWTimelineTableViewController.h"
#import "TWTweetDetailViewController.h"
#import "TWTweetComposeViewController.h"
#import "../views/TWTweetCell.h"
#import "../clients/TWAPIClient.h"
#import "../models/TWTweetContainer.h"

@interface TWTimelineTableViewController ()


@property (strong, nonatomic) TWTweetCell *offScreenCell;

@property (strong, nonatomic) TWTweetContainer *tweetList;
@property (strong, nonatomic) TWUser *currentUser;

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
    
    self.tweetList = [TWTweetContainer instance];
    [[TWAPIClient instance]currentUser:^(TWUser *user) {
        self.currentUser = user;
    }];
    [self.navigationController setNavigationBarHidden:YES];
    [self showHomeTimelineFromTweetIdAndNewer:nil newer:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.tableView reloadData];
}

-(void)showHomeTimelineFromTweetIdAndNewer :(NSString *)tweetIndex newer:(BOOL)newer
{
    [[TWAPIClient instance]homeTimelineWithIndexAndBefore:tweetIndex before:newer :^(NSArray *tweets) {
        [self.tweetList.tweets addObjectsFromArray:tweets];
        [self.tableView reloadData];
    }];
    
}

-(void)refresh:(UIRefreshControl *)refreshControl
{
    NSLog(@"Refresh");
    TWTweet *newestTweet = [self.tweetList.tweets objectAtIndex:0];
    
    [[TWAPIClient instance]homeTimelineWithIndexAndBefore:[newestTweet idString] before:NO :^(NSArray *tweets) {
        NSMutableArray *newTweets = [tweets mutableCopy];
        [newTweets addObjectsFromArray:self.tweetList.tweets];
        self.tweetList.tweets = newTweets;
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    }];
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
    return [self.tweetList.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWTweetCell" forIndexPath:indexPath];
    
    if (indexPath.row >= self.tweetList.tweets.count - 1) {
        [self showHomeTimelineFromTweetIdAndNewer:((TWTweet *)self.tweetList.tweets.lastObject).idString newer:NO];
    }
    
    TWTweet *tweet = [self.tweetList.tweets objectAtIndex:indexPath.row];
    [cell setTweet:tweet];
    [cell setCurrentNavigationController:self.navigationController];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_offScreenCell == nil) {
        _offScreenCell = [tableView dequeueReusableCellWithIdentifier:@"TWTweetCell"];
    }

    [_offScreenCell setTweet:self.tweetList.tweets[indexPath.row]];

    return [_offScreenCell cellHeight];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTweetDetailViewController *detailViewController = [[TWTweetDetailViewController alloc] initWithNibName:@"TWTweetDetailViewController" bundle:nil];
    detailViewController.tweet = self.tweetList.tweets[indexPath.row];
    detailViewController.currentUser = self.currentUser;
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (IBAction)signOut:(id)sender {
    [[TWAPIClient instance]deauthorize];
    self.currentUser = nil;
    
    TWLandingViewController *landingViewController = [[TWLandingViewController alloc] initWithNibName:@"TWLandingViewController" bundle:nil];
    
    // Push the view controller.
    [self.navigationController pushViewController:landingViewController animated:YES];
}

- (IBAction)compose:(id)sender {
    TWTweetComposeViewController *composeViewController = [[TWTweetComposeViewController alloc] initWithNibName:@"TWTweetComposeViewController" bundle:nil];
    
    [composeViewController setCurrentUser:self.currentUser];
    [self.navigationController pushViewController:composeViewController animated:YES];
}


@end
