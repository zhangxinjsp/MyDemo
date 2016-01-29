//
//  FourthViewController.m
//  UINavgationController
//
//  Created by zhangxin on 12-11-7.
//  Copyright (c) 2012年 zhangxin. All rights reserved.
//

#import "RegexViewController.h"
#import "NSString-expand.h"


@interface RegexViewController ()<UITextViewDelegate>{
    
    UILabel* label1;
    UILabel* label2;
}

@end

@implementation RegexViewController

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
    self.title = @"正则表达式";
    
    [self predicate];
    [self getSubstringUsingRegular];
}

#pragma mark NSPredicate 

- (void)predicate {
    /*predicate formate 格式
     1. 比较运算符 格式：@"SELF = 123"，@"SELF BETWEEN {100, 200}"
         =、==：判断两个表达式是否相等，在谓词中=和==是相同的意思都是判断，而没有赋值这一说
         >=，=>：判断左边表达式的值是否大于或等于右边表达式的值
         <=，=<：判断右边表达式的值是否小于或等于右边表达式的值
         >：判断左边表达式的值是否大于右边表达式的值
         <：判断左边表达式的值是否小于右边表达式的值
         !=、<>：判断两个表达式是否不相等
         BETWEEN：BETWEEN表达式必须满足表达式 BETWEEN {下限，上限}的格式，要求该表达式必须大于或等于下限，并小于或等于上限
     */
    NSNumber *testNumber = @123;
    NSPredicate *predicate0 = [NSPredicate predicateWithFormat:@"SELF BETWEEN {100, 200}"];
    if ([predicate0 evaluateWithObject:testNumber]) {
        LOGINFO(@"testString:%@", testNumber);
    } else {
        LOGINFO(@"不符合条件");
    }

    /*
     2.逻辑运算符 格式：@"SELF > 2 && SELF < 5"
     
     AND、&&：逻辑与，要求两个表达式的值都为YES时，结果才为YES。
     OR、||：逻辑或，要求其中一个表达式为YES时，结果就是YES
     NOT、 !：逻辑非，对原有的表达式取反
     */

     NSArray *testArray = @[@1, @2, @3, @4, @5, @6];
     NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"SELF > 2 && SELF < 5"];
     NSArray *filterArray0 = [testArray filteredArrayUsingPredicate:predicate1];
     LOGINFO(@"filterArray:%@", filterArray0);
     
    /*
     3.字符串比较运算符
     BEGINSWITH：检查某个字符串是否以指定的字符串开头（如判断字符串是否以a开头：BEGINSWITH 'a'）
     ENDSWITH：检查某个字符串是否以指定的字符串结尾
     CONTAINS：检查某个字符串是否包含指定的字符串
     LIKE：检查某个字符串是否匹配指定的字符串模板。其之后可以跟?代表一个字符和*代表任意多个字符两个通配符。比如"name LIKE '*ac*'"，这表示name的值中包含ac则返回YES；"name LIKE '?ac*'"，表示name的第2、3个字符为ac时返回YES。
     MATCHES：检查某个字符串是否匹配指定的正则表达式。虽然正则表达式的执行效率是最低的，但其功能是最强大的，也是我们最常用的。
     
     字符串比较都是区分大小写和重音符号的。如果希望字符串比较运算不区分大小写和重音符号，请在这些运算符后使用[c]，[d]选项
     格式：name LIKE[cd] 'cafe'
     [c]是不区分大小写，[d]是不区分重音符号
     
     缺点特殊字符的判断有问题
     */
    
    NSString* email = @"366898509@qq.com";
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL ismail = [emailTest evaluateWithObject:email];
    if (ismail) {
        LOGINFO(@"it is a Email address!");
    }
    
    /*
     4.集合运算符
     
     ANY、SOME：集合中任意一个元素满足条件，就返回YES。
     ALL：集合中所有元素都满足条件，才返回YES。
     NONE：集合中没有任何元素满足条件就返回YES。如:NONE person.age < 18，表示person集合中所有元素的age>=18时，才返回YES。
     IN：等价于SQL语句中的IN运算符，只有当左边表达式或值出现在右边的集合中才会返回YES。我们通过一个例子来看一下
     
     array[index]：返回array数组中index索引处的元素
     array[FIRST]：返回array数组中第一个元素
     array[LAST]：返回array数组中最后一个元素
     array[SIZE]：返回array数组中元素的个数
     */
    
    NSArray *filterArray1 = @[@"ab", @"abc"];
    NSArray *array = @[@"a", @"ab", @"abc", @"abcd"];
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", filterArray1];
    LOGINFO(@"%@", [array filteredArrayUsingPredicate:predicate2]);
    
    /*
     %K：用于动态传入属性名
     %@：用于动态设置属性值
     $VALUE:是一个可以动态变化的值，它其实最后是在字典中的一个key，所以可以根据你的需要写不同的值，但是必须有$开头，随着程序改变$VALUE这个谓词表达式的比较条件就可以动态改变。
    */
    // 定义一个property来存放属性名，定义一个value来存放值
    NSString *property = @"name";
    NSString *value = @"Jack";
    // 该谓词的作用是如果元素中property属性含有值value时就取出放入新的数组内，这里是name包含Jack
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K CONTAINS %@", property, value];
    LOGINFO(@"%@", pred);
    
    // 创建谓词，属性名改为age，要求这个age包含$VALUE字符串
    NSPredicate *predTemp = [NSPredicate predicateWithFormat:@"%K > $VALUE", @"age"];
    // 指定$SUBSTR的值为 25 这里注释中的$SUBSTR改为$VALUE
    NSPredicate *pred1 = [predTemp predicateWithSubstitutionVariables:@{@"VALUE" : @25}];
    LOGINFO(@"%@", pred1);

    /*
    
     5.直接量
     
     在谓词表达式中可以使用如下直接量
     
     FALSE、NO：代表逻辑假
     TRUE、YES：代表逻辑真
     NULL、NIL：代表空值
     SELF：代表正在被判断的对象自身
     "string"或'string'：代表字符串
     数组：和c中的写法相同，如：{'one', 'two', 'three'}。
     数值：包括证书、小数和科学计数法表示的形式
     十六进制数：0x开头的数字
     八进制：0o开头的数字
     二进制：0b开头的数字
     
     6.保留字
     
     下列单词都是保留字（不论大小写）
     
     AND、OR、IN、NOT、ALL、ANY、SOME、NONE、LIKE、CASEINSENSITIVE、CI、MATCHES、CONTAINS、BEGINSWITH、ENDSWITH、BETWEEN、NULL、NIL、SELF、TRUE、YES、FALSE、NO、FIRST、LAST、SIZE、ANYKEY、SUBQUERY、CAST、TRUEPREDICATE、FALSEPREDICATE
     
     注：虽然大小写都可以，但是更推荐使用大写来表示这些保留字
     
     */
}

//解析出一个字符串里面，符合表达式的字串
-(void)getSubstringUsingRegular{
    //@"http+:[^\\s]*"    解析网址表达式
    
    //组装一个字符串，把里面的网址解析出来
    NSString *urlString = @"sfdshttp://www.百baidu.com";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http+:[^\\s]*" options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *matchRange = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        
        if (matchRange) {
            for (int i = 0; i < matchRange.numberOfRanges; i++) {
                NSRange resultRange = [matchRange rangeAtIndex:i];
                //从urlString中截取数据
                NSString *result = [urlString substringWithRange:resultRange];
                LOGINFO(@"%@",result);
                label1.text = result;
            }
        }
    }
}

+(NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#define NUMBER_BEGIN 48
#define CAPTAL_LITTER_BEGIN 65
#define SMALL_LITTER_BEGIN 97

-(void)test{
    
    LOGINFO(@"%d",10);
    LOGINFO(@"%x",10);
    LOGINFO(@"%X",10);
    LOGINFO(@"%o\n",10);
    
    LOGINFO(@"%d",10);
    LOGINFO(@"%#x",10);
    LOGINFO(@"%#X",10);
    LOGINFO(@"%#o\n",10);
    
    LOGINFO(@"%d",10);
    LOGINFO(@"%d",0x10);
    LOGINFO(@"%d",0X10);
    LOGINFO(@"%d\n",010);
    
    char a = 'a';
    LOGINFO(@"%d",'1');
    LOGINFO(@"%d",a);
    LOGINFO(@"%d\n",'A');
    
    
    
}














@end
