//
//  AllCurrencyViewController.m
//  CurrencyDemo
//
//  Created by Tony on 16/3/16.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "AllCurrencyViewController.h"
#import "ResultsTableViewController.h"

#import "DataModel.h"

@interface AllCurrencyViewController ()
    <UISearchResultsUpdating>

@property (strong, nonatomic) NSArray *namesArray;
@property (strong, nonatomic) NSArray *fullNamesArray;
@property (strong, nonatomic) NSArray *chineseNamesArray;

@property (strong, nonatomic) DataModel *dataModel;

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) ResultsTableViewController *resultsController;

@end

@implementation AllCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // DataModel单例
    _dataModel = [DataModel sharedInstance];
    
    // 初始化数组
    _namesArray = [NSArray arrayWithArray:_dataModel.namesArray];
    _fullNamesArray = [NSArray arrayWithArray:_dataModel.fullNamesArray];
    _chineseNamesArray = [NSArray arrayWithArray:_dataModel.chineseNamesArray];
    
    // 注册通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayCurrencyChangeWithNotice:) name:@"Remove" object:nil];
    
    // 搜索框
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _resultsController = (ResultsTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ResultsTableViewController"];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:_resultsController];
    self.tableView.tableHeaderView = _searchController.searchBar;
    _searchController.searchResultsUpdater = self;
    self.definesPresentationContext = YES;
    _searchController.hidesNavigationBarDuringPresentation = YES;
    _searchController.dimsBackgroundDuringPresentation = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - update searching
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", searchText];
    if (searchText != nil) {
        [_resultsController.resultsArray removeAllObjects];
    }
    _resultsController.resultsArray = [NSMutableArray arrayWithArray:[_namesArray filteredArrayUsingPredicate:predicate]];
    [_resultsController.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _namesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AllCell" forIndexPath:indexPath];
    
    // 设置Cell属性
    NSString *name = _namesArray[indexPath.row];
    
    UIImageView *imageView = [cell viewWithTag:200];
    [imageView setImage:[UIImage imageNamed:name]];
    
    UILabel *nameLabel = [cell viewWithTag:201];
    nameLabel.text = name;
    
    UILabel *chineseNameLabel = [cell viewWithTag:202];
    chineseNameLabel.text = _chineseNamesArray[indexPath.row];
    
    UILabel *fullNameLabel = [cell viewWithTag:203];
    fullNameLabel.text = _fullNamesArray[indexPath.row];
    
    UIView *maskView = [cell viewWithTag:204];
    if ([_dataModel.displayArray indexOfObject:name] != NSNotFound) {
        maskView.alpha = 0.5;
        cell.userInteractionEnabled = NO;
    } else {
        maskView.alpha = 0;
        cell.userInteractionEnabled = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *maskView = [cell viewWithTag:204];
    maskView.alpha = 0.5;
    cell.userInteractionEnabled = NO;
    
    NSString *displayCurrencyName = _namesArray[indexPath.row];
    [_dataModel addDisplayCurrencyName:displayCurrencyName];
}

- (void)displayCurrencyChangeWithNotice:(NSNotification *) notice {
    NSDictionary *userInfo = notice.userInfo;
    NSString *name = [userInfo objectForKey:@"name"];
    NSUInteger row = [_namesArray indexOfObject:name];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIView *maskView = [cell viewWithTag:204];
    maskView.alpha = 0;
    cell.userInteractionEnabled = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end










