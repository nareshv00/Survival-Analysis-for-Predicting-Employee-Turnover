# Survival-Analysis-for-Predicting-Employee-Turnover
##Executive Summary 

Employee Churn is a major problem for many firms these days. If a company does not have satisfied employees, it will not have satisfied customers and there could be possibility of not having satisfied shareholders as well. Great talent is scarce and in high demand in this competitive era and it is very hard to keep the great talent within the same organization. Apparently, it becomes utmost important to understand the drivers of employee dissatisfaction. Fermalogis, a pharmaceutical company are also facing the issue of employee turnover and in order to understand the drivers of employee dissatisfaction, the team have received the data from them to do the survival analysis which is one of the core strategic tool to understand the drivers of employee dissatisfaction.

To start with, our team have used SAS studio to analyze the data of 1470 employees having 77 different variables to not only identify the number or percentage of workers who leave an organization due to different attrition types such as Involuntary, Termination, Voluntary and Retirement but also the factors causing attrition. The team has built different models using Proportional Hazards based on Cox’s partial likelihood estimate method to estimate regression models with censored data and to investigate the time to event data. Cox's semiparametric modeling allows for no assumptions to be made about the parametric distribution of the survival times, making the method considerably more robust and helped us in identifying some variables which has non proportional effect on hazard such as NumCompaniesWorked, TotalWorkingYears, YearsInCurrentRole. After model evaluation, the team has identified that all the event types are independent of each other and need to be handled separately so team has decided to employ competing risks to analyze the different types of turnover. With this analysis, the team can enable Fermalogis to identify the key factors for voluntary resignation which is the main concern for the company and preemptively address costly departures.

##Business Problem
  
Recently, Fermalogis found that their rival companies are recruiting the trained employees of Fermalogis with high transfer fees and higher salaries which has created a threat of losing the talent from their organization. COO - Larry Hansen wanted to know who are leaving their company and why they are leaving so that they can take the necessary measures to prevent their employees from leaving. They have elaborated the data in basically two groups:

###Young employees:
The team are investing a lot on the new employees in terms of professional training and salary without return for the first three years. Only after three years, company started getting benefit from that new employee. But, at that time, they become more competent professionally and seek new career opportunities with higher salary and leave the company. 

###Experienced employees:
Company has an Executive Training Program. It is a very intense and useful program. Every year, experienced employees (with the company for 5 years or more) are sent to a training center. They gain a lot and they become even more competent each year.

To analyze the situation further, HR Department wants to examine the data based on different attrition types rather than considering the turnover as same because each types might have different properties and seems to handled separately. Different attrition types provided are –

**Involuntary Resignation** – Employment decision to terminate the employees because of health problems or family problems etc.

**Voluntary Resignation** -  When an employee leaves the company of her own volition, it's called voluntary termination.

**Retirement** -  Retirement is the point in time when an employee chooses to leave his or her employment permanently.

**Job termination** - When an employee fired from the company because of poor performance, excessive absenteeism or violation of a workplace policy.

##Data Overview

Initially, the team has received the data of Fermalogis’ employee’s attrition which contains 76 variables with 1470 observations. But later on Fermalogis has decided to give an extra property of different turnover types. Dataset contain the variable “Turnover” which indicates whether a particular employee has churned but due to different event types, team has decided to consider “Type” as our target variable. Dataset has different explanatory variables such as how long the employee has been in the company, what are their performance ratings and salary hike; which has helped us to hazards related to the important factors affecting turnover and building the best model. Then, some of the important surveys conducted by the organization helped us find the survival analysis of employees such as:
 
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773579/26f35b52-651d-11e6-84f8-a57189c46a17.png)

Figure-1 Environmental satisfaction Survey                                                         

![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773577/26eb421e-651d-11e6-853e-d1c9a776cd08.png)

Figure-2 Relationship Satisfaction Survey                                                                     

![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773576/26eaf00c-651d-11e6-9fbe-ba503578bc66.png)

Figure-3 Job Involvement Survey        

##Data Pre-Processing

In order to analyze the different event types, team has created a variable “turnover type” which contains the description of event types, which means if Turnover is “Yes” then only some event will occur and what Type can be determined by 1,2,3,4 values in type column.
    
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773578/26ecdc46-651d-11e6-952f-1bfca6ae6e77.png)

Figure-4   -Different Turnover Types   

else Turnover will have a value No stating an employee is not leaving from the organization. 

Team has created a new variable ‘Stock’ to determine the stock option for the employee depending on variable StockOptionLevel. If StockOptionLevel has a value greater than zero, the employee owns stocks of the company else the employee doesn’t have any stocks.

In order to find the impact of education on employee attrition, the team has created a new variable ‘Higher Education’, which is set to ‘Yes’ if the employees have attended Bachelors, Masters and Doctors else to ‘No’.

Created a variable ‘Satisfied’ when the job satisfaction levels are greater than 2 else ‘No’ for this variable.

Created a variable Involved as ‘Yes’ when the job Involvement levels are greater than 2 else ‘No’ for Involved.

Finally, the team has found that two initial columns contained the serial numbers which are not significant for this analysis. Similarly, employee count and employee number do not contribute any relevant information. So, the team has deleted these columns in this dataset.
	
##Methodology


In Survival Analysis, primary focus is on finding the time to the event. In general, time to event is the time period in which a specific event will take place. As per the data provided, ‘Years at Company’ which contained the tenure in Fermalogis data defined the time at which the event of interest will occur, which is when employees might leave the organization and what are the important factors contributing to their decisions. In reality, survival data is not fully observed, rather, it is surveyed for some period and the results are gathered. If the event happens in that particular time period, it is marked as a failure event, else it is marked as censored (data fully not observed). Censoring is present when there is partial information about a subject’s event time, but the exact event time is unknown. In our case, the employees with turnover Type 1,2,3,4 as failed employees and turnover Type with ‘0’ are censored employees.


Our team has decided to use COX’s Proportional Hazards Model to perform regression analysis of survival data. Another attractive feature of Cox regression is not having to choose the density function of a parametric distribution. This means that Cox's semiparametric modeling allows for no assumptions to be made about the parametric distribution of the survival times, making the method considerably robust.


The Cox model has the flexibility to introduce time dependent explanatory variables and it uses partial likelihood function. This concept is important in our study as well as to find the variables which are affecting the hazards of attrition non proportionally over the years and these needed to be identified so that they might be handled properly. Fermalogis dataset contains 1470 observations with 40 years’ data, however, we found that our data is heavily tied for the years (0,1,2,3,4,5), this lead us to use EFRON method. This method suits our dataset perfectly as we have heavily tied data and a small dataset.
We have used LIFETEST method to know if there is difference in the survival curves of turnover Types and what these differences look like graphically. This procedure will produce survival function estimates and plot them, as well as give the Wilcoxon and Log Rank statistics for testing the equality of the survival function estimates of the two or more different types.


##Data Exploration

To view the most relevant features of the dataset, the team has used data exploration in survival analysis using SGPLOT, MOSAICPLOT, FREQPLOT which provide the statistical analysis, significant information and correlation among variables.

**Distribution of event type**: Team has decided to plot the distribution of different event types to identify the event type corresponding to maximum number of employees leaving the company and found that all event types are in different proportion with respect to employees and maximum number of employees belongs to Voluntary resignation event type.
 
 
 ![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773583/26f94bfc-651d-11e6-920c-d07c89f75749.png)
 
 Figure-5 Distribution of Different event types
 
   
**Business Travel Vs Turnover Types**: Below graph has been plotted to identify the relation between variables turnover types and Business Travel and found that in all the four event type - Involuntary, Job Termination, Resignation and Voluntary retirement, people who are travelling frequently are more prone to leave the company.
 
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773575/26eaa232-651d-11e6-99f9-054dd7890344.png)

Figure-6 Business Travel Vs Turnover Types                              
                                                              
**Stock Vs Turnover Types** -We have created a stock variable to check the effect of this covariate on different turnover types and have plotted their respective survival curves.

**Retirement**  -(-2Log(LR)) test shows that P-values for the employees having stock and not having stocks is not significant which means survival probability for retired employees is independent of stock variable and is almost same for both employees having the stocks and not having the stocks.
   
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773580/26f3bb10-651d-11e6-907a-0a05700ee227.png)

Figure-7 P value of stocks on Retirement                                                           

![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773581/26f41baa-651d-11e6-8db5-36ea28a4e97b.png)

Figure-8 Survival curves of Retirement w.r.t stock

**Involuntary resignation** - It has a significant difference between people who are holding stocks and people does not, People who holds stock might not want to leave the company, one possibility is when they have health or personal issues they might take leave and get well come back to the organization. Motivating people towards holding stocks can actually reduce this type of turnover.
     
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773586/26fc49ce-651d-11e6-9b8c-584a3470cfbb.png)

Figure-9 P value test of stocks on Involuntary Resignation                                                           

![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773582/26f6d82c-651d-11e6-829d-6a0de9293c3b.png)

Figure-10 Survival curves of Involuntary resignation w.r.t stock


**Job termination** - Team observed that job termination is also affected by employees holding stocks in the company up to 25 years’ tenure at the company & later there is no significant difference between two groups of people having stocks and not stock holders.
          
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773582/26f6d82c-651d-11e6-829d-6a0de9293c3b.png)
   
Figure-11 P value test of stocks on Job Termination

![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773587/26fedcb6-651d-11e6-8539-9df90a2711d3.png)

Figure-12 Survival curves of Job termination w.r.t stock


**Voluntary Resignation** -Employees have a flat survival curve when they hold stocks in the company which explains they are not the ones who are leaving the company. However, people without stocks have a decaying survival rate and mostly they are leaving. Management can look into this aspect to mitigate this risk.  We can observe that there is a significant difference between the equality among these two groups of employees. Motivating people towards holding stocks can actually reduce this type of turnover.
       
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773584/26fa6064-651d-11e6-9c7f-1098c37262d0.png)
  
Figure-13 P value test of stocks on Voluntary Resignation
 
 ![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773589/270102b6-651d-11e6-815b-300fddbbdb89.png)

Figure-14 Survival curves of Voluntary resignation w.r.t stock  

**Job satisfaction Vs Turnover Type** – Team has created a variable “Satisfied” and plotted SGPLOT to check the effect of job satisfaction. employees who are not satisfied are leaving more among voluntary resignation type. this might be one of the reason causing employees to leave the company. However, in all the other three types majority of people are satisfied with their jobs though they are leaving the company.
 
  ![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773588/270043da-651d-11e6-839f-fd22ca667d9f.png)

 Figure-15 Satisfied Vs Turnover Types

Education Field Vs Turnover Type – Team found that education field is also affecting the attrition rate as in all the event types, employees belongs to Life Sciences and medical field are more prone to leave the company in comparison to other education fields.
 
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773592/2705f08c-651d-11e6-85e3-28ad8aa92f18.png)

Figure-16 Education Field Vs Turnover Types

**Overtime Vs Turnover Type** – Overtime shows whether an employee works overtime more than 10 hours a week. By plotting Overtime Vs Turnover types, team found that employees who are doing more overtime are resigning the company in three types (voluntary, Involuntary, Retirement) and those who are not doing overtime, they are getting terminated from the company. There seems a possibility of overtime as one of the performance attribute for the company which is causing work pressure on Voluntary Retired employees and poor performance attribute towards Job terminated employees.

![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773590/27034fbc-651d-11e6-8762-d35125e4b0ab.png)

Figure-17 Overtime Vs Turnover Types
    
**Gender Vs Turnover Type** –  Gender is always considered an important variable in understanding the development of a turnover decision. To test this fact, we have plotted Gender Vs Turnover type and found that men has greater rates of actual turnover than women in each event type but might be it is because the proportion of females is less in comparison to men.
            
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773591/27058782-651d-11e6-9462-f40ca3aab049.png)

Figure-18 Gender Vs Turnover Types

To check the above made observation, we have plotted frequency table plot and found that males are more in number in comparison to females that might be the reason males are leaving more in comparison to females and turnover is independent of Gender.
        
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773596/2709ad44-651d-11e6-846b-40ac46b43b2b.png)

Figure-19 Frequency table for Gender Vs Turnover Types                        


**Hazards for event type together or Separately**– Whenever a dataset is characterized by several event types, which can be analyzed and interpreted in different ways, it is needed to decide whether we should have considered all the events types together or handle them separately. For this our team decided to go with competing risks in survival analysis which distinguishes between different types of events and when that type of event is taken into account, the other types are accepted as censored.


Looking at the below Proc FREQ results of all event types, we can say that they are not same for all event types. There is total of 225 employees out of 1470 employees in Fermalogis are leaving the company because of Retirement (Type 0), Voluntary (Type 1), Involuntary (Type 3) and Job Termination (Type 4) and all are attiring at different frequencies so all these event types are different. On further analysis, we can say that employees leaving the company voluntarily is 47%(105/225) of the other employees leaving the company due to retirement, job termination and Involuntary and has become a concern for the company.
 
 ![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773594/2708f61a-651d-11e6-8471-ce146f82463c.png)

Figure-20 Frequency plot for different turnover Types  
                                       
To check whether hazards for all event types are linearly related with each other, our team has tested each event type individually, we have created one variable called event which has censored the other types and then team has combined all the event types to check whether they are linearly related with each other based on Log-log Survival plot(LLS) which is used for Weibull using PROC LIFETEST DATA and also helps in understanding the shape of the hazard function.”Diff = all” in PROC LIFETEST combine event method is used to compare all the strata of  different turnover types.


By looking at the p-values of Wilcoxon test, we can say that all event types are significant and different from each other except Involuntary Resignation and Job termination because these two event types are not significant and there seems a possibility of combining these two event types. 
 
![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773593/2708b6fa-651d-11e6-8c23-7456b6676de3.png)

 Figure-21  p-value comparison between different event type


To prove the above statement, we have plotted the Survival estimates which also shows that employees who are falling under the event of Involuntary resignation and Job Termination are linearly proportional and there seems a possibility that these events can be handled together.

 ![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773595/27099714-651d-11e6-9613-25f1a11aed97.png)

  Figure-22 Survival estimates for different turnover Types  


To add to the above point, our team has plotted LLS graphs for all 4 event types -Involuntary, Job termination, Retirement and Voluntary Resignation and graph seem that ω values are same for Involuntary and Terminated employees. But to check the possibility of using both event types together, our team has decided to apply PHREG model for each event type and combined event type
 
  ![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773597/270b1f30-651d-11e6-93a6-079180c7d7a0.png)

 Figure-23 LLS plot for different turnover Types  


Modelling using PHREG for each event type shows the value for Nested event type as 2221.764, Retirement is 128.64, Voluntary Resignation is 971.656, Involuntary as 499.934 and termination as 379.974
 
 ![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773600/270f0e88-651d-11e6-8342-32b383aec7c9.png)

 Figure-24 Model comparison for combine 4 event types  

Null Hypothesis states that “combined all event types have the same effect on turnover of employees as Individual event type”. But looking at the p-value which is equal to 0, will reject the null hypothesis and this proves the fact that we need to build an independent model for each event type.
 
![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773603/2713d3be-651d-11e6-8469-160248972b7b.png)

Figure-25 Null Hypothesis test for combine 4 event types

But our team found that Involuntary resignation and Job termination are linearly related so we have built the combine model for these two events and found that p-value is 0.256 which signify that these two models are similar and can be built together.
 
![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773598/270e7fb8-651d-11e6-9b47-899ab8ba09ad.png)

Figure-26 Model comparison for combine 2 event types  (Involuntary & termination)
 
![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773599/270eba28-651d-11e6-9737-96e257b58c62.png)

Figure-27 Null Hypothesis test for combine 2 event type (Involuntary & termination)


##Modelling##

#####COX Proportional Hazards Model:#####

Cox Proportional Model is similar to logistic regression function, where it enables us to know the hazard ratio between two groups considering the covariates, In our case the ratio of the hazard between the Turnover employees and No turnover employees. The hazard is the probability of employees leaving the company(Turnover) to the employees who are not leaving the company at a given point of time. One of the primary reasons we choose Cox Proportional Model because it does not need any distribution to be known to run the model.

**Tied Data**:

Tied data is something where two records have the same time to the event, we have handled this using Efron method which suits well for small data sets having heavily tied data which is true in our case. The Primary reason to handle the tied data is cox proportional hazard model is sensitive to tied data.

**Our Initial Hypothesis was built on**:

**We have considered all the four different turnover types**: (Retirement, Voluntary Resignation, Involuntary Resignation, Job Termination, Employee is Fired). We have modelled the data separately for all the turnover types together and individually. Consequently, we have determined that separate models are better in explaining the turnover than a nested model. All these steps are explained in detail. We have built different hypothesis for four different types.

Our focus was to find the significant covariates which affects the four types of turnovers in the company, this will help the organization to focus on these attributes and reducing the attrition rate.

**Finding the Important covariates affecting the different type of attrition**:
	
In this Part we have used the nested model considering 0 as censored and others all the other types as events, our team has built hypothesis using the COX model for all the covariates. Using step wise regression, we have eliminated few of the covariates which are not significant. In addition, we have created few variables using the existing data as explained. The primary motive in this section is to identify the significant variables which are time dependent.

**Bonus**:

We have identified bonus as the time dependent variable and handled it by taking the cumulative sum of all the bonus amount employee’s received by serving the company up to forty year of tenure, for which it is needed to create 40 new variables from cum1-cum40. However, while calling in the model we have sent this bonus variable with respect to “YearsAtCompany” which provides information of employee’s tenure duration at the company.

Methodology is as follows 

	If an employee’s experience at company is 4, we have used the variable cumulative 3 as the input.
	
	If an employee’s experience at company is 40, we have send the variable cumulative 39 as the input.

**Checking Non Proportionality**:

We have used the residuals tests such as Martingale using ASSESS statement and Schoenfeld in determining the time dependent variables. We have only considered the significant variables to find the time dependent variables rather than considering all the variables of the employees. 

**Martingale Residuals**: 

This is calculated by creating the possible simulations of data without time dependency, if the covariate is time dependent then the actual pattern will be heavily biased the created set of simulations. Using the assess statement in SAS, we have computed the 
martingale residuals. 

Below simulation graph shows the thick blue line indicating the actual pattern heavily deviating from the simulated possibilities with significant p-value which proves it is a time dependent covariate.
Proportional hazard assumption states that all those covariates which are not deviating from theoretical expectations and their p-values is not significant considered to be proportional covariate else it is non proportional covariate dependent on time
 
 ![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773601/270f64e6-651d-11e6-9bfc-ae6593d3f3e9.png)

 Figure-28 Checking Proportional Hazard assumption for Years in Current role

Figure 29 shows Supremum Test for Proportional Hazards Assumption which contained the p-values of all the variables of employees which also signify that Years in current role is significantly low and states the simulations created and actual trends are different for this variable hence found that years in current role is dependent on the Years at the company

 
  ![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773602/270ff4ec-651d-11e6-934b-c501446648a9.png)
  ![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773604/27146220-651d-11e6-8b02-0926d44819c1.png)

  Figure-29 Null Hypothesis test for finding time dependent covariate

**Schoenfeld Residuals**: 

Schoenfeld residual is the difference between the covariate value of the subject failed and the expected value of the covariate for the subject who fails at that time point. We have used this procedure to check the residuals of the significant covariates are correlated to employee’s years at the company which is the event time. If the relation is strong we say they are time dependent/non Proportional, else, we say them as independent of time or proportional.
We have only considered the numerical values to find the linear relation, we used the years at company, log years at company and quadratics function years at company variable to find the relation in different aspects of linearity and non-linearity. Grey colored values in the below figure have a significant relation with the employee’s years at the company.
 
![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773609/271a37c2-651d-11e6-9e6d-af8a33d23e51.png)

Figure-30 Pearson Correlation Coefficient for Time Dependent (Non Proportional) Covariate


We have used Schoenfeld Residuals below to determine the negative correlation found for Number of Companies worked with Years at Company. When employee’s number of companies worked previously is more, his experience in the current company is less, which means for observation 778 have worked for 7 companies but has 2 years of work experience at FermaLogis which signifies that it is a time dependent covariate.

 ![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773605/27157fca-651d-11e6-9a77-17349eafcc5f.png)

Figure-31 Schoenfeld residuals for Numbers of Companies worked

Next non proportional covariate is Total Working Years, this value is increasing with increase of YearsAtCompany linearly which is a basic phenomenon where the number of years in the current company will also add to the total experience and there is no wonder both are related to each other. We can observe a strong linear relationship in the below figure and conclude that Total Working Years is a time dependent covariate.
 
![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773606/27173b1c-651d-11e6-9f9d-28e3d4788ac9.png)

Figure-32 Schoenfeld residuals for Total Working Years
   
Team have observed non proportionality in the Years in current role, basic trend in promotion is with less experience, employees will go to next job level in short span of time but with increase in experience, chances to get promoted to higher job level will also increase. So when an employee’s years at the company increase, his years in the current role will also increase. This can be observed in the below figure.

![alt tag]( https://cloud.githubusercontent.com/assets/19517513/17773607/2717fc14-651d-11e6-8c66-a5638cb5b648.png)

 Figure-33 Schoenfeld residuals for Years in Current role


**Handling Non Proportionality using Interactions**:

To handle non proportionality, team has used interactions with respect to the years in the company. For every employee we have multiplied the non-proportional variables with years in the company and created a set of new variables which we sent as inputs to our models.
 
The actual will be calculating by the sum of coefficient of the actual variable value and the interactions value at a given point of time.

Attributes increase/decrease the hazard rates for certain event types

Team have selected all the significant variables and coded the interaction terms into the model, next task is to find the important variables affecting each type of the turnover.

As said above we have modelled all the four independent hypothesis and a nested hypothesis, by a hypothesis test using degrees of freedom and determined that independent models are better explaining the covariates and hazard rate than a nested model. We have discussed all the significant covariates and hazard rates on individual event types in the below section.

**Note**:Significant covariates are highlighted with pink color and named as significant. When the hazard rate>1, hazard is increasing with unit increase in the covariates whereas Hazard rate<1 shows that hazard is decreasing with unit increase in the covariates value.

##RetirementEvent Type:

While Modelling the Retirement type as the event and all other types as censored we have got the full model which is significantly different and better than the Null model, we can observe that the fit statistics differing between model with and without covariates.

![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773608/271978b4-651d-11e6-9d24-4ee3912df8bd.png)

 Figure-34 Model Fit Statistics for Retirement

**Important variables observed for Retirement**:

Below are the most important factors that are affecting the employee’s retirement throughout the company, all these variable coefficients are significantly different from zero (which is explained by P<0.05). However, if these coefficients have positive value it increases the hazard rate whereas if the coefficient is negative, it decreases the hazard rate. Few important covariates affecting retirement are Age, Business Travel, Job involvement, Years in current role, Employee Bonus, Number of companies worked with respect to time, Year in Current Role with respect to time. 

**Few of the important negative factors should be considered by management are**:

Hazard rate is increasing by 54 % with increase in one year of age, this states that people with high age are retiring from the company.
	
People who are travelling are frequently are retiring almost 8 times higher than the people who are travelling less. However, we only have 27 events of this type to believe in this and we need more of this event types to train the model.

Old people who are less involved in the job are retiring from the company.

People who are working overtime are retiring more.

Employees who do not get more bonuses in their experience are retiring more.

Both interactions terms Year in current role and number of companies worked are increasing hazard rate.



**Few of the important Positive factors should be considered by management are**:

Employees who are not working overtime has more time for retirement, or the hazard decreases for them.

One year increase in the current role decreases the hazard rate by almost 40%.
	
**Bonus Affect Employee Turnover**

Employee Bonus is a significant factor for people who are retiring from the company, may be this is because their salaries might be high with their experience and possibly they will expect more benefits from the company.  However, this should be decided by management as the number of events of type retiring are less.  We cannot solely depend on this saying employee’s bonus affects retirement.
 
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773614/2722aeac-651d-11e6-9ea5-eb4a6edf281d.png)

Figure-35 Hazard Ratio Estimates for Retirement

##Voluntary Resignation/ Turnover

While Modelling the Voluntary Resignation type as the event and all other types as censored, we have got the full model which is significantly different and better than the Null model, we can observe that the fit statistics differing between model with and without covariates.
 
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773610/271b6368-651d-11e6-932d-c3e70c03d308.png)

Figure-36 Model Fit Statistics for Voluntary Retirement

Few of the important negative factors should be considered by management:

One of the major findings is that people who do not hold any stocks are leaving four times as much as people who have stocks.

People who are travelling frequently are retiring almost 8 times higher than the people who are travelling less.
	
People who are less satisfied with environment are twice as likely to leave the company than the others.

People who are less involved in the job are more likely to leave the company than the others.

People who are less satisfied in the job are six times more likely to leave the company than the others.

One increase in number of companies an employee worked actually increasing the hazard rate by 23%.

Interaction term more number of years in current role is increasing the hazard rate 9.2% by a factor of employee’s experience at Fermalogis.



Few of the important Positive factors should be considered by management:

People who are not travelling are having less probability of leaving as compared to people who are travelling by 50%.
	
People with high work experience are less prone to leave the company, this states company should focus on less experienced people.

People who does not work overtime are leaving less from the company, Fermalogis should take care of the overtime by hiring new employees if possible.
      
We have plotted all the observation in the below figures, Significant covariates are highlighted with pink color and named as significant. Employee Bonus is not a significant factor for people leaving from the company, this can be seen in the attached screenshot below.
 
![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773612/27202ec0-651d-11e6-8cd1-c8b70d5e5b86.png)

Figure-37 Hazard Ratio Estimates for Voluntary Retirement



##Combined model for involuntary resignation and job termination:

Though we modelled differently for involuntary resignation and termination event types, after fit statistics check we determined that a nested model with both involuntary and termination is doing better than the individual models. 

Modelling the involuntary Resignation and termination as the event and all other types as censored we have got the full model which is significantly different and better than the Null model, we can observe that the fit statistics differing between model with and without covariates.
 
  ![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773611/271d98ea-651d-11e6-82f8-44ce48346399.png)

Figure-38 Model Fit Statistics for involuntary Resignation and termination

Few of the important negative factors should be considered by management:

People who are less satisfied with environment are twice as likely to leave the company than the others.
	
People who are staying far away from office are having higher hazard rate.
	
People who do not hold any stocks are leaving more than the people who have stocks by 75%.
	
With respect to time, years in current role and number of companies worked are increasing the hazard rate.

Few of the important Positive factors should be considered by management:

People who are not travelling are having less probability of leaving as compared to people who are travelling almost by five times.

People who do not work overtime are leaving less from the company, Fermalogis should take care of the overtime by hiring new employees if possible.

Interestingly in this sector people who are less satisfied are staying in the company.

Increase in total working years and years in current role is reducing the hazard rate, this can be said as experienced people are less terminated from the organization.

Total experience of an employee is reducing hazard rate.

Interactions in this case are significant but Employee Bonus is not a significant factor for people leaving from the company due to involuntary and termination types, this can be seen in the attached screenshot below.
 
  ![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773618/272853b6-651d-11e6-8883-262df1bc0e71.png)

 Figure-39 Hazard Ratio Estimates for involuntary Resignation and Job termination



##Conclusion:

Frequency plot of all event types shown in Figure 20 indicates frequency for each turnover type is different from one another which means each attrition type is at different rate so we can say that all turnover types are different. We have plotted LLS graphs to check the linearity between turnover types and found that Voluntary Resignation and Job termination are linearly related. To check this point further, we have applied proportional hazards model and found that as per Wilcoxon test as well (Fig 21), their p-values is not significant and they are not different thus we used Voluntary Resignation and Job termination together.
	
Team also performed log ratio test and found that p-value for all the combined event type is 0 (Figure 25) which means all events types are different and need to handle separately. We performed log Ratio test on combined model of Voluntary Resignation and Job termination and found p-value as 0.193 which is not significant (Figure29) hence we can use the nested model in this case.
	
For Retirement – Age, Job Involvement, Business Travel, Bonus and Interaction Variable Years in current role are significant.

For Voluntary Resignation-Stocks, Overtime, Business Travel, Environment Satisfaction, Job satisfaction and Years in current role are significant.
	
For Involuntary Resignation and Job termination – Environment Satisfaction, Distance from home, Stocks and Interaction variable -Years in current roles and number of companies worked are significant.
	
Team found that Employee Bonus is a significant factor for employees who are retiring from the company but has not significant effect on the other event types.
	
Team found three variables which are not proportional with respect to hazard – NumCompaniesWorked, TotalWorkingYears and YearsInCurrentRole
	
##Recommendations:

Though we have highlighted important variables affecting individual turnover types throughout the report, we have few common variables which hold good for all the employees.

Management should take care of the overtime of the employees by hiring few temporary employees and shifting the extra work.

Management should try reducing the Business travel associated with employees, as we have seen people who are travelling more are more likely to leave the company.

We have observed a strong positive trend between stocks and the employee turnover, encouraging employees towards holding own stocks in the company might reduce the turnover rate.

By motivating employees with good leadership and encouraging them with their work can lead to a better job satisfaction and involvement levels. This might reduce the turnover rate associated with these factors.

One major factor is environment satisfaction in turnover rate, by having fun events among the employees FermaLogis can actually build a strong bond between the employees. This will help to increase the environment satisfaction levels among employees.


##Appendix:

**Individual models for In-Voluntary Resignation and termination**:

**Implementing PH Reg using programming step for the type In-Voluntary Resignation**:

We have plotted all the observation in the below figures, Significant covariates are highlighted with pink color and named as significant, and when the hazard rate>1, hazard is increasing with unit increase in the covariates whereas Hazard rate<1 shows that hazard is decreasing with unit increase in the covariates value. These are the few covariates which management can look into when considering the retired people. Interactions in this case are significant.
 
  ![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773615/2724d380-651d-11e6-977c-c80e9ef05a71.png)

Figure 1 Model Fit Statistics for covariates
 
   ![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773613/27208da2-651d-11e6-8938-e4cc403baf24.png)

Figure 2 Analysis of Maximum Likelihood Estimates


Termination event type model:
 
    ![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773617/2727c630-651d-11e6-8568-afb4ea8fa3d1.png)

Figure 3 Termination covariates
 
     ![alt tag](https://cloud.githubusercontent.com/assets/19517513/17773616/2726c08c-651d-11e6-9bb7-94cfc26c9db2.png)

Figure 4 Analysis of likelihood estimates for covariates










