//
//  MyRmReceivedInvitationViewController.m
//  iOS51rcProject
//
//  Created by qlrc on 14-8-27.
//  Copyright (c) 2014年 Lucifer. All rights reserved.
//

#import "MyRmReceivedInvitationViewController.h"
#import "MyRecruitmentViewController.h"
#import "MJRefresh.h"
#import "NetWebServiceRequest.h"
#import "LoadingAnimationView.h"
#import "CommonController.h"

//收到的邀请
@interface MyRmReceivedInvitationViewController ()<NetWebServiceRequestDelegate>
@property (nonatomic, retain) NetWebServiceRequest *runningRequest;
@property (retain, nonatomic) IBOutlet UITableView *tvReceivedInvitationList;
@end

@implementation MyRmReceivedInvitationViewController
@synthesize gotoMyInvitedCpViewDelegate;
@synthesize gotoRmViewDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectRowIndex = 0;
    
    //数据加载等待控件初始化
    loadView = [[LoadingAnimationView alloc] initWithFrame:CGRectMake(140, 100, 80, 98) loadingAnimationViewStyle:LoadingAnimationViewStyleCarton target:self];
    [self onSearch];
    
}

- (void)onSearch
{
    [recruitmentCpData removeAllObjects];
    [self.tvReceivedInvitationList reloadData];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *code = [userDefaults objectForKey:@"code"];
    NSString *userID = [userDefaults objectForKey:@"UserID"];
    NSMutableDictionary *dicParam = [[NSMutableDictionary alloc] init];
    [dicParam setObject:userID forKey:@"paMainID"];//
    [dicParam setObject:code forKey:@"code"];//152014391908
    NetWebServiceRequest *request = [NetWebServiceRequest serviceRequestUrl:@"GetMyReceivedInvitationList" Params:dicParam];
    [request setDelegate:self];
    [request startAsynchronous];
    request.tag = 1;
    self.runningRequest = request;
    [dicParam release];
}

//成功
- (void)netRequestFinished:(NetWebServiceRequest *)request
      finishedInfoToResult:(NSString *)result
              responseData:(NSMutableArray *)requestData
{
    [recruitmentCpData removeAllObjects];
    recruitmentCpData = requestData;
    
    [self.tvReceivedInvitationList reloadData];
    [self.tvReceivedInvitationList footerEndRefreshing];
    
    //结束等待动画
    [loadView stopAnimating];
}

//绑定数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"cpList"] autorelease];
    //主要信息
    UIView *viewJobMain;
    NSDictionary *rowData = recruitmentCpData[indexPath.row];
    //标题左侧的红线
    UILabel *lbLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, 5, 20)];
    lbLeft.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:90/255.0 blue:49/255.0 alpha:1].CGColor;
    [cell.contentView addSubview:lbLeft];
    [lbLeft release];
    //职位标题
    NSString *strJobName = rowData[@"JobName"];
    UIFont *titleFont = [UIFont systemFontOfSize:15];
    CGFloat titleWidth = 235;
    CGSize titleSize = CGSizeMake(titleWidth, 5000.0f);
    CGSize labelSize = [CommonController CalculateFrame:strJobName fontDemond:titleFont sizeDemand:titleSize];
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, labelSize.width, labelSize.height)];
    lbTitle.text = strJobName;
    lbTitle.lineBreakMode = NSLineBreakByCharWrapping;
    lbTitle.numberOfLines = 0;
    lbTitle.font = titleFont;
    [cell.contentView addSubview:(lbTitle)];
    [lbTitle release];
    //在线离线图标
    UIButton *btnChat = [[UIButton alloc] initWithFrame:CGRectMake(labelSize.width + 20, 6, 28, 15)];
    UIImageView *imgOnline = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 15)];
    imgOnline.image = [UIImage imageNamed:@"ico_joblist_online.png"];
    [btnChat addSubview:imgOnline];
    [cell.contentView addSubview:btnChat];
    [btnChat release];
    [imgOnline release];
    //公司名称
    NSString *strCpName = rowData[@"companyName"];
    labelSize = [CommonController CalculateFrame:strCpName fontDemond:[UIFont systemFontOfSize:11] sizeDemand:CGSizeMake(200, 15)];
    UILabel *lbCpName = [[UILabel alloc] initWithFrame:CGRectMake(20, lbTitle.frame.origin.y + lbTitle.frame.size.height + 5, labelSize.width, 15)];
    lbCpName.text = strCpName;
    lbCpName.font = [UIFont systemFontOfSize:11];
    lbCpName.textColor = [UIColor grayColor];
    [cell.contentView addSubview:(lbCpName)];
    [lbCpName release];
    //邀请时间
    UILabel *lbInviteTime = [[UILabel alloc] initWithFrame:CGRectMake(20, lbCpName.frame.origin.y + lbCpName.frame.size.height + 5, titleWidth, 15)];
    NSString *strBeginDate = rowData[@"AddDate"];
    NSDate *dtBeginDate = [CommonController dateFromString:strBeginDate];
    strBeginDate = [CommonController stringFromDate:dtBeginDate formatType:@"yyyy-MM-dd HH:mm"];
    NSString *strWeek = [CommonController getWeek:dtBeginDate];
    lbInviteTime.text = [NSString stringWithFormat:@"邀请时间：%@ %@",strBeginDate,strWeek];
    lbInviteTime.font = [UIFont systemFontOfSize:11];
    lbInviteTime.textColor = [UIColor grayColor];
    [cell.contentView addSubview:(lbInviteTime)];
    [lbInviteTime release];
    //分隔线
    UILabel *lbLine1 = [[UILabel alloc] initWithFrame:CGRectMake(20, lbInviteTime.frame.origin.y+lbInviteTime.frame.size.height + 5, 280, 1)];
    lbLine1.text = @"--------------------------------------------------------------------------";
    [cell.contentView addSubview:lbLine1];
    [lbLine1 release];
    //招聘会名称
    NSString *strRmName = rowData[@"RecruitmentName"];
    labelSize = [CommonController CalculateFrame:strRmName fontDemond:[UIFont systemFontOfSize:11] sizeDemand:CGSizeMake(200, 15)];
    UILabel *lbRmName = [[UILabel alloc] initWithFrame:CGRectMake(20, lbInviteTime.frame.origin.y + 20, labelSize.width, 15)];
    lbRmName.text = strRmName;
    lbRmName.font = [UIFont systemFontOfSize:11];
    lbRmName.textColor = [UIColor grayColor];
    [cell.contentView addSubview:(lbRmName)];
    [lbRmName release];

    //当前选择行，显示详细信息
    if (selectRowIndex == indexPath.row) {
        //举办时间
        UILabel *lbBeginTime = [[UILabel alloc] initWithFrame:CGRectMake(20, lbRmName.frame.origin.y + lbRmName.frame.size.height + 5, titleWidth, 15)];
        NSString *strBeginDate = rowData[@"BeginDate"];
        dtBeginDate = [CommonController dateFromString:strBeginDate];
        strBeginDate = [CommonController stringFromDate:dtBeginDate formatType:@"yyyy-MM-dd HH:mm"];
        NSString *strWeek = [CommonController getWeek:dtBeginDate];
        lbBeginTime.text = [NSString stringWithFormat:@"举办时间：%@ %@",strBeginDate,strWeek];
        lbBeginTime.font = [UIFont systemFontOfSize:11];
        lbBeginTime.textColor = [UIColor grayColor];
        [cell.contentView addSubview:(lbBeginTime)];
        [lbBeginTime release];
        //举办场馆
        NSString *strPlace = [NSString stringWithFormat:@"举办场馆：%@",rowData[@"PlaceName"]];
        labelSize = [CommonController CalculateFrame:strPlace fontDemond:[UIFont systemFontOfSize:11] sizeDemand:CGSizeMake(200, 15)];
        UILabel *lbPlace = [[UILabel alloc] initWithFrame:CGRectMake(20, lbBeginTime.frame.origin.y + lbBeginTime.frame.size.height + 5, labelSize.width, 15)];
        lbPlace.text = strPlace;
        lbPlace.font = [UIFont systemFontOfSize:11];
        lbPlace.textColor = [UIColor grayColor];
        [cell.contentView addSubview:(lbPlace)];
        [lbPlace release];
        //坐标
        UIButton *btnLngLat = [[UIButton alloc] initWithFrame:CGRectMake(20 + lbPlace.frame.size.width, lbPlace.frame.origin.y, 15, 15)];
        //NSString *lng = rowData[@"lng"];
        //NSString *lat = rowData[@"lat"];
        UIImageView *imgLngLat = [[UIImageView alloc] initWithFrame:CGRectMake(20 + lbPlace.frame.size.width, lbPlace.frame.origin.y, 15, 15)];
        imgLngLat.image = [UIImage imageNamed:@"ico_coordinate_red.png"];
        [btnLngLat addSubview:imgLngLat];
        btnLngLat.tag = (NSInteger)rowData[@"ID"];
        [btnLngLat addTarget:self action:@selector(btnLngLatClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnLngLat];
        [btnLngLat release];
        [imgLngLat release];
        //展位号
        UILabel *lbDeskNo = [[UILabel alloc] initWithFrame:CGRectMake(20, lbPlace.frame.origin.y + lbPlace.frame.size.height + 5, titleWidth, 15)];
        lbDeskNo.text = [NSString stringWithFormat:@"展 位号：%@",rowData[@"DeskNo"]];
        lbDeskNo.font = [UIFont systemFontOfSize:11];
        lbDeskNo.textColor = [UIColor grayColor];
        [cell.contentView addSubview:(lbDeskNo)];
        [lbDeskNo release];
        //具体地址
        NSString *strAddress = [NSString stringWithFormat:@"具体地址：%@",rowData[@"Address"]];
        labelSize = [CommonController CalculateFrame:strAddress fontDemond:[UIFont systemFontOfSize:11] sizeDemand:CGSizeMake(200, 15)];
        UILabel *lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(20, lbDeskNo.frame.origin.y + lbDeskNo.frame.size.height + 5, labelSize.width, 15)];
        lbAddress.text = strPlace;
        lbAddress.font = [UIFont systemFontOfSize:11];
        lbAddress.textColor = [UIColor grayColor];
        [cell.contentView addSubview:(lbAddress)];
        [lbAddress release];
        //携带材料
        NSString *strXdcl = [NSString stringWithFormat:@"携带材料：%@",rowData[@"Address"]];
        labelSize = [CommonController CalculateFrame:strAddress fontDemond:[UIFont systemFontOfSize:11] sizeDemand:CGSizeMake(200, 15)];
        UILabel *lbXdcl = [[UILabel alloc] initWithFrame:CGRectMake(20, lbAddress.frame.origin.y + lbAddress.frame.size.height + 5, labelSize.width, 15)];
        lbXdcl.text = strXdcl;
        lbXdcl.font = [UIFont systemFontOfSize:11];
        lbXdcl.textColor = [UIColor grayColor];
        [cell.contentView addSubview:(lbXdcl)];
        [lbXdcl release];
        //分隔线2
        UILabel *lbLine2 = [[UILabel alloc] initWithFrame:CGRectMake(20, lbXdcl.frame.origin.y+lbXdcl.frame.size.height + 5, 280, 1)];
        lbLine2.text = @"--------------------------------------------------------------------------";
        [cell.contentView addSubview:lbLine2];
        [lbLine2 release];
        //参会人
        NSString *strLinkman = [NSString stringWithFormat:@"参会人：%@",rowData[@"linkman"]];
        labelSize = [CommonController CalculateFrame:strAddress fontDemond:[UIFont systemFontOfSize:11] sizeDemand:CGSizeMake(200, 15)];
        UILabel *lbLinkman = [[UILabel alloc] initWithFrame:CGRectMake(20, lbLine2.frame.origin.y + lbLine2.frame.size.height + 5, labelSize.width, 15)];
        lbLinkman.text = strLinkman;
        lbLinkman.font = [UIFont systemFontOfSize:11];
        lbLinkman.textColor = [UIColor grayColor];
        [cell.contentView addSubview:(lbLinkman)];
        [lbLinkman release];
        //手机号
        NSString *strMobile = [NSString stringWithFormat:@"手机号：%@",rowData[@"Mobile"]];
        labelSize = [CommonController CalculateFrame:strMobile fontDemond:[UIFont systemFontOfSize:11] sizeDemand:CGSizeMake(200, 15)];
        UILabel *lbMobile = [[UILabel alloc] initWithFrame:CGRectMake(20, lbLinkman.frame.origin.y + lbLinkman.frame.size.height + 5, labelSize.width, 15)];
        lbMobile.text = strMobile;
        lbMobile.font = [UIFont systemFontOfSize:11];
        lbMobile.textColor = [UIColor grayColor];
        [cell.contentView addSubview:(lbMobile)];
        [lbMobile release];
        //手机号后面的图标
        UIImageView *imgMobile = [[UIImageView alloc] initWithFrame:CGRectMake(lbMobile.frame.origin.x + lbMobile.frame.size.width, lbMobile.frame.origin.y, 15, 15)];
        imgMobile.image = [UIImage imageNamed:@"ico_coordinate_red.png"];
        [imgMobile addSubview:imgLngLat];
        imgMobile.tag = (NSInteger)rowData[@"ID"];
        [cell.contentView addSubview:imgMobile];
        [imgMobile release];
        //赴约参会
        UIButton *btnAccept = [[UIButton alloc] initWithFrame:CGRectMake(50, lbMobile.frame.origin.y + 50, 70, 30)];
        btnAccept.tag = (NSInteger)rowData[@"ID"];
        [btnAccept addTarget:self action:@selector(btnLngLatClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnAccept];
        
        [btnAccept release];
        //不赴约
        UIButton *btnReject = [[UIButton alloc] initWithFrame:CGRectMake(120, lbMobile.frame.origin.y + 50, 15, 15)];
        btnReject.tag = (NSInteger)rowData[@"ID"];
        [btnReject addTarget:self action:@selector(btnLngLatClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btnReject];
        [btnReject release];
        
//        NSDictionary *rowData = recruitmentCpData[indexPath.row];//
//        //我邀请的企业
//        NSString *myRmCpCount = rowData[@"myInvitCpNum"] ;
//        UIButton *btnMyRmCp = [[UIButton alloc] initWithFrame:CGRectMake(237, 58, 75, 40)];
//        UILabel *lbMyRmCp = [[UILabel alloc] initWithFrame:CGRectMake(7, 25, 60, 10)];
//        lbMyRmCp.text = @"我邀请的企业";
//        lbMyRmCp.font = [UIFont systemFontOfSize:10];
//        lbMyRmCp.textColor = [UIColor blackColor];
//        lbMyRmCp.textAlignment = NSTextAlignmentCenter;
//        [btnMyRmCp addSubview:lbMyRmCp];
//        
//        UILabel *lbMyRmCpCount = [[UILabel alloc] initWithFrame:CGRectMake(17, 9, 40, 10)];
//        lbMyRmCpCount.text = myRmCpCount;
//        lbMyRmCpCount.font = [UIFont systemFontOfSize:9];
//        lbMyRmCpCount.textColor = [UIColor redColor];
//        lbMyRmCpCount.textAlignment = NSTextAlignmentCenter;
//        [btnMyRmCp addSubview:lbMyRmCpCount];
//        
//        //我邀请的企业按钮
//        btnMyRmCp.tag = (NSInteger)rowData[@"paMainID"];
//        btnMyRmCp.layer.borderWidth = 0.5;
//        btnMyRmCp.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        [btnMyRmCp addTarget:self action:@selector(joinRecruitment:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:btnMyRmCp];
//        
//        [btnMyRmCp release];
//        [lbMyRmCp release];
//        [lbMyRmCpCount release];
    }else{
        
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [recruitmentCpData count];
}

//邀请企业参会
- (IBAction)btnInviteCp:(id)sender {
    NSLog(@"邀请企业参会");
}

//点击坐标
-(void)btnLngLatClick:(UIButton *) sender{
    NSLog(@"%d", sender.tag);
}

//点击我参会的企业
-(void)joinRecruitment:(UIButton *) sender{
    NSLog(@"%d", sender.tag);
    [gotoMyInvitedCpViewDelegate GoToMyInvitedCpView:[@(sender.tag) stringValue]];
}

//点击某一行,到达企业页面--调用代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [gotoRmViewDelegate gotoRmView:recruitmentCpData[indexPath.row][@"id"]];
}

//每一行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectRowIndex == indexPath.row) {
        return 230;
    }else    {
        return 110;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)dealloc {
    [_tvReceivedInvitationList release];
    [super dealloc];
}
@end
