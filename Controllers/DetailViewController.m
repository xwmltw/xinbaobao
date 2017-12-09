//
//  DetailViewController.m
//  XianJinDaiSystem
//
//  Created by yanqb on 2017/11/3.
//  Copyright © 2017年 chenchuanxi. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *title = [[UILabel alloc]init];
    title.numberOfLines = 0;
    title.text = [self creatTitle];
//    [title setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [title setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [title setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:AdaptationWidth(24)]];
    [self.view addSubview:title];
    
    
    UILabel *detail = [[UILabel alloc]init];
    detail.numberOfLines = 0;
    detail.text = [self creatDetail];
    [detail setTextColor:CCXColorWithRBBA(34, 58, 80, 0.8)];
    [detail setFont:[UIFont fontWithName:@"PingFangSC-Light" size:AdaptationWidth(16)]];
    [self.view addSubview:detail];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.top.mas_equalTo(self.view).offset(AdaptationWidth(30));
        make.height.mas_equalTo(60);
    }];
    [detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(title.mas_bottom).offset(20);
        make.left.mas_equalTo(self.view).offset(AdaptationWidth(24));
        make.right.mas_equalTo(self.view).offset(-AdaptationWidth(24));
        make.bottom.mas_equalTo(self.view).offset(AdaptationWidth(-20));
        
    }];
    
}
- (NSString *)creatTitle{
    NSString *str = nil;
    switch (self.indenx) {
        case 0:
            str = @"易宪容:未来有更多利好的金融政策会推出";
            break;
        case 1:
            str = @"防范金融风险重在健全监管体系";
            break;
        case 2:
            str = @"比特币能挺过下次金融危机吗？";
            break;
        case 3:
            str = @"中国金融市场发展指明方向";
            break;
        case 4:
            str = @"把现代金融归入产业体系发出什么信号？";
            break;
        case 5:
            str = @"现金贷遭遇冷眼？";
            break;
        case 6:
            str = @"现金贷和消费信贷怎能混为一谈";
            break;
         case 7:
            str = @"贷款超市：闷声发大财，还是亏本赚吆喝";
            break;
        case 8:
            str = @"上海监管部门窗口指导银行和现金贷的合作业务";
            break;
        default:
            break;
    }
    return str;
}
- (NSString *)creatDetail{
    NSString *str = nil;
    switch (self.indenx) {
        case 0:
            str = @"   在十九大报告中，涉及金融相关的话不多，就是一百字左右。但是其中的几句话则是特别特别的重要，估计这些话将决定未来几年中国金融市场之走势。比提出的“现代金融”，“增强金融服务实体经济能力”，“健全货币政策和宏观审慎政策双支柱调控框架”等。这些话都是新的提法。这些原则就决定了未来中国金融政策的走向。而“现代金融”提法更是特别重要。\n   在报告中，确定了中国进入了一个新时代。在新时代，新问题、新矛盾、新经济、新产业、新行业，一些新的东西都会涌现。而“现代金融”就是一种新产业、新业态。在报告中，“现代金融”是放在与实体经济、科技创新、人力资源协同发展等产业体系的建设并列使用的。这说明了对未来中国经济发展，现代金融已经放在特别特别重要的位置上。它是未来中国经济发展的新动能。";
            break;
        case 1:
            str = @"   时评：解读十九大·金融改革系列（四）\n   习近平总书记在十九大报告中指出，“健全金融监管体系，守住不发生系统性金融风险的底线”。\n   防止发生系统性金融风险是金融工作永恒的主题。系统性金融风险的危害性毋庸置疑，作为一只看似行走缓慢的“灰犀牛”，往往容易对经济体发动“突袭”，并在金融机构和行业之间横向传染和蔓延。为避免经济受到巨大冲击，健全金融监管体系，强化金融监管，成为防范风险的重要任务。";
            break;
        case 2:
            str = @"   市场对比特币的看法形成了鲜明的两个阵营，反方坚决认定所有虚拟货币都是“郁金香泡沫”，正方认为比特币的价格涨幅“一眼望不到头”。\n   究竟谁对谁错如何分辨呢？博客oftwominds.com的专栏作家Charles Hugh Smith认为，在经济和市场一片大好的时候无法判断，要判断比特币的真正价值，还要到金融危机中走一遭。\n   可能的解释是，黄金在金融危机正盛时期遭遇大幅抛压，投资者出售黄金换取现金来满足保证金账户的补款需求。而黄金作为理想的储值工具有吸引力，“接盘侠”层出不穷、随后抬高价格。";
            break;
        case 3:
            str = @"   近日，金融市场运行总体平稳，金融领域最受关注的莫过于十九大报告为中国金融市场发展指明了方向。\n   “增强金融服务实体经济能力”“促进多层次资本市场健康发展”“健全货币政策和宏观审慎政策双支柱调控框架”“守住不发生系统性金融风险的底线”……十九大报告中对于深化金融体制改革的阐述成为市场关注的焦点。\n   19日，在党的十九大中央金融系统代表团媒体开放日上，有关代表在发言中透露出未来一系列金融政策的新方向。";
            break;
        case 4:
            str = @"   十九大报告提出，着力加快建设实体经济、科技创新、现代金融、人力资源协同发展的产业体系。\n   “把现代金融归入产业体系中的一部分，实际上强调金融是整个国民经济的一部分，与实体经济紧密联系、互相支撑，而不是孤立的、分割的。”十九大代表、大连商品交易所理事长李正强说，这个定位就要求金融业发展回归本源，服务好实体经济，而不能搞自我循环、自我膨胀。\n   这是对金融业本身、金融与实体经济关系认识的进一步深化。";
            break;
        case 5:
            str =@"   中国金融科技公司受追捧热潮似乎开始冷却。\n   11月10日消息，媒体援引知情人士消息称，网贷公司拍拍贷发行价低于参考区间下限16美元，并由此筹集了2.21亿美元。\n   此前，拍拍贷于10月31日更新了招股说明书，计划发行1700万股ADS，相当于8500万股A级普通股（每股ADS相当于5股拍拍贷A类普通股），预计每股ADS的价格区间为16美元至19美元，融资总额最高可达3.71亿美元。按照拍拍贷普通股总股本折合为ADS后计算，拍拍贷上市后估值有望超过50亿美元。";
            break;
         case 6:
            str = @"   近几年在消费金融这一风口下，各路玩家尽显神通，但无外乎两种玩法，即现金贷和消费分期。从本质上来说，现金贷与消费分期有着明确的区分。\n   首先是业务特征方面的巨大差异。从监管角度看，“现金贷”的业务特征已经清晰。而消费分期主要指的是在一定消费场景前提下，由银行、消费金融公司、电商平台等提供资金给消费场所，消费者进行分期付款还款，一般情况下要结合比较完善的信贷消费法律体系和征信体系。\n   其次是两者资金流向的区别。现金贷是资金直接支付给实际借款人，借款人拿到资金后具体用途并不限定。而消费分期所承担的资金基本上支付给店铺或者其他消费场所，直接用于支付消费者在消费商品或服务过程中所需费用。";
            break;
        case 7:
            str =@"   贷款超市又称为贷款搜索平台，基于信息不对称，一些公司将市场上典型的贷款公司聚集到一个平台供借款人选择，以便更好的获取借款，并从贷款公司或者客户经理处收取推荐费、广告费、会员费等作为公司收入。 \n    据麻袋理财研究院数据统计，借款客户主要是互联网年轻群体，年龄20-30岁，通过手机或者PC操作，贷款端主要是银行、信用卡中心、消费金融公司、互联网小贷、网贷平台借款端、助贷机构等。";
            break;
        case 8:
            str = @"   以银行为例，趣店招股书显示，2017年4月，趣店与某家银行签订合作协议，提供最高20亿元资金。借款模式为，由大数据模型进行评估，银行筛选潜在的银行覆盖不到的借款人，对其申请进行审查并批准信贷额度。由银行直接向借款人提供贷款，借款人在支付宝账户中收到资金，后续直接向银行还款付息，银行扣除其本金和费用后，其余部分返还趣店。如果借款人出现违约，由趣店向银行偿还全部损失。\n   近日，地方监管首次发声现金贷业务。广州市金融工作局相关人士在接受21世纪经济报道记者采访时认为，现金贷作为一种商业模式，有其存在的必然性。从监管角度出发，如果现金贷不违反相关的法律法规，监管部门可从有利于整个行业发展的角度出发，对其进行合理引导。";
            break;
        default:
            break;
    }
    return str;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
