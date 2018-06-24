#时间：2018年6月24日
#作者：王师禹
#
#

library(foreign)
library(dplyr)
library(plyr)
#library(car)
library(stringr)
rm(list = ls())

#拼接数据函数
CombineData=function(src){
  
  urban.person=read.dta(src$person[1],warn.missing.labels = F)
  urban.income=read.dta(src$income[1],warn.missing.labels = F)
  rural.person=read.dta(src$person[2],warn.missing.labels = F)
  rural.income=read.dta(src$income[2],warn.missing.labels = F)
  migrant.person=read.dta(src$person[3])
  migrant.income=read.dta(src$income[3])
  
  names.m=names(migrant.person)
  names.u=names(urban.person)
  names.r=names(rural.person)
  
  #因为在个人信息这个部分每个调查区域的数据维度是不一样的，我们取其中的交集
  names.share=intersect(names.u,names.m)
  names.share=intersect(names.share,names.r)
  #拼接数据选项
  option=c('hhcode'='hhcode')
  
  
  urban.person=urban.person[names.share]
  rural.person=rural.person[names.share]
  migrant.person=migrant.person[names.share]
  
  
  
  #对不同的数据来源进行编码，一遍将所有的数据进行合并
  rural.person$type=1
  urban.person$type=2
  migrant.person$type=3
  
  #拼接数据
  urban.info=left_join(urban.person,urban.income,by=option)
  
  rural.info=left_join(rural.person,rural.income,by=option)
  
  migrant.info=left_join(migrant.person,migrant.income,by=option)
  
  
  all.info=rbind(urban.info,rural.info)
  all.info=rbind(all.info,migrant.info)
  #all.info$date=date
  return(all.info)
}

sourcelink=list(person=c('/media/shiyu/文件/deepin备份/Documents/劳动经济/data/CHIP/2013年/CHIP2013_urban_person.dta','/media/shiyu/文件/deepin备份/Documents/劳动经济/data/CHIP/2013年/CHIP2013_rural_person.dta','/media/shiyu/文件/deepin备份/Documents/劳动经济/data/CHIP/2013年/CHIP2013_migrant_person.dta'),
         income=c('/media/shiyu/文件/deepin备份/Documents/劳动经济/data/CHIP/2013年/CHIP2013_urban_household_f_income_asset.dta','/media/shiyu/文件/deepin备份/Documents/劳动经济/data/CHIP/2013年/CHIP2013_rural_household_f_income_asset.dta','/media/shiyu/文件/deepin备份/Documents/劳动经济/data/CHIP/2013年/CHIP2013_migrant_household_f_income_asset.dta'))

#这里的收入都是家庭的收入

CHIP.2013=CombineData(src=sourcelink)

save(CHIP.2013)

