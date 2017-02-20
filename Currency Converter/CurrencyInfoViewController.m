//
//  CurrencyInfoViewController.m
//  Currency Converter
//
//  Created by Robert King on 2/19/17.
//  Copyright © 2017 robbyking. All rights reserved.
//

#import "CurrencyInfoViewController.h"


@interface CurrencyInfoViewController ()
    @property (nonatomic, assign) CGFloat sideMargin;
    @property (nonatomic, assign) CGFloat sectionMargin;
    @property (nonatomic, assign) CGFloat topIndex;
    @property (nonatomic, assign) CGFloat viewWidth;
    @property (nonatomic, assign) CGFloat viewHeight;
@end

@implementation CurrencyInfoViewController

- (void)viewDidLoad {
    [self createViews];
    self.navigationItem.title = @"About this app";
}

// Since the other views were created using storyboards and auto layout, I figured I’d write these views in code just for the sake of showing some diversity in my project.

// Truth be told, the only reason I created this view was to write *something* in Objective-C; to me it made sense to write HomescreenViewController in Swift (since it’s
// the main view controller in the project), and for the network layer, the Swift-only library Alamofire was too good to pass up.

// At least this way we get to use a briding header, push some Objective-C classes to the navigation controller stack from a Swift class, and write some basic Objective-C code.

- (void)createViews {
    self.sideMargin = 10.0;
    self.sectionMargin = 20.0;
    self.viewWidth = [UIScreen mainScreen].bounds.size.width;
    self.viewHeight = [UIScreen mainScreen].bounds.size.height;
    CGRect mainViewFrame = CGRectMake(0, 0, self.viewWidth, self.viewHeight);
    UIView *mainView = [[UIView alloc] initWithFrame:mainViewFrame];
    mainView.backgroundColor = [UIColor whiteColor];
    
    
    self.topIndex = 0;
    {
        CGFloat titleViewHeight = 154.0;
        CGRect titleViewFrame = CGRectMake(0, 0, self.viewWidth, titleViewHeight);
        UIView *titleView = [[UIView alloc] initWithFrame:titleViewFrame];
        titleView.backgroundColor = [UIColor colorWithRed:150.0/255 green: 25.0/255 blue: 12.0/255 alpha: 1];
        
        CGFloat titleLabelTopMargin = 100.0;
        CGFloat titleLabelHeight = titleViewHeight - titleLabelTopMargin;
        CGRect titleLabelFrame = CGRectMake(self.sideMargin, titleLabelTopMargin, self.viewWidth - (self.sideMargin*2), titleLabelHeight);
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
        titleLabel.font = [UIFont fontWithName:@"Lato" size:24];
        titleLabel.text = @"About this app";
        titleLabel.textColor = [UIColor whiteColor];
        [titleView addSubview:titleLabel];
        [mainView addSubview:titleView];
        self.topIndex += titleView.frame.size.height + self.sectionMargin;
    }
    
    {
        CGRect contentLabelFrame = CGRectMake(self.sideMargin, self.topIndex, self.viewWidth - (self.sideMargin*2), 0);
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentLabelFrame];
        contentLabel.numberOfLines = 0;
        contentLabel.text = @"Currency Converter was developed in Swift 3 and Objective-C, using Alamofire 4.3.0 for API requests and Cocoapods 1.2.0 for package management.";
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = [UIFont fontWithName:@"Lato" size:15];
        [contentLabel sizeToFit];
        [mainView addSubview:contentLabel];
        
        self.topIndex += contentLabel.frame.size.height + self.sectionMargin;
    }
    
    {
        CGRect contentLabelFrame = CGRectMake(self.sideMargin, self.topIndex, self.viewWidth - (self.sideMargin*2), 0);
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentLabelFrame];
        contentLabel.numberOfLines = 0;
        contentLabel.text = @"I omitted unit tests because A), I kinda ran out of time, and B), I don’t believe in rewriting code just to make it testable, and the fileprivate designator on the functions in the homescreen's view controller made it really tough to write unit tests for.";
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = [UIFont fontWithName:@"Lato" size:15];
        [contentLabel sizeToFit];
        [mainView addSubview:contentLabel];
        
        self.topIndex += contentLabel.frame.size.height + self.sectionMargin;
    }
    
    {
        CGRect contentLabelFrame = CGRectMake(self.sideMargin, self.topIndex, self.viewWidth - (self.sideMargin*2), 0);
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:contentLabelFrame];
        contentLabel.numberOfLines = 0;
        contentLabel.text = @"If we have time in the future, maybe we can add some BDD?";
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = [UIFont fontWithName:@"Lato" size:15];
        [contentLabel sizeToFit];
        [mainView addSubview:contentLabel];
        
        self.topIndex += contentLabel.frame.size.height + self.sectionMargin;
    }
    
    self.view = mainView;
}

- (void)didReceiveMemoryWarning {
    // Dispose of any resources that can be recreated.
}


@end
