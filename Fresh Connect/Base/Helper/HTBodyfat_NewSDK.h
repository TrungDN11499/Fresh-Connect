//
//  HTBodyfat_NewSDK.h
//  HTBodyfatLibDemo
//
//  Created by 乐福衡器 on 2017/12/22.
//  Copyright © 2017年 Holtek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///性别类型
typedef NS_ENUM(NSInteger, THTSexType){
    THTSexTypeFemale,        //!<
    THTSexTypeMale           //!< 男性
};

///Error type (for input parameters)
typedef NS_ENUM(NSInteger, THTBodyfatErrorType){
    THTBodyfatErrorTypeNone,         //!< 无错误(可读取所有参数)
    THTBodyfatErrorTypeImpedance,    //!< 阻抗有误,阻抗有误时, 不计算除BMI/idealWeightKg以外参数(写0)
    THTBodyfatErrorTypeAge,          //!< 年龄参数有误，需在 6   ~ 99岁(不计算除BMI/idealWeightKg以外参数)
    THTBodyfatErrorTypeWeight,       //!< 体重参数有误，需在 10  ~ 200kg(有误不计算所有参数)
    THTBodyfatErrorTypeHeight        //!< 身高参数有误，需在 90 ~ 220cm(不计算所有参数)
};
//身体类型
typedef NS_ENUM(NSInteger, THTBodyType){
    THTBodyTypeThin,             //!< 偏瘦型
    THTBodyTypeLThinMuscle,      //!< 偏瘦肌肉型
    THTBodyTypeMuscular,         //!< 肌肉发达型
    
    THTBodyTypeLackofexercise,   //!< 缺乏运动型
    THTBodyTypeStandard,         //!< 标准型
    THTBodyTypeStandardMuscle,   //!< 标准肌肉型
    
    THTBodyTypeObesFat,          //!< 浮肿肥胖型
    THTBodyTypeLFatMuscle,       //!< 偏胖肌肉型
    THTBodyTypeMuscleFat,        //!< 肌肉型偏胖
    
};
//健康等级
typedef NS_ENUM(NSInteger, THTBodyGrade) {
    
    THTBodyGradeThin,             //!< 偏瘦型
    THTBodyGradeLThinMuscle,      //!< 标准型
    THTBodyGradeMuscular,         //!< 超重型
    THTBodyGradeLackofexercise,   //!< 肥胖型
    THTBodyGradeError,            //!< 参数错误
};
//肥胖等级
typedef NS_ENUM(NSInteger, THTBodyFatGrade) {
    
    THTBodyGradeFatOne,             //!< 肥胖1级
    THTBodyGradeLFatTwo,            //!< 肥胖2级
    THTBodyGradeFatThree,           //!< 肥胖3级
    THTBodyGradeFatFour,            //!< 参数错误
};
//健康评估
typedef NS_ENUM(NSInteger, THTBodyHealthAssessment) {
    
    THTBodyAssessment1,          //!< 健康存在隐患
    THTBodyAssessment2,          //!< 亚健康
    THTBodyAssessment3,          //!< 一般
    THTBodyAssessment4,          //!< 良好
    THTBodyAssessment5,          //!< 非常好
};

@interface HTBodyfat_NewSDK : NSObject

@property (nonatomic,assign) THTSexType            thtSex;         //!< 性别
@property (nonatomic,assign) NSInteger            thtHeightCm;    //!< 身高(cm)，需在 90 ~ 220cm
@property (nonatomic,assign) CGFloat              thtWeightKg;    //!< 体重(kg)，需在 10  ~ 200kg
@property (nonatomic,assign) NSInteger            thtAge;         //!< 年龄(岁)，需在6 ~ 99岁
@property (nonatomic,assign) CGFloat              thtZTwoLegs;    //!< 脚对脚阻抗值(Ω), 范围200.0 ~ 1200.0

@property (nonatomic,assign) CGFloat              thtproteinPercentage;    //!< 蛋白质,分辨率0.1, 范围2.0% ~ 30.0%
@property (nonatomic,copy) NSDictionary*          thtproteinRatingList;    //!< 蛋白健康标准字典,"不足-标准"“标准-优秀”

@property (nonatomic,assign) NSInteger            thtBodyAge;              //!< 身体年龄,6~99岁
@property (nonatomic,assign) CGFloat              thtIdealWeightKg;        //!< 理想体重(kg)

@property (nonatomic,assign) CGFloat              thtBMI;                  //!< Body Mass Index 人体质量指数, 分辨率0.1, 范围10.0 ~ 90.0
@property (nonatomic,copy) NSDictionary*          thtBMIRatingList;        //!< BMI健康标准字典,"瘦-普通"“普通-偏胖”“偏胖-肥胖”

@property (nonatomic,assign) NSInteger            thtBMR;                  //!< Basal Metabolic Rate基础代谢, 分辨率1, 范围500 ~ 10000
@property (nonatomic,copy) NSDictionary*          thtBMRRatingList;        //!< 基础代谢健康标准字典:"偏低-达标"

@property (nonatomic,assign) NSInteger            thtVFAL;                 //!< Visceral fat area leverl内脏脂肪, 分辨率1, 范围1 ~ 60
@property (nonatomic,copy) NSDictionary*          thtVFALRatingList;       //!< 内脏脂肪等级标准字典,"标准-警惕""警惕-危险"

@property (nonatomic,assign) CGFloat              thtBoneKg;               //!< 骨量(kg), 分辨率0.1, 范围0.5 ~ 8.0
@property (nonatomic,copy) NSDictionary*          thtBoneRatingList;       //!< 骨量等级标准字典,"不足-标准"“标准-优秀”


@property (nonatomic,assign) CGFloat              thtBodyfatPercentage;    //!< 脂肪率(%), 分辨率0.1, 范围5.0% ~ 75.0%
@property (nonatomic,copy) NSDictionary*          thtBodyfatRatingList;    //!< 脂肪率健康标准字典"偏瘦-标准"“标准-警惕”“警惕-偏胖”“偏胖-肥胖”

@property (nonatomic,assign) CGFloat              thtWaterPercentage;      //!< 水分率(%), 分辨率0.1, 范围35.0% ~ 75.0%
@property (nonatomic,copy) NSDictionary*          thtWaterRatingList;      //!< 水分率健康标准 "不足-标准"“标准-优秀”

@property (nonatomic,assign) CGFloat              thtMuscleKg;             //!< 肌肉量(kg), 分辨率0.1, 范围10.0 ~ 120.0
@property (nonatomic,copy) NSDictionary*          thtMuscleRatingList;     //!< 肌肉量健康标准 "不足-标准"“标准-优秀”

@property (nonatomic,assign) THTBodyType          ThtBodyType;              //!< 身体类型
@property (nonatomic,assign) NSInteger            ThtBodyScore;             //!< 身体得分，50 ~ 100分
@property (nonatomic,assign) CGFloat              ThtMusclePercentage;      //!< 肌肉率(%),分辨率0.1，范围5%~90%
@property (nonatomic,assign) CGFloat              ThtBodyfatKg;             //!< 脂肪量(kg)

@property (nonatomic,assign) CGFloat              ThtBodystandard;          //!< 标准体重(kg)
@property (nonatomic,assign) CGFloat              ThtBodyLBW;               //!< 去脂体重(kg)
@property (nonatomic,assign) CGFloat              ThtBodyControl;           //!< 控制体重(kg)
@property (nonatomic,assign) CGFloat              ThtBodyControlLiang;      //!< 脂肪控制量(kg)
@property (nonatomic,assign) CGFloat              ThtBodySkeletal;          //!< 骨骼肌率(%)
@property (nonatomic,assign) CGFloat              ThtBodySMuscleControl;    //!< 肌肉控制量(kg)
@property (nonatomic,assign) CGFloat              ThtBodySubcutaneousFat;   //!< 皮下脂肪(%)
@property (nonatomic,assign) CGFloat              ThtBodyProportion;        //!< 腰臀比
@property (nonatomic,assign) THTBodyHealthAssessment   THTBodyHealth;       //!< 健康评估
@property (nonatomic,assign) THTBodyFatGrade      THTFatGrade;              //!< 肥胖等级
@property (nonatomic,assign) THTBodyGrade         THTBodyHealthGrade;       //!< 健康等级

//计算腰臀比
- (void)waist:(CGFloat)waist Hipline:(CGFloat)hipline;

/**
 *  根据人体数据计算体脂参数
 *
 *  @param weightKg   体重，单位kg
 *  @param heightCm   身高，单位cm
 *  @param sex        性别
 *  @param age        年龄
 *  @param impedance  阻抗系数
 *
 *  @return 人体数据是否有误，计算成功则返回HTBodyfatErrorTypeNone
 */
- (THTBodyfatErrorType )getBodyfatWithweightKg:(CGFloat)weightKg heightCm:(CGFloat)heightCm sex:(THTSexType)sex age:(NSInteger)age impedance:(NSInteger)impedance;

@end
