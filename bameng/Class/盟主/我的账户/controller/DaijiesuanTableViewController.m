//
//  DaijiesuanTableViewController.m
//  bameng
//
//  Created by 刘琛 on 16/10/26.
//  Copyright © 2016年 HT. All rights reserved.
//

#import "DaijiesuanTableViewController.h"
#import "DaijiesuanTableViewCell.h"
#import "MenDouBeanExchageLists.h"

@interface DaijiesuanTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *daijiesuanLable;


@property(nonatomic,strong) NSMutableArray * dataList;
@end

@implementation DaijiesuanTableViewController

- (NSMutableArray *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}



static NSString *daijiesuanIdentify = @"daijiesuanIdentify";

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    self.navigationItem.title = @"待结算";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DaijiesuanTableViewCell" bundle:nil] forCellReuseIdentifier:daijiesuanIdentify];
    
    
    [self setTabalViewRefresh];
    
    
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView removeSpaces];
    
    
}


- (void)setTabalViewRefresh {
    
    __weak typeof (self) wself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [wself getNewZiXunList];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoerZixunList)];
}

- (void)getMoerZixunList{
    NSMutableDictionary * parme = [NSMutableDictionary dictionary];
    MenDouBeanExchageLists * model = [self.dataList lastObject];
    LWLog(@"%@",[model mj_keyValues]);
    parme[@"lastId"] = @(model.ID);
    [HTMyContainAFN AFN:@"user/tempsettlebeanlist" with:parme Success:^(NSDictionary *responseObject) {
        LWLog(@"%@", responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            NSArray * array = [MenDouBeanExchageLists mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (array.count) {
                [self.dataList addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
}

- (void)getNewZiXunList{
    NSMutableDictionary * parme = [NSMutableDictionary dictionary];
    parme[@"lastId"] = @(0);
    [HTMyContainAFN AFN:@"user/tempsettlebeanlist" with:parme Success:^(NSDictionary *responseObject) {
        LWLog(@"%@", responseObject);
        if ([responseObject[@"status"] integerValue] == 200) {
            
           self.daijiesuanLable.text = [NSString stringWithFormat:@"%@ 盟豆",responseObject[@"data"][@"TempMengBeans"]];
            NSArray * array = [MenDouBeanExchageLists mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (array.count) {
                [self.dataList removeAllObjects];
                [self.dataList addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        LWLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UserModel * user = [UserModel GetUserModel];
    LWLog(@"%@",user.Score);
    
    self.daijiesuanLable.text = [NSString stringWithFormat:@"%@ 盟豆",user.TempMengBeans];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    [tableView  tableViewDisplayWitMsg:nil ifNecessaryForRowCount:self.dataList.count];
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DaijiesuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:daijiesuanIdentify forIndexPath:indexPath];
    cell.pageTag = 1;
    MenDouBeanExchageLists * model = self.dataList[indexPath.row];
    cell.model = model;
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
