filename in1 '/home/u62275281/dehydration_s23.txt';
 
data one;
infile in1;
input ID rehydration_score dose age weight @@;
run;

proc print data=one;
var  ID rehydration_score dose age weight;
run;

proc reg ;
model rehydration_score= dose age weight/ tol vif collinoint;
run;
 
proc reg ;
model rehydration_score= dose age / tol vif collinoint;
run;
  
proc reg ;
model rehydration_score= dose weight/ tol vif collinoint;
run;

data two; set one;
if (0 <= dose < 1) then dose1=dose; 
else if dose  >= 1 then dose1=1;
if (0 <= dose  < 1) then dose2=1; 
else if (1 <= dose  < 2) then dose2=dose;
 else if dose  >= 2 then dose2=2; 
  
if (0 <= dose  < 2) then dose3=2; 
else if dose  >= 2 then dose3=dose ; 
 
if (0 <= dose  < 1) then dosegroup='d1';
 else if (1 <= dose  < 2) then dosegroup='d2';
 else if dose  >= 2 then dosegroup='d3';
 run;
proc means data=two;
 class dosegroup;
 var rehydration_score;
 run;
proc glm data=two;
class dosegroup;
model rehydration_score = dosegroup;
lsmeans dosegroup/ tdiff pdiff stderr adjust=tukey;
run;
proc reg data=two;
model rehydration_score = dose;
plot rehydration_score*dose;
run;
proc reg data=two;
model rehydration_score = dose1 dose2 dose3 / stb; 
output out=stats pred=yhat; 
test dose1= dose2; 
test dose2=dose3; 
run;


