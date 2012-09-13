//
//  TVViewController.m
//  firefly
//
//  Created by Victor Grigoriev on 9/3/12.
//  Copyright (c) 2012 Victor Grigoriev. All rights reserved.
//

#import "FFDownloadManager.h"
#import "FFCatalogModel.h"
#import "FFCatalogController.h"
#import "FFPlacesListViewController.h"

#import "Libraries/AFNetworking/AFNetworking.h"
#import "UIButton+bgImageByURL.h"


@interface FFCatalogController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) FFCatalogModel* dataSource;

@property (assign, nonatomic) NSInteger parent;
@property (assign, nonatomic) NSInteger lastTouchedIconIdx;
@property (strong, nonatomic) NSArray* terms;
@property (strong, nonatomic) NSArray* icons;

@end

@implementation FFCatalogController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationHandler:) name:kFFDownloadManagerNotificationCatalogData object:nil];
        
    if (!self.dataSource) {
        [[FFDownloadManager sharedInstance] requestCatalogData];
    }
    
    [self reloadIcons];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setDataSource:nil];
    [self setTerms:nil];
    [self setIcons:nil];
    [self setParent:0];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)reloadIcons
{
    self.terms = [self.dataSource categoriesByParent:self.parent];
    if (self.parent) {
        [self setTitle:[[self.dataSource category:self.parent] name]];
    }
    
    NSMutableArray *buttons = [NSMutableArray new];
    [self.terms enumerateObjectsUsingBlock:^(FFCatalogCategory *obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(idx%3*100+20, idx/3*100+10, 80, 100)];
        
        UIImageView *buttonImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [buttonImageView setImageWithURL:obj.icon_url placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        UILabel *buttonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 80, 20)];
        buttonLabel.text = obj.name;
        buttonLabel.font = button.titleLabel.font;
        
        [button addSubview:buttonImageView];
        [button addSubview:buttonLabel];
        
//        [button setImage:[UIImage imageNamed:@"placeholder"]  forState:UIControlStateNormal];
//        [button setImageWithURL:obj.icon_url forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor colorWithRed:1 green:113 blue:175 alpha:1] forState:UIControlStateNormal];
//        [button setTitle:obj.name forState:UIControlStateNormal];
//        CGSize size = [[button titleForState:UIControlStateNormal] sizeWithFont:button.titleLabel.font];
//        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, size.height, 0)];
//        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, -20, 0)];
                        
        [button addTarget:self action:@selector(categoryIconTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:button];

        [buttons addObject:button];
    }];
    
    self.scrollView.contentSize = CGSizeMake(100 * 3 + 20, 100 * [self.terms count]/3 + 20);
    self.icons = buttons;
}

-(void)categoryIconTouchUpInside:(id)sender
{
    NSInteger idx = [self.icons indexOfObject:sender];
    self.lastTouchedIconIdx = idx;
    
    NSInteger parent = [[self.terms objectAtIndex:idx] parent];
    NSLog(@"categoryIconTouchUpInside: %d", idx);
    if (!parent) {
        // no parent - first level
        [self performSegueWithIdentifier:@"subcategory" sender:sender];
    }
    else {
        // currently we have only 2 depth levels
        // go to the list of places
        [self performSegueWithIdentifier:@"list" sender:sender];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"subcategory"]) {
        NSInteger idx = self.lastTouchedIconIdx;
        NSInteger tid = [[self.terms objectAtIndex:idx] id];
        
        FFCatalogController *destViewController = (id)segue.destinationViewController;
        destViewController.dataSource = self.dataSource;
        destViewController.parent = tid;
    }
    else if ([segue.identifier isEqualToString:@"list"]) {
        FFPlacesListViewController *destViewController = (id)segue.destinationViewController;
        destViewController.category = [[self.terms objectAtIndex:self.lastTouchedIconIdx] id];        
    }
}

-(void)notificationHandler:(NSNotification*)notification
{
    if ([notification.name isEqualToString:kFFDownloadManagerNotificationCatalogData]) {
        NSLog(@"%@:%@", notification.name, notification.object);
        self.dataSource = [[FFCatalogModel alloc] initWithObject:notification.object];
        [self reloadIcons];
    }
    
    //            NSString *message = NSLocalizedString(@"Unable to download catalog categories. %@", 0);
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
    //                                                            message:message
    //                                                           delegate:nil
    //                                                  cancelButtonTitle:@"Ok"
    //                                                  otherButtonTitles:nil];
    //            [alert show];    
}



@end

