//
//  HTBodyfat_NewSDK.m
//  HTBodyfatLibDemo
//
//  Created by 乐福衡器 on 2017/12/22.
//  Copyright © 2017年 Holtek. All rights reserved.
//

#import "HTBodyfat_NewSDK.h"
#import "HTBodyfat_SDK.h"
#define kDifference 5.0f

@interface HTBodyfat_NewSDK()

@end

@implementation HTBodyfat_NewSDK
//计算腰臀比
- (void)waist:(CGFloat)waist Hipline:(CGFloat)hipline
{
    self.ThtBodyProportion = waist/hipline;
}
//计算返回各项参数
- (THTBodyfatErrorType )getBodyfatWithweightKg:(CGFloat)weightKg heightCm:(CGFloat)heightCm sex:(THTSexType)sex age:(NSInteger)age impedance:(NSInteger)impedance
{
     HTPeopleGeneral *peopleModel = [[HTPeopleGeneral alloc]init];
    
    HTSexType tsex = (HTSexType)sex;
    
    CGFloat TheightCm = heightCm / 100;
    
    HTBodyfatErrorType errorType = [peopleModel getBodyfatWithweightKg:weightKg heightCm:heightCm sex:tsex age:age impedance:impedance];
    //重新赋值
    self.thtSex = sex;
    self.thtHeightCm = heightCm;
    self.thtWeightKg = weightKg;
    self.thtAge = age;
    self.thtZTwoLegs = impedance;
    self.thtproteinPercentage = peopleModel.htproteinPercentage;
    self.thtproteinRatingList = [peopleModel.htproteinRatingList copy];
    self.thtBodyAge = peopleModel.htBodyAge;
    self.thtIdealWeightKg = peopleModel.htIdealWeightKg;
    self.thtBMI = peopleModel.htBMI;
    if (self.thtBMI <= 10.0) {
        self.thtBMI = weightKg / powf((heightCm/100.0), 2);
    }
    self.thtBMIRatingList = peopleModel.htBMIRatingList;
    self.thtBMR = peopleModel.htBMR;
    self.thtBMRRatingList = peopleModel.htBMRRatingList;
    self.thtVFAL = peopleModel.htVFAL;
    self.thtVFALRatingList = peopleModel.htVFALRatingList;
    self.thtBoneKg = peopleModel.htBoneKg;
    self.thtBoneRatingList = peopleModel.htBoneRatingList;
    self.thtBodyfatPercentage = peopleModel.htBodyfatPercentage - kDifference < 5.0 ? 5.0:peopleModel.htBodyfatPercentage - kDifference;
    self.thtBodyfatRatingList = peopleModel.htBodyfatRatingList;
    self.thtWaterPercentage = peopleModel.htWaterPercentage;
    self.thtWaterRatingList = peopleModel.htWaterRatingList;
    self.thtMuscleKg = peopleModel.htMuscleKg;
    self.thtMuscleRatingList = peopleModel.htMuscleRatingList;
    self.ThtBodyType = (THTBodyType) peopleModel.htBodyType;
//    NSLog(@"self.ThtBodyType===%ld",self.ThtBodyType);
    
    self.ThtBodyScore = peopleModel.htBodyScore;
    self.ThtMusclePercentage = peopleModel.htMusclePercentage;
    self.ThtBodyfatKg = (peopleModel.htBodyfatPercentage - kDifference < 5.0 ? 5.0:peopleModel.htBodyfatPercentage - kDifference) *0.01 * weightKg;
    
    //标准体重
    self.ThtBodystandard = 21.75 * TheightCm * TheightCm;
    //去脂体重
    self.ThtBodyLBW = weightKg - self.ThtBodyfatKg;
    //控制体重
    self.ThtBodyControl = weightKg - self.ThtBodystandard;
    //皮下脂肪
    self.ThtBodySubcutaneousFat = (peopleModel.htBodyfatPercentage - kDifference < 5.0 ? 5.0:peopleModel.htBodyfatPercentage - kDifference) * 2 / 3;
    if (peopleModel.htBodyfatKg != 0) {
//        float BodyMuscleControl;//肌肉控制量
        float StandMuscle;//标准肌肉
        //脂肪控制量
        self.ThtBodyControlLiang = [self htBodyfatKg:self.ThtBodyfatKg sex:sex Bmi:peopleModel.htBMI age:age];
        //骨骼肌率
        //!< 肌肉控制量(kg)
        if (sex == THTSexTypeFemale)//女性
        {
            self.ThtBodySkeletal = self.ThtBodyLBW * 0.54 / weightKg;
            
            StandMuscle = self.ThtBodystandard * 0.724;
            self.ThtBodySMuscleControl = StandMuscle - peopleModel.htMuscleKg;
            if (self.ThtBodySMuscleControl < 0) {
                self.ThtBodySMuscleControl = 0;
            }
            
        }else
        {
            self.ThtBodySkeletal = self.ThtBodyLBW * 0.56 / weightKg;
            StandMuscle = self.ThtBodystandard * 0.797;
            self.ThtBodySMuscleControl = StandMuscle - peopleModel.htMuscleKg;
            if (self.ThtBodySMuscleControl < 0) {
                self.ThtBodySMuscleControl = 0;
            }
        }
    }
    //健康评估
    self.THTBodyHealth = [self HealthScore:peopleModel.htBodyScore];
    //肥胖等级
    self.THTFatGrade = [self BodyFatGrade:peopleModel.htBMI];
    //健康等级
    self.THTBodyHealthGrade = [self BodyGrade:peopleModel.htBMI];
    
    switch(errorType){
        case HTBodyfatErrorTypeNone:
            return THTBodyfatErrorTypeNone;
            break;
        case HTBodyfatErrorTypeImpedance:
//            [self ShowMsg:@"阻抗系数有误！"];
            return THTBodyfatErrorTypeImpedance;
            break;
        case HTBodyfatErrorTypeAge:
//            [self ShowMsg:@"年龄参数有误！"];
            return THTBodyfatErrorTypeAge;
            break;
        case HTBodyfatErrorTypeHeight:
//            [self ShowMsg:@"身高参数有误！"];
            return THTBodyfatErrorTypeHeight;
            break;
        case HTBodyfatErrorTypeWeight:
//            [self ShowMsg:@"体重参数有误！"];
            return THTBodyfatErrorTypeWeight;
            break;
        default:
//            [self ShowMsg:@"未知错误！"];
            return 10;
            break;
    }
    
    
}
//脂肪控制量
- (CGFloat)htBodyfatKg:(CGFloat)ThtBodyfatKg sex:(THTSexType)sex Bmi:(CGFloat)bmi age:(NSInteger)Age
{
    float BodyFatControl;//身体脂肪控制量
    //女性
    if (sex == THTSexTypeFemale)
    {
        float B0 = 67.2037;
        float B1 = 0.6351;
        float B2 = -2.6706;
        float B3 = -18.1146;
        float B4 = -0.2374;
        if(bmi <= 21)
        {
            if(ThtBodyfatKg < 10.5 )
                return 10.2 - ThtBodyfatKg;
            else
                return 0;
        }
         BodyFatControl = B0 + B1 * Age + B2 * bmi + B3 * Age / bmi + B4 * bmi * bmi / Age;
        
    }else
    {
        float B0 = 24.1589;
        float B1 = -0.6282;
        float B2 = -0.5865;
        float B3 = 9.8772;
        float B4 = -0.368;
        if(bmi <= 22.5)
        {
            if(ThtBodyfatKg < 8.5 )
                return 9 - ThtBodyfatKg;
            else
                return 0;
        }
        BodyFatControl = B0 + B1 * Age + B2 * bmi + B3 * Age / bmi + B4 * bmi * bmi / Age;
    }
    
    return BodyFatControl;
}
//健康评估
- (THTBodyHealthAssessment) HealthScore:(NSInteger)htBodyScore
{
    if (htBodyScore <= 0) {
        htBodyScore = 10;
    }
    if (0 < htBodyScore && htBodyScore <= 60) {
        return THTBodyAssessment1;
    }else if ( 60 < htBodyScore && htBodyScore <=70)
    {
        return THTBodyAssessment2;
    }else if ( 70 < htBodyScore && htBodyScore <= 80)
    {
        return THTBodyAssessment3;
    }else if (80 < htBodyScore && htBodyScore <= 90)
    {
        return THTBodyAssessment4;
    }else
    {
        return THTBodyAssessment5;
    }
}
//肥胖等级
- (THTBodyFatGrade)BodyFatGrade :(CGFloat)bmi
{
    if (30 <= bmi && bmi < 35) {
        return THTBodyGradeFatOne;
    }else if (35 <= bmi && bmi < 40)
    {
        return THTBodyGradeLFatTwo;
    }else if (40 <= bmi && bmi < 90)
    {
        return THTBodyGradeFatThree;
    }else
    {
        return THTBodyGradeFatFour;
    }
}
//健康等级
- (THTBodyGrade)BodyGrade :(CGFloat)bmi
{
    if (0 <= bmi && bmi < 18.5) {
        return THTBodyGradeThin;
    }else if (18.6 <= bmi && bmi < 24.9)
    {
        return THTBodyGradeLThinMuscle;
    }else if (25 <= bmi && bmi < 29.9)
    {
        return THTBodyGradeMuscular;
    }else if (30 <= bmi && bmi < 90)
    {
        return THTBodyGradeLackofexercise;
    }else
    {
        return THTBodyGradeError;
    }
}

- (NSInteger)thtBodyAge{

    NSInteger physicAge = 0;
    NSInteger age = _thtBodyAge;
    CGFloat bmi = self.thtBMI;
    if (bmi < 22) {
        CGFloat temp = (age - 5) + ((22 - bmi) * (5 / (22 - 18.5f)));
            if (fabs(temp - age) >= 5) {
           physicAge = age + 5;
        } else {
           physicAge = temp;
        }
    } else if (bmi == 22) {
        physicAge = age - 5;
    } else if (bmi > 22) {
        float temp = (age - 5) + ((bmi - 22) * (5 / (24.9f - 22)));
        if (fabs(temp - age) >= 8) {
           physicAge = age + 8;
        } else {
           physicAge = temp;
        }
    }
    return physicAge;

}

@end

