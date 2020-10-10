/****************************************************************/
/**********������ �ҷ����� ���� ����, ����ġ ���� �� �����۾�***********/
/****************************************************************/
* ���̺귯�� ����;
libname aa "C:\Users\Cho\Dropbox\�����";
/**/
/*data aa.temp;*/
/*set aa.data;*/
/*if he_bmi =.;*/
/*keep he_bmi bmi bmi_p group;*/
/*run;*/


proc import out=aa.rawdata_csv
datafile="C:\Users\Cho\Dropbox\�����\HN14_ALL.csv"
dbms=csv replace;
getnames=yes;
run;

* raw data ������ ���� ������ ����;
data aa.data;
set aa.rawdata_csv;
run;

data aa.data;
set aa.data;
if HE_BMI ne .;
run;

* ǥ1. BMI������ �̿��� �׷� ���� ���� �� ����ġ ����;
data aa.data;
set aa.data;
if HE_BMI < 18.5 then BMI=1; *��ü�� : BMI=1;
else if HE_BMI <24.9 then BMI=2; *����ü�� : BMI=2;
else if HE_BMI >25.0 then BMI=3; *��ü�� : BMI=3;
if BMI NE .;
run;

* ǥ2. �ְ���ü���ν� �� �׷� ���� ���� �� ����ġ ����;
data aa.data;
set aa.data;
if BO1 < 3  then BMI_p=1; *��ü������ �ν� : BMI_p=1;
else if BO1 < 4 then BMI_p=2; *����ü������ �ν� : BMI_p=2;
else if BO1> 3 then BMI_p=3; *��ü������ �ν� : BMI_p=3;
if BMI_p NE .;
run;

* ǥ3. ���� BMI�� �ְ���ü���ν� �� �׷�ȭ(group=1,2,3,4,5,6,7,8,9);
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

 * age �׷� �� ���� ����(agegroup=1,2,3,4,5,6,7);
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

 * ǥ 4, 5, 7���� ���ش�(8)�� ������(9)�� ���ľ� �ϴ� �͵�;
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



 * ǥ3 ;
proc freq data=aa.data;
tables group * sex;
run;

 * ǥ4, BMI������ ���� ü�� �з�;
proc freq data=aa.data;
tables BMI * sex;
run;

 * ǥ4, �ְ��� ü�� �ν�;
proc freq data=aa.data;
tables BMI_p * sex;
run;

 * ǥ4, ������;
proc freq data=aa.data;
tables agegroup * sex;
run;

 * ǥ4, ��������;
proc freq data=aa.data;
tables edu * sex;
run;

 * ǥ4, ����;
proc freq data=aa.data;
tables region * sex;
run;

 * ǥ4, ��ȥ����;
proc freq data=aa.data;
tables marri_1 * sex;
run;

 * ǥ4, ���� �ҵ� �������;
proc freq data=aa.data;
tables incm * sex;
run;

 * ǥ4, ����Ȱ�� ����;
proc freq data=aa.data;
tables ec1_1*sex;
run;

 * ǥ4, ������ ����;
proc freq data=aa.data;
tables ec_wht_0*sex;
run;

 * ǥ4, ������з� �� �Ǿ�/�����Ȱ�� ���� �ڵ�;
proc freq data=aa.data;
tables occp * sex;
run;

%macro chisq_test(group_a,group_b);
 * ǥ5, �ְ����ǰ�����, ����;
proc freq data=aa.data;
table D_1_1 * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ5, �ְ����ǰ�����,����, group &group_a and group &group_b";
run;

 * ǥ5, �ְ����ǰ�����, ����;
proc freq data=aa.data;
table D_1_1 * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ5, �ְ����ǰ�����,����, group &group_a and group &group_b";
run;

 * ǥ5, ��ɷ�, ����;
proc freq data=aa.data;
table lq_1eql * group/ chisq;   ******************;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ5, ��ɷ�,����, group &group_a and group &group_b";
run;

 * ǥ5, ��ɷ�, ����;
proc freq data=aa.data;
table lq_1eql * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ5, ��ɷ�,����, group &group_a and group &group_b";
run;

 * ǥ5, �ڱ����, ����;
proc freq data=aa.data;
table lq_2eql * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ5, �ڱ����, ����, group &group_a and group &group_b";
run;

 * ǥ5, �ڱ����, ����;
proc freq data=aa.data;
table lq_2eql * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ5, �ڱ����, ����, group &group_a and group &group_b";
run;

 * ǥ5, �ϻ�Ȱ��, ����;
proc freq data=aa.data;
table lq_3eql * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ5, �ϻ�Ȱ��,����, group &group_a and group &group_b";
run;

 * ǥ5, �ϻ�Ȱ��, ����;
proc freq data=aa.data;
table lq_3eql * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ5, �ϻ�Ȱ��,����, group &group_a and group &group_b";
run;

 * ǥ5, ����/����, ����;
proc freq data=aa.data;
table lq_4eql * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ5, ����/����,����, group &group_a and group &group_b";
run;

 * ǥ5, ����/����, ����;
proc freq data=aa.data;
table lq_4eql * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ5, ����/����,����, group &group_a and group &group_b";
run;

 * ǥ5, �Ҿ�/���, ����;
proc freq data=aa.data;
table lq_5eql * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ5, �Ҿ�/���,����, group &group_a and group &group_b";
run;

 * ǥ5, �Ҿ�/���, ����;
proc freq data=aa.data;
table lq_5eql * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ5, �Ҿ�/���,����, group &group_a and group &group_b";
run;

 * ǥ5, 1�Ⱓ ü�� ���� ����, ����;
proc freq data=aa.data;
table Bo2_1 * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ5, 1�Ⱓ ü�� ���� ����,����, group &group_a and group &group_b";
run;

 * ǥ5, 1�Ⱓ ü�� ���� ����, ����;
proc freq data=aa.data;
table Bo2_1 * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ5, 1�Ⱓ ü�� ���� ����,����, group &group_a and group &group_b";
run;

 * ǥ5, 1�Ⱓ ���� ��, ����;
proc freq data=aa.data;
table BD1_11 * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ5, 1�Ⱓ ���� ��,����, group &group_a and group &group_b";
run;

 * ǥ5, 1�Ⱓ ���� ��, ����;
proc freq data=aa.data;
table BD1_11 * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ5, 1�Ⱓ ���� ��,����, group &group_a and group &group_b";
run;

 * ǥ5, ����� ����, ����;
proc freq data=aa.data;
table BS3_1 * group/ chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ5, ����� ����,����, group &group_a and group &group_b";
run;

 * ǥ5, ����� ����, ����;
proc freq data=aa.data;
table BS3_1 * group/ chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ5, ����� ����,����, group &group_a and group &group_b";
run;

 * ǥ6, ��� ��Ʈ���� ��������, ����;
proc freq data=aa.data;
table bp1 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ6, ��� ��Ʈ���� ��������,����, group &group_a and group &group_b";
run;

 * ǥ6, ��� ��Ʈ���� ��������, ����;
proc freq data=aa.data;
table bp1 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ6, ��� ��Ʈ���� ��������,����, group &group_a and group &group_b";
run;

 * ǥ6, 2���̻� ���� ��ﰨ ����, ����;
proc freq data=aa.data;
table bp5 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ6, 2���̻� ���� ��ﰨ ����,����, group &group_a and group &group_b";
run;

 * ǥ6, 2���̻� ���� ��ﰨ ����, ����;
proc freq data=aa.data;
table bp5 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ6, 2���̻� ���� ��ﰨ ����,����, group &group_a and group &group_b";
run;

 * ǥ6, 1�Ⱓ ���Ź��� ���, ����;
proc freq data=aa.data;
table bp7 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ6, 1�Ⱓ ���Ź��� ���,����, group &group_a and group &group_b";
run;

 * ǥ6, 1�Ⱓ ���Ź��� ���, ����;
proc freq data=aa.data;
table bp7 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ6, 1�Ⱓ ���Ź��� ���,����, group &group_a and group &group_b";
run;

 * ǥ6, 1�Ⱓ �ڻ� ���� ����, ����;
proc freq data=aa.data;
table bp6_10 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ6, 1�Ⱓ �ڻ� ���� ����,����, group &group_a and group &group_b";
run;

 * ǥ6, 1�Ⱓ �ڻ� ���� ����, ����;
proc freq data=aa.data;
table bp6_10 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ6, 1�Ⱓ �ڻ� ���� ����,����, group &group_a and group &group_b";
run;

 * ǥ6, 1�Ⱓ �ڻ� ��ȹ ����, ����;
proc freq data=aa.data;
table bp6_2 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ6, 1�Ⱓ �ڻ� ��ȹ ����, ����, group &group_a and group &group_b";
run;

 * ǥ6, 1�Ⱓ �ڻ� ��ȹ ����, ����;
proc freq data=aa.data;
table bp6_2 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ6, 1�Ⱓ �ڻ� ��ȹ ����, ����, group &group_a and group &group_b";
run;

 * ǥ6, 1�Ⱓ �ڻ� �õ� ����, ����;
proc freq data=aa.data;
table bp6_31 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ6, 1�Ⱓ �ڻ� �õ� ����,����, group &group_a and group &group_b";
run;

 * ǥ6, 1�Ⱓ �ڻ� �õ� ����, ����;
proc freq data=aa.data;
table bp6_31 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ6, 1�Ⱓ �ڻ� �õ� ����,����, group &group_a and group &group_b";
run;

 * ǥ6, ��Ʈ���� ������, ����;
proc freq data=aa.data;
table mh_stress * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ6, ��Ʈ���� ������,����, group &group_a and group &group_b";
run;

 * ǥ6, ��Ʈ���� ������, ����;
proc freq data=aa.data;
table mh_stress * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ6, ��Ʈ���� ������,����, group &group_a and group &group_b";
run;

 * ǥ6, ������� �����, ����;
proc freq data=aa.data;
table mh_melan * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ6, ������� �����, ����, group &group_a and group &group_b";
run;

 * ǥ6, ������� �����, ����;
proc freq data=aa.data;
table mh_melan * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ6, ������� �����, ����, group &group_a and group &group_b";
run;

 * ǥ6, �ڻ� ������, ����;
proc freq data=aa.data;
table mh_suicide * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ6, �ڻ� ������, ����, group &group_a and group &group_b";
run;

 * ǥ6, �ڻ� ������, ����;
proc freq data=aa.data;
table mh_suicide * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ6, �ڻ� ������, ����, group &group_a and group &group_b";
run;

 * ǥ7, ���� �ϴ� �Ϳ� ���� ��̳� ��̰� ���� ����, ����;
proc freq data=aa.data;
table bp_phq_1 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ7, ���� �ϴ� �Ϳ� ���� ��̳� ��̰� ���� ����,����, group &group_a and group &group_b";
run;

 * ǥ7, ���� �ϴ� �Ϳ� ���� ��̳� ��̰� ���� ����, ����;
proc freq data=aa.data;
table bp_phq_1 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ7, ���� �ϴ� �Ϳ� ���� ��̳� ��̰� ���� ����,����, group &group_a and group &group_b";
run;

 * ǥ7, ������� ����, ��ﰨ Ȥ�� ������, ����;
proc freq data=aa.data;
table bp_phq_2 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "ǥ7, ������� ����, ��ﰨ Ȥ�� ������,����, group &group_a and group &group_b";
run;

 * ǥ7, ������� ����, ��ﰨ Ȥ�� ������, ����;
proc freq data=aa.data;
table bp_phq_2 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "ǥ7, ������� ����, ��ﰨ Ȥ�� ������,����, group &group_a and group &group_b";
run;

 * ǥ7, ���� ��ưų� �ڲ� ���, Ȥ�� �ʹ� ���� ��, ����;
proc freq data=aa.data;
table bp_phq_3 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "���� ��ưų� �ڲ� ���, Ȥ�� �ʹ� ���� ��,����, group &group_a and group &group_b";
run;

 * ǥ7, ���� ��ưų� �ڲ� ���, Ȥ�� �ʹ� ���� ��, ����;
proc freq data=aa.data;
table bp_phq_3 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "���� ��ưų� �ڲ� ���, Ȥ�� �ʹ� ���� ��,����, group &group_a and group &group_b";
run;

 * ǥ7, �ǰﰨ, ����� ���ϵ�, ����;
proc freq data=aa.data;
table bp_phq_4 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "�ǰﰨ, ����� ���ϵ�,����, group &group_a and group &group_b";
run;

 * ǥ7, �ǰﰨ, ����� ���ϵ�, ����;
proc freq data=aa.data;
table bp_phq_4 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "�ǰﰨ, ����� ���ϵ�,����, group &group_a and group &group_b";
run;

 * ǥ7, �Ŀ� ���� Ȥ�� ����, ����;
proc freq data=aa.data;
table bp_phq_5 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "�Ŀ� ���� Ȥ�� ����,����, group &group_a and group &group_b";
run;

 * ǥ7, �Ŀ� ���� Ȥ�� ����, ����;
proc freq data=aa.data;
table bp_phq_5 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "�Ŀ� ���� Ȥ�� ����,����, group &group_a and group &group_b";
run;

 * ǥ7, �� �ڽ��� ���� ����̶�� ����....., ����;
proc freq data=aa.data;
table bp_phq_6 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "�� �ڽ��� ���� ����̶�� ����.....,����, group &group_a and group &group_b";
run;

 * ǥ7, �� �ڽ��� ���� ����̶�� ����....., ����;
proc freq data=aa.data;
table bp_phq_6 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "�� �ڽ��� ���� ����̶�� ����.....,����, group &group_a and group &group_b";
run;

 * ǥ7, �Ź��� �аų� TV�� �� �� ....., ����;
proc freq data=aa.data;
table bp_phq_7 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "�Ź��� �аų� TV�� �� �� .....,����, group &group_a and group &group_b";
run;

 * ǥ7, �Ź��� �аų� TV�� �� �� ....., ����;
proc freq data=aa.data;
table bp_phq_7 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "�Ź��� �аų� TV�� �� �� .....,����, group &group_a and group &group_b";
run;

 * ǥ7, ������ �˾�ç ������ �ŵ��̳� ���� ����....., ����;
proc freq data=aa.data;
table bp_phq_8 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "������ �˾�ç ������ �ŵ��̳� ���� ����.....,����, group &group_a and group &group_b";
run;

 * ǥ7, ������ �˾�ç ������ �ŵ��̳� ���� ����....., ����;
proc freq data=aa.data;
table bp_phq_8 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "������ �˾�ç ������ �ŵ��̳� ���� ����.....,����, group &group_a and group &group_b";
run;

 * ǥ7, ���� ���� �״� ���� ���ڴٴ�........, ����;
proc freq data=aa.data;
table bp_phq_9 * group / chisq exact;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "���� ���� �״� ���� ���ڴٴ�........, ����, group &group_a and group &group_b";
run;

 * ǥ7, ���� ���� �״� ���� ���ڴٴ�........, ����;
proc freq data=aa.data;
table bp_phq_9 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "���� ���� �״� ���� ���ڴٴ�........, ����, group &group_a and group &group_b";
run;

 * ǥ7, �̷��� ���� ������ �湮, ��ȭ, ���ͳ��� ����......., ����;
proc freq data=aa.data;
table bp_phq_10 * group / chisq;
where (group=&group_a and sex=1) or (group=&group_b and sex=1);
title "�̷��� ���� ������ �湮, ��ȭ, ���ͳ��� ����.......,����, group &group_a and group &group_b";
run;

 * ǥ7, �̷��� ���� ������ �湮, ��ȭ, ���ͳ��� ����......., ����;
proc freq data=aa.data;
table bp_phq_10 * group / chisq;
where (group=&group_a and sex=2) or (group=&group_b and sex=2);
title "�̷��� ���� ������ �湮, ��ȭ, ���ͳ��� ����.......,����, group &group_a and group &group_b";
run;
%mend;
%chisq_test(1,2);

 * ǥ8 ~ ǥ10;
%chisq_test(1,3);

 * ǥ11 ~ ǥ13;
%chisq_test(4,5);

 * ǥ14 ~ ǥ16;
%chisq_test(4,6);

 * ǥ17 ~ ǥ19;
%chisq_test(7,8);

* ǥ20 ~ ǥ22;
%chisq_test(7,9);





	
/*proc logistic data=aa.data;*/
/*class bp1 bp5 bp7 bp6_10 bp6_2 bp6_31 mh_stress;*/
/*model group = bp8 bp1 bp5 bp7 bp6_10 bp6_2 bp6_31 mh_stress bd1_11 bs3_1;     * bd1_11 = ���� // bs3_1 = ��;*/
/*where (group=1 and sex=1) or (group=2 and sex=1);*/
/*run;   *group 1 = 1, group 2=0���� �ڵ�;*/


 /***ǥ23~ǥ28�� Model1 ��ũ��***/
%macro logistic_model1(group_a,group_b,sex);
   * �Ϸ� ��� ����ð�;
proc logistic data=aa.data;
model group = bp8 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "�Ϸ� ��� ����ð� group &group_a, &group_b, ����=&sex";
run;

   * ��� ��Ʈ���� ���� ����;
proc logistic data=aa.data;
class bp1 / param=ref;
model group = bp1 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "��� ��Ʈ���� ���� ���� group &group_a, &group_b, ����=&sex";
run;

   * 2���̻� ���� ��ﰨ ����;
proc logistic data=aa.data;
class bp5 / param=ref;
model group = bp5 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "2�� ���� ��ﰨ ���� group &group_a, &group_b, ����=&sex";
run;

   * 1�Ⱓ ���Ź��� ���;
proc logistic data=aa.data;
class bp7 / param=ref;
model group = bp7 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1�Ⱓ ���Ź��� ��� group &group_a, &group_b, ����=&sex";
run;

   * 1�Ⱓ �ڻ� ���� ����;
proc logistic data=aa.data;
class bp6_10 / param=ref;
model group = bp6_10 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1�Ⱓ �ڻ� ���� ���� group &group_a, &group_b, ����=&sex";
run;

   * 1�Ⱓ �ڻ� ��ȹ ����;
proc logistic data=aa.data;
class bp6_2 / param=ref;
model group = bp6_2 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1�Ⱓ �ڻ� ��ȹ ���� group &group_a, &group_b, ����=&sex";
run;

   * 1�Ⱓ �ڻ� �õ� ����;
proc logistic data=aa.data;
class bp6_31 / param=ref;
model group = bp6_31 bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1�Ⱓ �ڻ� ��ȹ ���� group &group_a, &group_b, ����=&sex";
run;

   * ��Ʈ���� ������;
proc logistic data=aa.data;
class mh_stress / param=ref;
model group = mh_stress bd1_11 bs3_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "��Ʈ���� ������ group &group_a, &group_b, ����=&sex";
run;
 /*********************************/
%mend;


 /***ǥ23~ǥ28�� Model2 ��ũ��***/
%macro logistic_model2(group_a,group_b,sex);
   * �Ϸ� ��� ����ð�;
proc logistic data=aa.data;
model group = bp8 bd1_11 bs3_1 LQ_3EQL d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "�Ϸ� ��� ����ð� group &group_a, &group_b, ����=&sex";
run;

   * ��� ��Ʈ���� ���� ����;
proc logistic data=aa.data;
class bp1 / param=ref;
model group = bp1 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "��� ��Ʈ���� ���� ���� group &group_a, &group_b, ����=&sex";
run;

   * 2���̻� ���� ��ﰨ ����;
proc logistic data=aa.data;
class bp5 / param=ref;
model group = bp5 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "2�� ���� ��ﰨ ���� group &group_a, &group_b, ����=&sex";
run;

   * 1�Ⱓ ���Ź��� ���;
proc logistic data=aa.data;
class bp7 / param=ref;
model group = bp7 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1�Ⱓ ���Ź��� ��� group &group_a, &group_b, ����=&sex";
run;

   * 1�Ⱓ �ڻ� ���� ����;
proc logistic data=aa.data;
class bp6_10 / param=ref;
model group = bp6_10 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1�Ⱓ �ڻ� ���� ���� group &group_a, &group_b, ����=&sex";
run;

   * 1�Ⱓ �ڻ� ��ȹ ����;
proc logistic data=aa.data;
class bp6_2 / param=ref;
model group = bp6_2 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1�Ⱓ �ڻ� ��ȹ ���� group &group_a, &group_b, ����=&sex";
run;

   * 1�Ⱓ �ڻ� �õ� ����;
proc logistic data=aa.data;
class bp6_31 / param=ref;
model group = bp6_31 bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "1�Ⱓ �ڻ� ��ȹ ���� group &group_a, &group_b, ����=&sex";
run;

   * ��Ʈ���� ������;
proc logistic data=aa.data;
class mh_stress / param=ref;
model group = mh_stress bd1_11 bs3_1 LQ_3EQL bp8 d_1_1 bp1;
where (group=&group_a and sex=&sex) or (group=&group_b and sex=&sex);
title "��Ʈ���� ������ group &group_a, &group_b, ����=&sex";
run;
 /*********************************/
%mend;


* ǥ23 model1, ����, group 1= 1, group 2 = 0;
%logistic_model1(1,2,1)

* ǥ23 model1, ����, group 1= 1, group 2 = 0;
%logistic_model1(1,2,2)

* ǥ23 model2, ����, group 1= 1, group 2 = 0;
%logistic_model2(1,2,1)

* ǥ23 model2, ����, group 1= 1, group 2 = 0;
%logistic_model2(1,2,2)





* ǥ24 model1, ����, group 1= 1, group 3 = 0;
%logistic_model1(1,3,1)

* ǥ24 model1, ����, group 1= 1, group 3 = 0;
%logistic_model1(1,3,2)

* ǥ24 model2, ����, group 1= 1, group 3 = 0;
%logistic_model2(1,3,1)

* ǥ24 model2, ����, group 1= 1, group 3 = 0;
%logistic_model2(1,3,2)






* ǥ25 model1, ����, group 4= 1, group 5 = 0;
%logistic_model1(4,5,1)

* ǥ25 model1, ����, group 4= 1, group 5 = 0;
%logistic_model1(4,5,2)

* ǥ25 model2, ����, group 4= 1, group 5 = 0;
%logistic_model2(4,5,1)

* ǥ25 model2, ����, group 4= 1, group 5 = 0;
%logistic_model2(4,5,2)






* ǥ26 model1, ����, group 4= 1, group 6 = 0;
%logistic_model1(4,6,1)

* ǥ26 model1, ����, group 4= 1, group 6 = 0;
%logistic_model1(4,6,2)

* ǥ26 model2, ����, group 4= 1, group 6 = 0;
%logistic_model2(4,6,1)

* ǥ26 model2, ����, group 4= 1, group 6 = 0;
%logistic_model2(4,6,2)





* ǥ27 model1, ����, group 7= 1, group 8 = 0;
%logistic_model1(7,8,1)

* ǥ27 model1, ����, group 7= 1, group 8 = 0;
%logistic_model1(7,8,2)

* ǥ27 model2, ����, group 7= 1, group 8 = 0;
%logistic_model2(7,8,1)

* ǥ27 model2, ����, group 7= 1, group 8 = 0;
%logistic_model2(7,8,2)





* ǥ28 model1, ����, group 7= 1, group 9 = 0;
%logistic_model1(7,9,1)

* ǥ28 model1, ����, group 7= 1, group 9 = 0;
%logistic_model1(7,9,2)

* ǥ28 model2, ����, group 7= 1, group 9 = 0;
%logistic_model2(7,9,1)

* ǥ28 model2, ����, group 7= 1, group 9 = 0;
%logistic_model2(7,9,2)
