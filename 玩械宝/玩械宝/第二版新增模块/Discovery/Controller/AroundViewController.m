//
//  AroundViewController.m
//  玩械宝
//
//  Created by Stone袁 on 16/1/15.
//  Copyright (c) 2016年 zgcainiao. All rights reserved.
//

#import "AroundViewController.h"
#import "SellViewController.h"


@interface AroundViewController ()<UITableViewDelegate,UITableViewDataSource,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate,BMKGeoCodeSearchDelegate>
{
    //提供定位服务功能
    BMKLocationService *_locationService;
    BMKMapView* _mapView;
    CLLocationCoordinate2D pt;

    //检索对象
    BMKPoiSearch *_search;
    BMKRouteSearch*  _searcher;
    //缩放按钮
    UIButton*_directionBut;
    //周边搜素结果
    NSMutableArray*_seachArr;
    UITableView*_table;

}

@property (nonatomic,assign) CLLocationDegrees latitude;
@property (nonatomic,assign) CLLocationDegrees longitude;
@property (nonatomic,strong) BMKGeoCodeSearch * searchered;
@end

@implementation AroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化存放搜索结果的数组
    _seachArr = [NSMutableArray arrayWithCapacity:0];
     if(_isVc)
     {
        self.title=@"附近出租";
         [_seachArr removeAllObjects];
          _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
          _directionBut=[[UIButton alloc]initWithFrame:CGRectMake(20,self.view.frame.size.height-100, 40, 40)];
     }
    else
    {
        self.title=@"我的位置";
        _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height/2)];
        _directionBut=[[UIButton alloc]initWithFrame:CGRectMake(20,self.view.frame.size.height-350, 40, 40)];
        
        _table=[[UITableView alloc]initWithFrame:CGRectMake(0,_mapView.frame.size.height-60,self.view.frame.size.width,self.view.frame.size.height/2+80) style:UITableViewStylePlain];
        _table.rowHeight=60;
        _table.delegate=self;
        _table.dataSource=self;
//        UIView *views = [UIView new];
//        [_table setTableFooterView:views];
        [self.view addSubview:_table];
    }
    [self initmap];
   }
-(void) initmap{
     _mapView.delegate =self;
    _mapView.rotateEnabled = NO; //设置是否可以旋转
    [self.view addSubview:_mapView];
    //开启跟随
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    //显示定位图层
    _mapView.showsUserLocation =YES;
    //初始化BMKLocationService
    _locationService =[[BMKLocationService alloc]init];
    _locationService.distanceFilter =10;
    //定位精确度
    _locationService.desiredAccuracy =kCLLocationAccuracyBest;
    _locationService.delegate =self;
    //启动LocationService
    [_locationService startUserLocationService];
    //缩放按钮
    [_directionBut setImage:[UIImage imageNamed:@"custom_loc"] forState:UIControlStateNormal];
    [_directionBut addTarget:self action:@selector(zoombut) forControlEvents:UIControlEventTouchUpInside];
    _directionBut.backgroundColor=[UIColor whiteColor];
    [_mapView addSubview:_directionBut];
    
    //初始化检索对象
    _search =[[BMKPoiSearch alloc]init];
    _search.delegate = self;
    //初始化检索对象  用于导航
    _searcher = [[BMKRouteSearch alloc]init];
    _searcher.delegate = self;
    //geo搜索服务 (将经纬度转化为地址,城市等信息,被称为反向地理编码)
    self.searchered = [[BMKGeoCodeSearch alloc]init];
    self.searchered.delegate = self;
 
}
-(void)zoombut
{
  [_mapView setZoomLevel:18.f];
  [_table reloadData];
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //把获取的地理信息记录下来
    pt=userLocation.location.coordinate;
    //直接跳转用户当前定位
    [_mapView setCenterCoordinate:pt animated:YES];
    _mapView.centerCoordinate = pt;
      if(userLocation)
      {
            self.latitude = pt.latitude;
            self.longitude = pt.longitude;
            //更新我的位置数据
           [_mapView updateLocationData:userLocation];
            CLLocationCoordinate2D point = (CLLocationCoordinate2D){pt.latitude,pt.longitude};
            BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
            reverseGeoCodeSearchOption.reverseGeoPoint = point;
            BOOL flag = [self.searchered reverseGeoCode:reverseGeoCodeSearchOption];
            if(!flag)
            {
               NSLog(@"反geo检索发送失败");
            }
    }
}
#pragma mark - onGetReverseGeoCodeResult(反向地理编码结果)
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    [_seachArr removeAllObjects];
    if (error == BMK_SEARCH_NO_ERROR) {
     
        //这里打印出反向地理编码的结果,包括城市,地址等信息
        _addressStr=result.address;
        //在此处理正常结果
        NSArray* poiInfoList =result.poiList;
        [[NSUserDefaults standardUserDefaults]setObject:_addressStr forKey:@"addressStr"];
        for(BMKPoiInfo *info in poiInfoList)
        {
            BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
            annotation.coordinate = info.pt;
            annotation.title = info.name;//主标题
            annotation.subtitle =info.address;//副标题
            [_seachArr addObject:annotation];
//           NSLog(@"%@---%@---",info.name,info.address);
        }
        [_table reloadData];
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
////实现PoiSearchDeleage处理回调结果
//- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
//    {
//        [_seachArr removeAllObjects];
//        if (error == BMK_SEARCH_NO_ERROR) {
//            //在此处理正常结果
//            NSArray* poiInfoList =poiResultList.poiInfoList;
//            
//            for (BMKPoiInfo *info in poiInfoList)
//            {
//                BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
//                annotation.coordinate = info.pt;
//                annotation.title = info.name;//主标题
//                annotation.subtitle =info.address;//副标题
//                [_seachArr addObject:annotation];
//                NSLog(@"%@---%@---",info.name,info.address);
//            }
//         [_table reloadData];
//        }
//        else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
//            //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
//            // result.cityList;
//            NSLog(@"起始点有歧义");
//        } else {
//            NSLog(@"抱歉，未找到结果");
//        }
//}
////视图已经显示的时候开始周边检索
//- (void)viewDidAppear:(BOOL)animated {
//    //检索对象
//    BMKNearbySearchOption *option =[[BMKNearbySearchOption alloc]init];
//    //检索的位置
//    option.location =pt;
//    option.radius =500;
//    option.pageCapacity =10;
//    option.keyword =@"公司";
//    
//    //用搜索对象对当前兴趣热点进行搜索
//    BOOL result= [_search poiSearchNearBy:option];
//    if (!result)
//    {
//      NSLog(@"周边检索失败");
//    }
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _seachArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,10, self.view.frame.size.width, 20)];
        titleLabel.tag=123;
        [cell addSubview:titleLabel];
        
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,35, self.view.frame.size.width, 20)];
        subtitleLabel.tag=456;
        subtitleLabel.textColor=[UIColor lightGrayColor];
        subtitleLabel.font=[UIFont systemFontOfSize:15];
        [cell addSubview:subtitleLabel];
     }
    
    BMKPointAnnotation* annotation = _seachArr[indexPath.row];
    UILabel *titleLabel = (UILabel *)[self.view viewWithTag:123];
    UILabel *subtitleLabel = (UILabel *)[self.view viewWithTag:456];
    titleLabel.text=annotation.title;
    subtitleLabel.text=annotation.subtitle;
    
    return cell;
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate=self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _searchered.delegate = nil;
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
