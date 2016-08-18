*setting  the project library to Project2;
libname Project2 '/home/nareshvemula0/Project2';
*Importing the file;

proc import datafile="/home/nareshvemula0/Project2/FermaLogis_Event_Type.csv" 
		out=Project2.FermaLogis dbms=csv replace;
	getnames=YES;
run;

*Creating a column named turnover type using the type column;

data Project2.FermaLogis;
	length turnoverType $25.;
	set Project2.FermaLogis;

	if turnover='Yes' then
		;

	if type=1 then
		turnoverType="Retirement";
	else if type=2 then
		turnoverType="Voluntary Resignation";
	else if type=3 then
		turnoverType="Involuntary Resignation";
	else if type=4 then
		turnoverType="Job Termination";
	else
		turnoverType="No turnover";
run;

*Checking the frequency of occurrence of each type of events;

proc datasets library=project2 memtype=data;
	contents data=FermaLogis;
	run;
	*checking the the frequency of occurence of each type of events;

proc freq data=Project2.FermaLogis;
	where turnoverType ne 'No turnover';
	tables Type /chisq;
run;

*Replacing the NA's in Bonus column;

data project2.fermalogis;
	set project2.fermalogis;
	array bonus _character_;

	do i=1 to dim(bonus);

		if bonus(i)="NA" then
			bonus(i)="0";
	end;
run;

*Data Preprocessing*;

DATA Project2.FermaLogis;
	SET Project2.FermaLogis;

	IF StockOptionLevel>0 then
		stock='Yes';
	else
		stock='No';

	IF Education=3 or Education=4 or Education=5 then
		HigherEducation='Yes';
	Else
		HigherEducation='No';

	IF JobSatisfaction>=3 then
		Satisfied='Yes';
	Else
		Satisfied='No';

	IF JobInvolvement>=3 then
		Involved='Yes';
	Else
		Involved='No';
run;

*Dropping the first two columns and Over18 EmployeeCount EmployeeNumber  in the data set , as they have only the serial numbers
and 0 variance among data*;

DATA Project2.FermaLogis(DROP=','n X Over18 EmployeeCount EmployeeNumber i);
	SET Project2.FermaLogis;
RUN;

*reordering the data to get censored to the begining*;

data Project2.FermaLogis;
	retain turnoverType;
	retain YearsAtCompany;
	set Project2.FermaLogis;
run;

*calculating the cumulative bonus effect;

DATA Project2.bonusFerma;
	SET Project2.fermalogis;
	ARRAY bonus_(*) bonus_1-bonus_40;
	ARRAY cum(*) cum1-cum40;
	cum1=bonus_1;

	DO i=2 TO 40;
		cum(i)=cum(i-1)+bonus_(i);
	END;
run;

*Hazard and Survival Curves rate by stratifying with Stock levels of an employee in fermalogis;
*Retiring employees;

proc lifetest data=project2.fermalogis plots=(S H) method=LIFE;
	TIME YearsAtCompany*Type(0, 2, 3, 4);
	strata stock;
	title "Survival curves of Retirement type with respect to stock";
run;

*Hazard and Survival Curves rate by stratifying with Stock;
*Voluntary Resignation;

proc lifetest data=project2.fermalogis plots=(S H) method=LIFE;
	TIME YearsAtCompany*Type(0, 1, 3, 4);
	strata stock;
	title "Survival curves of Voluntary Resignation type with respect to stock";
run;

*Hazard and Survival Curves rate by stratifying with Stock;
*Involuntary Resignation;

proc lifetest data=project2.fermalogis plots=(S H) method=LIFE;
	TIME YearsAtCompany*Type(0, 1, 2, 4);
	strata stock;
	title "Survival curves of Involuntary Resignation type with respect to stock";
run;

*Hazard and Survival Curves rate by stratifying with Stock;
*Job Termination;

proc lifetest data=project2.fermalogis plots=(S H) method=LIFE;
	TIME YearsAtCompany*Type(0, 1, 2, 3);
	strata stock;
	title "Survival curves of Job Termination type with respect to stock";
run;

*plotting the Business Travel* ;

Proc sgplot data=Project2.FermaLogis;
	vbar TurnoverType /group=BusinessTravel;
	Title 'SGPLOT :Business Travel Analysis';
	where TurnoverType ne 'No turnover';
run;

*plotting to identify Job satisfaction effect on event types* ;

Proc sgplot data=Project2.FermaLogis;
	vbar TurnoverType /group=Satisfied;
	Title 'SGPLOT :Job satisfaction Analysis';
	where TurnoverType ne 'No turnover';
run;

*plotting to identify Overtime effect on event type*;

Proc sgplot data=Project2.FermaLogis;
	vbar TurnoverType /group=Overtime;
	Title 'SGPLOT :Overtime Effect on Turnover types';
	where TurnoverType ne 'No turnover';
run;

*plotting to identify Education effect on event typ ;

Proc sgplot data=Project2.FermaLogis;
	vbar TurnoverType /group=EducationField;
	Title 'SGPLOT :Education Vs Turnover types';
	where TurnoverType ne 'No turnover';
run;

*plotting to identify Gender effect on event typ ;

Proc sgplot data=Project2.FermaLogis;
	vbar TurnoverType /group=Gender;
	Title 'SGPLOT :Gender  Vs Turnover types';
	where TurnoverType ne 'No turnover';
run;

*plotting frequency plot to check gender frequency on event type ;

PROC FREQ DATA=Project2.FermaLogis;
	TABLES Gender*TurnoverType/ CHISQ plots=freqplot;
	TITLE ' Frequnecy Plot: Gender vs Turnover types';
RUN;

*Checking for non proportional variables using assess statement for martingale residuals ;

PROC phreg DATA=Project2.bonusFerma;
	where YearsAtCompany>1;
	class BusinessTravel Department Education EducationField 
		EnvironmentSatisfaction Gender JobInvolvement JobLevel OverTime JobRole 
		JobSatisfaction MaritalStatus PerformanceRating RelationshipSatisfaction 
		StockOptionLevel WorkLifeBalance StockOptionLevel TrainingTimesLastYear 
		WorkLifeBalance stock HigherEducation;
	MODEL YearsAtCompany*Type(0)=Age BusinessTravel EnvironmentSatisfaction 
		JobInvolvement OverTime JobRole JobSatisfaction DistanceFromHome 
		NumCompaniesWorked OverTime TotalWorkingYears YearsInCurrentRole Jobrole 
		stock;
	title PHreg validation model/ties=efron;
	ASSESS PH/resample;
	title PHreg Non Proportional check model;
RUN;

*Checking for time dependent variables/ non proportional with Schoenfeld residuals;

PROC phreg DATA=Project2.bonusFerma;
	where YearsAtCompany>1;
	class BusinessTravel Department Education EducationField 
		EnvironmentSatisfaction Gender JobInvolvement JobLevel OverTime JobRole 
		JobSatisfaction MaritalStatus PerformanceRating RelationshipSatisfaction 
		StockOptionLevel WorkLifeBalance StockOptionLevel WorkLifeBalance stock 
		HigherEducation;
	MODEL YearsAtCompany*Type(0)=BusinessTravel EnvironmentSatisfaction 
		JobInvolvement OverTime JobRole JobSatisfaction DistanceFromHome 
		NumCompaniesWorked OverTime TotalWorkingYears YearsInCurrentRole Jobrole 
		stock trainingtimeslastyear /ties=efron;
	OUTPUT OUT=TimeDependentVariableModel RESSCH=age BusinessTravel 
		EnvironmentSatisfaction JobInvolvement OverTime JobRole JobSatisfaction 
		DistanceFromHome NumCompaniesWorked OverTime TotalWorkingYears 
		YearsInCurrentRole Jobrole stock;
	title PHreg validation model;
RUN;

DATA TimeDependentVariableModel;
	SET TimeDependentVariableModel;
	id=_n_;
RUN;

/*find the correlations with years in thecompany and it's functions */
DATA CorrTimeDependentVariableModel;
	SET TimeDependentVariableModel;
	logYearsAtCompany=log(YearsAtCompany);
	YearsAtCompany2=YearsAtCompany*YearsAtCompany;

PROC CORR data=CorrTimeDependentVariableModel;
	VAR YearsAtCompany logYearsAtCompany YearsAtCompany2;
	WITH DistanceFromHome NumCompaniesWorked TotalWorkingYears YearsInCurrentRole;
RUN;

*Residuals of Number of Companies Worked vs Years At Company;

proc sgplot data=TimeDependentVariableModel;
	scatter x=YearsAtCompany y=NumCompaniesWorked / datalabel=id;
	title residuals of Number of Companies Worked vs Years At Company;
	*Residuals of Total Working Years vs Years At Company;

proc sgplot data=TimeDependentVariableModel;
	scatter x=YearsAtCompany y=TotalWorkingYears / datalabel=id;
	title Total Working Years vs Years At Company;
	*Residuals of Years In Current role vs Years At Company;

proc sgplot data=TimeDependentVariableModel;
	scatter x=YearsAtCompany y=YearsInCurrentRole/ datalabel=id;
	title Years In Current role vs Years At Company;
run;

*adding interactions for non proportional variables using YearsAtCompany ;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel Department Education EducationField 
		EnvironmentSatisfaction Gender JobInvolvement JobLevel OverTime JobRole 
		JobSatisfaction MaritalStatus PerformanceRating RelationshipSatisfaction 
		StockOptionLevel WorkLifeBalance StockOptionLevel TrainingTimesLastYear 
		WorkLifeBalance stock HigherEducation;
	MODEL YearsAtCompany*Type(0)=BusinessTravel EnvironmentSatisfaction 
		JobInvolvement OverTime JobRole JobSatisfaction DistanceFromHome OverTime 
		Jobrole stock EmployBonus TotalWorkingYears YearsInCurrentRole 
		NumCompaniesWorked TimeIntercatWorkingYears TimeIntercatCurrentRole 
		TimeIntercatNumCompaniesWorked trainingtimeslastyear/ties=efron;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	title PHreg interaction model;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;

*Checking number of employees left in each type;

PROC FREQ DATA=Project2.FermaLogis;
	TABLES Type*turnoverType / CHISQ plots=freqplot;
	TITLE 'employees left in each type ';
RUN;

/*Graphically test for linear relation between type hazards*/
DATA Retirement;
	/*create Retirementexit data*/
	SET Project2.FermaLogis;
	event=(Type=1);

	/*this is for censoring out other types, another way to write if statement*/
	turnoverType='Retirement';

DATA VoluntaryResignation;
	/*create Voluntary Resignation exit data*/
	SET Project2.FermaLogis;
	event=(Type=2);

	/*this is for censoring out other types, another way to write if statement*/
	turnoverType='Voluntary Resignation';

DATA InvoluntaryResignation;
	/*create Involuntary Resignation  exit data*/
	SET Project2.FermaLogis;
	event=(Type=3);

	/*this is for censoring out other types, another way to write if statement*/
	turnoverType='Involuntary Resignation';

DATA JobTermination;
	/*create Job Termination  exit data*/
	SET Project2.FermaLogis;
	event=(Type=4);

	/*this is for censoring out other types, another way to write if statement*/
	turnoverType='Job Termination';

Data Project2.combine;
	set Retirement VoluntaryResignation InvoluntaryResignation JobTermination;

	/*Graphically test for linear relation between type hazards*/
PROC LIFETEST DATA=project2.combine method=life PLOTS=(LLS);
	/*LLS plot is requested*/
	TIME YearsAtCompany*event(0);
	STRATA turnoverType /diff=all;
RUN;

*Implementing phreg using programming step for all the turnover types in one model;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel Department Education EducationField 
		EnvironmentSatisfaction Gender JobInvolvement JobLevel OverTime JobRole 
		JobSatisfaction MaritalStatus PerformanceRating RelationshipSatisfaction 
		StockOptionLevel WorkLifeBalance StockOptionLevel WorkLifeBalance stock 
		HigherEducation;
	MODEL YearsAtCompany*Type(0)=BusinessTravel EnvironmentSatisfaction 
		JobInvolvement OverTime JobRole JobSatisfaction DistanceFromHome 
		NumCompaniesWorked OverTime TotalWorkingYears YearsInCurrentRole Jobrole 
		stock EmployBonus TimeIntercatWorkingYears TimeIntercatCurrentRole 
		TimeIntercatNumCompaniesWorked TrainingTimesLastYear/ties=efron;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	title PHreg model;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;

*Implementing phreg using programming step for the type Retirement;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel Department Education EducationField 
		EnvironmentSatisfaction Gender JobInvolvement JobLevel OverTime JobRole 
		JobSatisfaction MaritalStatus PerformanceRating RelationshipSatisfaction 
		StockOptionLevel WorkLifeBalance StockOptionLevel WorkLifeBalance stock 
		HigherEducation;
	MODEL YearsAtCompany*Type(0, 2, 3, 4)=Age BusinessTravel 
		EnvironmentSatisfaction JobInvolvement OverTime JobRole JobSatisfaction 
		DistanceFromHome NumCompaniesWorked OverTime TotalWorkingYears 
		YearsInCurrentRole Jobrole stock EmployBonus TimeIntercatWorkingYears 
		TimeIntercatCurrentRole TimeIntercatNumCompaniesWorked /ties=efron;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	title PHreg Retirement Event Type Model;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;

*Implementing phreg using programming step for the type Voluntary Resignation/ Turnover;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel Department Education EducationField 
		EnvironmentSatisfaction Gender JobInvolvement JobLevel OverTime JobRole 
		JobSatisfaction satisfied MaritalStatus PerformanceRating 
		RelationshipSatisfaction StockOptionLevel WorkLifeBalance StockOptionLevel 
		WorkLifeBalance stock HigherEducation involved;
	MODEL YearsAtCompany*Type(0, 1, 3, 4)=BusinessTravel EnvironmentSatisfaction 
		OverTime satisfied involved DistanceFromHome NumCompaniesWorked OverTime 
		TotalWorkingYears YearsInCurrentRole stock EmployBonus 
		TimeIntercatWorkingYears TimeIntercatCurrentRole TrainingTimesLastYear 
		/ties=efron;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	title PHreg model for Voluntary Resignation/ Turnover;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=cum1;
RUN;

*Implementing phreg using programming step for the type InVoluntary Resignation;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel Department Education EducationField 
		EnvironmentSatisfaction Gender JobInvolvement JobLevel OverTime JobRole 
		JobSatisfaction MaritalStatus PerformanceRating RelationshipSatisfaction 
		StockOptionLevel WorkLifeBalance StockOptionLevel WorkLifeBalance stock 
		HigherEducation satisfied;
	MODEL YearsAtCompany*Type(0, 1, 2, 4)=age BusinessTravel 
		EnvironmentSatisfaction JobInvolvement OverTime JobRole satisfied 
		DistanceFromHome NumCompaniesWorked OverTime TotalWorkingYears 
		YearsInCurrentRole Jobrole stock EmployBonus TimeIntercatWorkingYears 
		TimeIntercatCurrentRole TimeIntercatNumCompaniesWorked TrainingTimesLastYear 
		HigherEducation /ties=efron;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	title PHreg model;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;

*Implementing phreg using programming step for the type Termination;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel Department Education EducationField 
		EnvironmentSatisfaction Gender JobInvolvement JobLevel OverTime JobRole 
		JobSatisfaction MaritalStatus PerformanceRating RelationshipSatisfaction 
		StockOptionLevel WorkLifeBalance StockOptionLevel TrainingTimesLastYear 
		WorkLifeBalance stock HigherEducation;
	MODEL YearsAtCompany*Type(0, 1, 2, 3)=BusinessTravel EnvironmentSatisfaction 
		JobInvolvement OverTime JobRole JobSatisfaction DistanceFromHome OverTime 
		TotalWorkingYears YearsInCurrentRole Jobrole stock EmployBonus 
		TotalWorkingYears TimeIntercatWorkingYears YearsInCurrentRole 
		TimeIntercatCurrentRole NumCompaniesWorked TimeIntercatNumCompaniesWorked 
		/ties=efron;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	title PHreg model;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;

DATA LogRatioTest_PHregTime;
	Nested=2221.764;
	Retirement=128.640;
	VoluntaryResignation=971.656;
	InVoluntaryResignation=499.934;
	Termination=379.974;
	Total=Retirement+ VoluntaryResignation+InVoluntaryResignation+Termination;
	Diff=Nested - Total;
	P_value=1 - probchi(Diff, 66);
	*30-(30+17+30+29coef. in 3 models - 26coef. in nested;
RUN;

PROC PRINT DATA=LogRatioTest_PHregTime;
	FORMAT P_Value 5.3;
	title total nested vs individual hypothesis;
RUN;

*checking involuntry  resignation and job termination;

PROC phreg DATA=Project2.bonusFerma;
	class BusinessTravel Department Education EducationField 
		EnvironmentSatisfaction Gender JobInvolvement JobLevel OverTime JobRole 
		JobSatisfaction MaritalStatus PerformanceRating RelationshipSatisfaction 
		StockOptionLevel WorkLifeBalance StockOptionLevel TrainingTimesLastYear 
		WorkLifeBalance stock HigherEducation satisfied ;
	MODEL YearsAtCompany*Type(0, 1, 2)=BusinessTravel EnvironmentSatisfaction 
		JobInvolvement OverTime JobSatisfaction DistanceFromHome NumCompaniesWorked 
		OverTime TotalWorkingYears YearsInCurrentRole Jobrole stock EmployBonus 
		TimeIntercatWorkingYears TimeIntercatCurrentRole 
		TimeIntercatNumCompaniesWorked /ties=efron;
	TimeIntercatWorkingYears=YearsAtCompany*TotalWorkingYears;
	TimeIntercatCurrentRole=YearsAtCompany*YearsInCurrentRole;
	TimeIntercatNumCompaniesWorked=YearsAtCompany*NumCompaniesWorked;
	title PHreg model for involuntary resignation and job termination;
	ARRAY cum(*) cum1-cum40;

	if YearsAtCompany>1 then
		EmployBonus=cum[YearsAtCompany-1];
	else
		EmployBonus=bonus_1;
RUN;

*checking involuntry  resignation and job termination;

DATA LogRatioTest_PHregIVJT;
	Nested=916.165;
	InVoluntaryResignation=499.944;
	Termination=379.74;
	Total=InVoluntaryResignation+Termination;
	Diff=Nested - Total;
	P_value=1 - probchi(Diff, 30);
	*26*2coef. in 2 models - 26coef. in nested;
RUN;

*checking involuntry  resignation and job termination;

PROC PRINT DATA=LogRatioTest_PHregIVJT;
	FORMAT P_Value 5.3;
	title nested(involuntry, termination) vs individual hypothesis;
RUN;





