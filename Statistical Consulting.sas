/****************************************************************/
/**********데이터 불러오기 변수 생성, 결측치 제거 등 사전작업***********/
/****************************************************************/
* 라이브러리 지정;
libname aa "C:\Users\Cho\Dropbox\통계상담";
/**/
/*data aa.temp;*/
/*set aa.data;*/
/*if he_bmi =.;*/
/*keep he_bmi bmi bmi_p group;*/
/*run;*/


proc import out=aa.rawdata_csv
datafile="C:\Users\Cho\Dropbox\통계상담\HN14_ALL.csv"
dbms=csv replace;
getnames=yes;
run;

* raw data 보존을 위한 데이터 복사;
data aa.data;
set aa.rawdata_csv;
run;

data aa.data;
set aa.data;
if HE_BMI ne .;
run;

* 표1. BMI지수를 이용한 그룹 변수 생성 및 결측치 제거;
data aa.data;
set aa.data;
if HE_BMI < 18.5 then BMI=1; *저체중 : BMI=1;
else if HE_BMI <24.9 then BMI=2; *정상체중 : BMI=2;
else if HE_BMI >25.0 then BMI=3; *비만체중 : BMI=3;
if BMI NE .;
run;

* 표2. 주관적체형인식 별 그룹 변수 생성 및 결측치 제거;
data aa.data;
set aa.data;
if BO1 < 3  then BMI_p=1; *저체중으로 인식 : BMI_p=1;
else if BO1 < 4 then BMI_p=2; *정상체중으로 인식 : BMI_p=2;
else if BO1> 3 then BMI_p=3; *비만체중으로 인식 : BMI_p=3;
if BMI_p NE .;
run;

* 표3. 실제 BMI와 주관적체형인식 별 그룹화(group=1,2,3,4,5,6,7,8,9);
data aa.data;
set aa.data;
if BMI=1 and BMI_p=1 then group=1;
else if BMI=1 and BMI_p=2 then group=2;
else if BMI=1 and BMI_p=3 then group=3;
else if BMI=2 and BMI_p=2 then group=4;
else if BMI=2 and BMI_p=1 then group=5;
else if BMI=2 and BMI_p=3 then group=6;
else if BMI=3 and BMI_p=3 then group=7;
else if BMI=3 and BMI_p=1 then group=8;
else if BMI=3 and BMI_p=2 then group=9;
run;

 * age 그룹 별 변수 생성(agegroup=1,2,3,4,5,6,7);
data aa.data;
set aa.data;
if age<20 then agegroup=1;
else if age<30 then agegroup=2;
else if age<40 then agegroup=3;
else if age<50 then agegroup=4;
else if age<60 then agegroup=5;
else if age<70 then agegroup=6;
else if age>=70 then agegroup=7;
run;

 * 표 4, 5, 7에서 비해당(8)과 무응답(9)을 합쳐야 하는 것들;
data aa.data;
set aa.data;
if ec1_1=8 then ec1_1=9;
if ec_wht_0=8 then ec_wht_0=9;
if bd1_11=8 then bd1_11=9;
if bs3_1=8 then bs3_1=9;
if bp_phq_1=8 then bp_phq_1=9;
if bp_phq_2=8 then bp_phq_2=9;
if bp_phq_3=8 then bp_phq_3=9;
if bp_phq_4=8 then bp_phq_4=9;
if bp_phq_5=8 then bp_phq_5=9;
if bp_phq_6=8 then bp_phq_6=9;
if bp_phq_7=8 then bp_phq_7=9;
if bp_phq_8=8 then bp_phq_8=9;
if bp_phq_9=8 then bp_phq_9=9;
if bp_phq_10=8 then bp_phq_10=9;
run;





/****************************************************************/
/****************************************************************/
/****************************************************************/



 * 표3 ;
proc freq data=aa.data;
tables group * sex;
run;

 * 표4, BMI지수에 따른 체형 분류;
proc freq data=aa.data;
tables BMI * sex;
run;

 * 표4, 주관적 체형 인식;
proc freq data=aa.data;
tables BMI_p * sex;
run;

 * 표4, 만나이;
proc freq data=aa.data;
tables agegroup * sex;
run;

 * 표4, 교육수준;
proc freq data=aa.data;
tables edu * sex;
run;

 * 표4, 지역;
proc freq data=aa.data;
tables region * sex;
run;

 * 표4, 결혼여부;
proc freq data=aa.data;
tables marri_1 * sex;
run;

 * 표4, 개인 소득 사분위수;
proc freq data=aa.data;
tables incm * sex;
run;

 * 표4, 경제활동 상태;
proc freq data=aa.data;
tables ec1_1*sex;
run;

 * 표4, 정규직 여부;
proc freq data=aa.data;
tables ec_wht_0*sex;
run;

 * 표4, 직업재분류 및 실업/비경제활동 상태 코드;
proc freq data=aa.data;
tables occp * sex;
run;

%macro chisq_test(group_a,group_b);
 * 표5, 주관적건강상태, 남자;
proc freq data=aa.data;
table D_1_1 * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표5, 주관적건강상태,남자, group &group_a and group &group_b";
run;

 * 표5, 주관적건강상태, 여자;
proc freq data=aa.data;
table D_1_1 * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표5, 주관적건강상태,여자, group &group_a and group &group_b";
run;

 * 표5, 운동능력, 남자;
proc freq data=aa.data;
table lq_1eql * group/ chisq;   ******************;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표5, 운동능력,남자, group &group_a and group &group_b";
run;

 * 표5, 운동능력, 여자;
proc freq data=aa.data;
table lq_1eql * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표5, 운동능력,여자, group &group_a and group &group_b";
run;

 * 표5, 자기관리, 남자;
proc freq data=aa.data;
table lq_2eql * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표5, 자기관리, 남자, group &group_a and group &group_b";
run;

 * 표5, 자기관리, 여자;
proc freq data=aa.data;
table lq_2eql * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표5, 자기관리, 여자, group &group_a and group &group_b";
run;

 * 표5, 일상활동, 남자;
proc freq data=aa.data;
table lq_3eql * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표5, 일상활동,남자, group &group_a and group &group_b";
run;

 * 표5, 일상활동, 여자;
proc freq data=aa.data;
table lq_3eql * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표5, 일상활동,여자, group &group_a and group &group_b";
run;

 * 표5, 통증/불편, 남자;
proc freq data=aa.data;
table lq_4eql * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표5, 통증/불편,남자, group &group_a and group &group_b";
run;

 * 표5, 통증/불편, 여자;
proc freq data=aa.data;
table lq_4eql * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표5, 통증/불편,여자, group &group_a and group &group_b";
run;

 * 표5, 불안/우울, 남자;
proc freq data=aa.data;
table lq_5eql * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표5, 불안/우울,남자, group &group_a and group &group_b";
run;

 * 표5, 불안/우울, 여자;
proc freq data=aa.data;
table lq_5eql * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표5, 불안/우울,여자, group &group_a and group &group_b";
run;

 * 표5, 1년간 체중 조절 여부, 남자;
proc freq data=aa.data;
table Bo2_1 * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표5, 1년간 체중 조절 여부,남자, group &group_a and group &group_b";
run;

 * 표5, 1년간 체중 조절 여부, 여자;
proc freq data=aa.data;
table Bo2_1 * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표5, 1년간 체중 조절 여부,여자, group &group_a and group &group_b";
run;

 * 표5, 1년간 음주 빈도, 남자;
proc freq data=aa.data;
table BD1_11 * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표5, 1년간 음주 빈도,남자, group &group_a and group &group_b";
run;

 * 표5, 1년간 음주 빈도, 여자;
proc freq data=aa.data;
table BD1_11 * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표5, 1년간 음주 빈도,여자, group &group_a and group &group_b";
run;

 * 표5, 평생흡연 여부, 남자;
proc freq data=aa.data;
table BS3_1 * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표5, 평생흡연 여부,남자, group &group_a and group &group_b";
run;

 * 표5, 평생흡연 여부, 여자;
proc freq data=aa.data;
table BS3_1 * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표5, 평생흡연 여부,여자, group &group_a and group &group_b";
run;

 * 표6, 평균 스트레스 인지정도, 남자;
proc freq data=aa.data;
table bp1 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표6, 평균 스트레스 인지정도,남자, group &group_a and group &group_b";
run;

 * 표6, 평균 스트레스 인지정도, 여자;
proc freq data=aa.data;
table bp1 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표6, 평균 스트레스 인지정도,여자, group &group_a and group &group_b";
run;

 * 표6, 2주이상 연속 우울감 여부, 남자;
proc freq data=aa.data;
table bp5 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표6, 2주이상 연속 우울감 여부,남자, group &group_a and group &group_b";
run;

 * 표6, 2주이상 연속 우울감 여부, 여자;
proc freq data=aa.data;
table bp5 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표6, 2주이상 연속 우울감 여부,여자, group &group_a and group &group_b";
run;

 * 표6, 1년간 정신문제 상담, 남자;
proc freq data=aa.data;
table bp7 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표6, 1년간 정신문제 상담,남자, group &group_a and group &group_b";
run;

 * 표6, 1년간 정신문제 상담, 여자;
proc freq data=aa.data;
table bp7 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표6, 1년간 정신문제 상담,여자, group &group_a and group &group_b";
run;

 * 표6, 1년간 자살 생각 여부, 남자;
proc freq data=aa.data;
table bp6_10 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표6, 1년간 자살 생각 여부,남자, group &group_a and group &group_b";
run;

 * 표6, 1년간 자살 생각 여부, 여자;
proc freq data=aa.data;
table bp6_10 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표6, 1년간 자살 생각 여부,여자, group &group_a and group &group_b";
run;

 * 표6, 1년간 자살 계획 여부, 남자;
proc freq data=aa.data;
table bp6_2 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표6, 1년간 자살 계획 여부, 남자, group &group_a and group &group_b";
run;

 * 표6, 1년간 자살 계획 여부, 여자;
proc freq data=aa.data;
table bp6_2 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표6, 1년간 자살 계획 여부, 여자, group &group_a and group &group_b";
run;

 * 표6, 1년간 자살 시도 여부, 남자;
proc freq data=aa.data;
table bp6_31 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표6, 1년간 자살 시도 여부,남자, group &group_a and group &group_b";
run;

 * 표6, 1년간 자살 시도 여부, 여자;
proc freq data=aa.data;
table bp6_31 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표6, 1년간 자살 시도 여부,여자, group &group_a and group &group_b";
run;

 * 표6, 스트레스 인지율, 남자;
proc freq data=aa.data;
table mh_stress * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표6, 스트레스 인지율,남자, group &group_a and group &group_b";
run;

 * 표6, 스트레스 인지율, 여자;
proc freq data=aa.data;
table mh_stress * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표6, 스트레스 인지율,여자, group &group_a and group &group_b";
run;

 * 표6, 우울증상 경험률, 남자;
proc freq data=aa.data;
table mh_melan * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표6, 우울증상 경험률, 남자, group &group_a and group &group_b";
run;

 * 표6, 우울증상 경험률, 여자;
proc freq data=aa.data;
table mh_melan * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표6, 우울증상 경험률, 여자, group &group_a and group &group_b";
run;

 * 표6, 자살 생각률, 남자;
proc freq data=aa.data;
table mh_suicide * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표6, 자살 생각률, 남자, group &group_a and group &group_b";
run;

 * 표6, 자살 생각률, 여자;
proc freq data=aa.data;
table mh_suicide * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표6, 자살 생각률, 여자, group &group_a and group &group_b";
run;

 * 표7, 일을 하는 것에 대한 흥미나 재미가 거의 없음, 남자;
proc freq data=aa.data;
table bp_phq_1 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표7, 일을 하는 것에 대한 흥미나 재미가 거의 없음,남자, group &group_a and group &group_b";
run;

 * 표7, 일을 하는 것에 대한 흥미나 재미가 거의 없음, 여자;
proc freq data=aa.data;
table bp_phq_1 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표7, 일을 하는 것에 대한 흥미나 재미가 거의 없음,여자, group &group_a and group &group_b";
run;

 * 표7, 가라앉은 느낌, 우울감 혹은 절망감, 남자;
proc freq data=aa.data;
table bp_phq_2 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "표7, 가라앉은 느낌, 우울감 혹은 절망감,남자, group &group_a and group &group_b";
run;

 * 표7, 가라앉은 느낌, 우울감 혹은 절망감, 여자;
proc freq data=aa.data;
table bp_phq_2 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "표7, 가라앉은 느낌, 우울감 혹은 절망감,여자, group &group_a and group &group_b";
run;

 * 표7, 잠들기 어렵거나 자꾸 깨어남, 혹은 너무 많이 잠, 남자;
proc freq data=aa.data;
table bp_phq_3 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "잠들기 어렵거나 자꾸 깨어남, 혹은 너무 많이 잠,남자, group &group_a and group &group_b";
run;

 * 표7, 잠들기 어렵거나 자꾸 깨어남, 혹은 너무 많이 잠, 여자;
proc freq data=aa.data;
table bp_phq_3 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "잠들기 어렵거나 자꾸 깨어남, 혹은 너무 많이 잠,여자, group &group_a and group &group_b";
run;

 * 표7, 피곤감, 기력이 저하됨, 남자;
proc freq data=aa.data;
table bp_phq_4 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "피곤감, 기력이 저하됨,남자, group &group_a and group &group_b";
run;

 * 표7, 피곤감, 기력이 저하됨, 여자;
proc freq data=aa.data;
table bp_phq_4 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "피곤감, 기력이 저하됨,여자, group &group_a and group &group_b";
run;

 * 표7, 식욕 저하 혹은 과식, 남자;
proc freq data=aa.data;
table bp_phq_5 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "식욕 저하 혹은 과식,남자, group &group_a and group &group_b";
run;

 * 표7, 식욕 저하 혹은 과식, 여자;
proc freq data=aa.data;
table bp_phq_5 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "식욕 저하 혹은 과식,여자, group &group_a and group &group_b";
run;

 * 표7, 내 자신이 나쁜 사람이라는 느낌....., 남자;
proc freq data=aa.data;
table bp_phq_6 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "내 자신이 나쁜 사람이라는 느낌.....,남자, group &group_a and group &group_b";
run;

 * 표7, 내 자신이 나쁜 사람이라는 느낌....., 여자;
proc freq data=aa.data;
table bp_phq_6 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "내 자신이 나쁜 사람이라는 느낌.....,여자, group &group_a and group &group_b";
run;

 * 표7, 신문을 읽거나 TV를 볼 때 ....., 남자;
proc freq data=aa.data;
table bp_phq_7 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "신문을 읽거나 TV를 볼 때 .....,남자, group &group_a and group &group_b";
run;

 * 표7, 신문을 읽거나 TV를 볼 때 ....., 여자;
proc freq data=aa.data;
table bp_phq_7 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "신문을 읽거나 TV를 볼 때 .....,여자, group &group_a and group &group_b";
run;

 * 표7, 남들이 알아챌 정도로 거동이나 말이 느림....., 남자;
proc freq data=aa.data;
table bp_phq_8 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "남들이 알아챌 정도로 거동이나 말이 느림.....,남자, group &group_a and group &group_b";
run;

 * 표7, 남들이 알아챌 정도로 거동이나 말이 느림....., 여자;
proc freq data=aa.data;
table bp_phq_8 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "남들이 알아챌 정도로 거동이나 말이 느림.....,여자, group &group_a and group &group_b";
run;

 * 표7, 나는 차라리 죽는 것이 낫겠다는........, 남자;
proc freq data=aa.data;
table bp_phq_9 * group / chisq exact;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "나는 차라리 죽는 것이 낫겠다는........, 남자, group &group_a and group &group_b";
run;

 * 표7, 나는 차라리 죽는 것이 낫겠다는........, 여자;
proc freq data=aa.data;
table bp_phq_9 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "나는 차라리 죽는 것이 낫겠다는........, 여자, group &group_a and group &group_b";
run;

 * 표7, 이러한 문제 때문에 방문, 전화, 인터넷을 통해......., 남자;
proc freq data=aa.data;
table bp_phq_10 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "이러한 문제 때문에 방문, 전화, 인터넷을 통해.......,남자, group &group_a and group &group_b";
run;

 * 표7, 이러한 문제 때문에 방문, 전화, 인터넷을 통해......., 여자;
proc freq data=aa.data;
table bp_phq_10 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "이러한 문제 때문에 방문, 전화, 인터넷을 통해.......,여자, group &group_a and group &group_b";
run;
%mend;
%chisq_test(1,2);

 * 표8 ~ 표10;
%chisq_test(1,3);

 * 표11 ~ 표13;
%chisq_test(4,5);

 * 표14 ~ 표16;
%chisq_test(4,6);

 * 표17 ~ 표19;
%chisq_test(7,8);

* 표20 ~ 표22;
%chisq_test(7,9);





	
/*proc logistic data=aa.data;*/
/*class bp1 bp5 bp7 bp6_10 bp6_2 bp6_31 mh_stress;*/
/*model group = bp8 bp1 bp5 bp7 bp6_10 bp6_2 bp6_31 mh_stress bd1_11 bs3_1;     * bd1_11 = 음주 // bs3_1 = 흡연;*/
/*where (group=1 and sex=1) or (group=2 and sex=1);*/
/*run;   *group 1 = 1, group 2=0으로 코딩;*/


 /***표23~표28의 Model1 매크로***/
%macro logistic_model1(group_a,group_b,sex);
   * 하루 평균 수면시간;
proc logistic data=aa.data;
model group = bp8 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "하루 평균 수면시간 group &group_a, &group_b, 성별=&sex";
run;

   * 평균 스트레스 인지 정도;
proc logistic data=aa.data;
class bp1 / param=ref;
model group = bp1 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "평균 스트레스 인지 정도 group &group_a, &group_b, 성별=&sex";
run;

   * 2주이상 연속 우울감 여부;
proc logistic data=aa.data;
class bp5 / param=ref;
model group = bp5 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "2주 연속 우울감 여부 group &group_a, &group_b, 성별=&sex";
run;

   * 1년간 정신문제 상담;
proc logistic data=aa.data;
class bp7 / param=ref;
model group = bp7 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1년간 정신문제 상담 group &group_a, &group_b, 성별=&sex";
run;

   * 1년간 자살 생각 여부;
proc logistic data=aa.data;
class bp6_10 / param=ref;
model group = bp6_10 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1년간 자살 생각 여부 group &group_a, &group_b, 성별=&sex";
run;

   * 1년간 자살 계획 여부;
proc logistic data=aa.data;
class bp6_2 / param=ref;
model group = bp6_2 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1년간 자살 계획 여부 group &group_a, &group_b, 성별=&sex";
run;

   * 1년간 자살 시도 여부;
proc logistic data=aa.data;
class bp6_31 / param=ref;
model group = bp6_31 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1년간 자살 계획 여부 group &group_a, &group_b, 성별=&sex";
run;

   * 스트레스 인지율;
proc logistic data=aa.data;
class mh_stress / param=ref;
model group = mh_stress bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "스트레스 인지율 group &group_a, &group_b, 성별=&sex";
run;
 /*********************************/
%mend;


 /***표23~표28의 Model2 매크로***/
%macro logistic_model2(group_a,group_b,sex);
   * 하루 평균 수면시간;
proc logistic data=aa.data;
model group = bp8 bd1_11 bs3_1 LQ_3EQL d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "하루 평균 수면시간 group &group_a, &group_b, 성별=&sex";
run;

   * 평균 스트레스 인지 정도;
proc logistic data=aa.data;
class bp1 / param=ref;
model group = bp1 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "평균 스트레스 인지 정도 group &group_a, &group_b, 성별=&sex";
run;

   * 2주이상 연속 우울감 여부;
proc logistic data=aa.data;
class bp5 / param=ref;
model group = bp5 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "2주 연속 우울감 여부 group &group_a, &group_b, 성별=&sex";
run;

   * 1년간 정신문제 상담;
proc logistic data=aa.data;
class bp7 / param=ref;
model group = bp7 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1년간 정신문제 상담 group &group_a, &group_b, 성별=&sex";
run;

   * 1년간 자살 생각 여부;
proc logistic data=aa.data;
class bp6_10 / param=ref;
model group = bp6_10 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1년간 자살 생각 여부 group &group_a, &group_b, 성별=&sex";
run;

   * 1년간 자살 계획 여부;
proc logistic data=aa.data;
class bp6_2 / param=ref;
model group = bp6_2 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1년간 자살 계획 여부 group &group_a, &group_b, 성별=&sex";
run;

   * 1년간 자살 시도 여부;
proc logistic data=aa.data;
class bp6_31 / param=ref;
model group = bp6_31 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1년간 자살 계획 여부 group &group_a, &group_b, 성별=&sex";
run;

   * 스트레스 인지율;
proc logistic data=aa.data;
class mh_stress / param=ref;
model group = mh_stress bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "스트레스 인지율 group &group_a, &group_b, 성별=&sex";
run;
 /*********************************/
%mend;


* 표23 model1, 남자, group 1= 1, group 2 = 0;
%logistic_model1(1,2,1)

* 표23 model1, 여자, group 1= 1, group 2 = 0;
%logistic_model1(1,2,2)

* 표23 model2, 남자, group 1= 1, group 2 = 0;
%logistic_model2(1,2,1)

* 표23 model2, 여자, group 1= 1, group 2 = 0;
%logistic_model2(1,2,2)





* 표24 model1, 남자, group 1= 1, group 3 = 0;
%logistic_model1(1,3,1)

* 표24 model1, 여자, group 1= 1, group 3 = 0;
%logistic_model1(1,3,2)

* 표24 model2, 남자, group 1= 1, group 3 = 0;
%logistic_model2(1,3,1)

* 표24 model2, 여자, group 1= 1, group 3 = 0;
%logistic_model2(1,3,2)






* 표25 model1, 남자, group 4= 1, group 5 = 0;
%logistic_model1(4,5,1)

* 표25 model1, 여자, group 4= 1, group 5 = 0;
%logistic_model1(4,5,2)

* 표25 model2, 남자, group 4= 1, group 5 = 0;
%logistic_model2(4,5,1)

* 표25 model2, 여자, group 4= 1, group 5 = 0;
%logistic_model2(4,5,2)






* 표26 model1, 남자, group 4= 1, group 6 = 0;
%logistic_model1(4,6,1)

* 표26 model1, 여자, group 4= 1, group 6 = 0;
%logistic_model1(4,6,2)

* 표26 model2, 남자, group 4= 1, group 6 = 0;
%logistic_model2(4,6,1)

* 표26 model2, 여자, group 4= 1, group 6 = 0;
%logistic_model2(4,6,2)





* 표27 model1, 남자, group 7= 1, group 8 = 0;
%logistic_model1(7,8,1)

* 표27 model1, 여자, group 7= 1, group 8 = 0;
%logistic_model1(7,8,2)

* 표27 model2, 남자, group 7= 1, group 8 = 0;
%logistic_model2(7,8,1)

* 표27 model2, 여자, group 7= 1, group 8 = 0;
%logistic_model2(7,8,2)





* 표28 model1, 남자, group 7= 1, group 9 = 0;
%logistic_model1(7,9,1)

* 표28 model1, 여자, group 7= 1, group 9 = 0;
%logistic_model1(7,9,2)

* 표28 model2, 남자, group 7= 1, group 9 = 0;
%logistic_model2(7,9,1)

* 표28 model2, 여자, group 7= 1, group 9 = 0;
%logistic_model2(7,9,2)
