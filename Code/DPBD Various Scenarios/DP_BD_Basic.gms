*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*                                             Intergrated Lot Sizing, Production Distribution, and Hub Location Problems
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

****************************************** AP network data *****************************************
set TNhubs                 "US network hub location set"      /1*227/;
alias (TNhubs, TNhubs1, TNhubs2);
set aaa /1*2/;
*=== Import from Excel using GDX utilities
parameter HubCordinate(TNhubs, aaa);
$CALL GDXXRW.EXE network_data.xlsx par=HubCordinate rng=A2:C229
$GDXIN network_data.gdx
$LOAD HubCordinate
$GDXIN
execseed = 200;
display HubCordinate ;

set k 'coordinates' /'x-axis', 'y-axis', 'z-axis'/

Scalar r 'radius of earth (miles)' / 3959 /;
Parameter
   lat(TNhubs)     'latitude angle                            (radians)'
   long(TNhubs)    'longitude angle                           (radians)'
   uk(TNhubs,k)    'point in cartesian coordinates        (unit sphere)'
   useg(TNhubs,TNhubs1) 'straight line distance between points (unit sphere)'
   udis(TNhubs,TNhubs1) 'great circle distances                (unit sphere)'
   dis(TNhubs,TNhubs1)  'great circle distances                      (miles)';


lat(TNhubs) = HubCordinate(TNhubs, '1')*pi/180;
long(TNhubs) = HubCordinate(TNhubs, '2')*pi/180;

uk(TNhubs, "x-axis") = cos(long(TNhubs))*cos(lat(TNhubs));
uk(TNhubs, "y-axis") = sin(long(TNhubs))*cos(lat(TNhubs));
uk(TNhubs, "z-axis") =              sin(lat(TNhubs));

useg(TNhubs,TNhubs1) = sqrt(sum(k, sqr(uk(TNhubs,k) - uk(TNhubs1,k)) ));
udis(TNhubs,TNhubs1) = pi;
udis(TNhubs,TNhubs1)$(useg(TNhubs,TNhubs1) < 1.99999) = 2*arctan(useg(TNhubs,TNhubs1)/2/sqrt(1 - sqr(useg(TNhubs,TNhubs1)/2)));
dis(TNhubs,TNhubs1)  = r*udis(TNhubs,TNhubs1)*1.17;

*option  lat:5, long:5, uk:5, useg:5, udis:5, dis:0;

*display lat, long, uk, useg, udis, dis;

parameter HubDistanceData(TNhubs1, TNhubs2);

HubDistanceData(TNhubs1, TNhubs2) = dis(TNhubs1, TNhubs2) ;

****************************************** AP network data *****************************************
* Note: There are 200 locations in the AP network. The first 40 will be used for the plant locations, 41-100 will be used for the hub locations, 101-200 will be used as commodity demand locations.

set plants               "Plant Set"             /1*%PLTSET%/;
set products             "Product Type Set"      /1*%PRTSET%/;
set periods              "period Type Set"       /1*%PRSET%/;
set hubs                 "hub location set"      /1*%HBSET%/;

alias (plants, plantsi, plantsj);
alias (periods, periods1, periods2);
alias (hubs, hubs1, hubs2);

parameter PHdistance(plants, hubs);
loop(TNhubs1$(ord(TNhubs1) le card(plants)),
      loop(TNhubs2$(ord(TNhubs2) gt card(plants) and ord(TNhubs2) le card(plants) + card(hubs)),
                PHdistance(plants, hubs)$(ord(plants) eq ord(TNhubs1) and ord(hubs) eq ord(TNhubs2) - card(plants)) = HubDistanceData(TNhubs1, TNhubs2);
           );
     );

parameter HHdistance(hubs1, hubs2);
loop(TNhubs1$(ord(TNhubs1) gt card(plants) and ord(TNhubs1) le card(plants) + card(hubs)),
      loop(TNhubs2$(ord(TNhubs2) gt card(plants) and ord(TNhubs2) le card(plants) + card(hubs)),
                HHdistance(hubs1, hubs2)$(ord(hubs1) eq ord(TNhubs1) - card(plants) and ord(hubs2) eq ord(TNhubs2) - card(plants)) = HubDistanceData(TNhubs1, TNhubs2);
           );
     );


parameter HPDdistance(hubs, products);
loop(TNhubs1$(ord(TNhubs1) gt card(plants) and ord(TNhubs1) le card(plants) + card(hubs)),
      loop(TNhubs2$(ord(TNhubs2) gt card(plants) + card(hubs) and ord(TNhubs2) le card(plants) + card(hubs) + card(products)),
                HPDdistance(hubs, products)$(ord(hubs) eq ord(TNhubs1) - card(plants) and ord(products) eq ord(TNhubs2) - card(plants) - card(hubs)) = HubDistanceData(TNhubs1, TNhubs2);
           );
     );
display  PHdistance, HHdistance, HPDdistance;

parameter discoutf1, discoutf2, discoutf3 ;
discoutf1 = 0.001;
discoutf2 = 0.0003;
discoutf3 = 0.001;

parameter values(products);
values(products) = ceil(uniform(0.1, 2)*1000)/1000;

parameter demands(products, periods);
demands(products, periods) = %DMD%*ceil(uniform(80, 250));

parameter totaldemands(products);
totaldemands(products) = sum(periods, demands(products, periods));

parameter transcost(plants, hubs1, hubs2, products, periods);
transcost(plants, hubs1, hubs2, products, periods) = %TPCST%*demands(products, periods)*values(products)*(discoutf1*PHdistance(plants, hubs1) + discoutf2*HHdistance(hubs1, hubs2) + discoutf3*HPDdistance(hubs2, products)) ;

set hubspp(plants, products, hubs1, hubs2, periods)  ;
hubspp(plants, products, hubs1, hubs2, periods) = yes;
parameter arcsize;
arcsize = 0;
loop(plants,loop(products,loop(hubs1,loop(hubs2,loop(periods,
        if( hubspp(plants, products, hubs1, hubs2, periods),
             arcsize  = arcsize + 1;
           );
);););););
display arcsize;
*hubspp(plants, products, hubs1, hubs2, periods)$(transcost(plants, hubs1, hubs2, products, periods) gt transcost(plants, hubs2, hubs1, products, periods)) = no;
*hubspp(plants, products, hubs1, hubs2, periods)$((ord(hubs1) ne ord(hubs2)) and (transcost(plants, hubs1, hubs2, products, periods) ge transcost(plants, hubs1, hubs1, products, periods) or transcost(plants, hubs1, hubs2, products, periods) ge transcost(plants, hubs2, hubs2, products, periods))) = no;
arcsize = 0;
loop(plants,loop(products,loop(hubs1,loop(hubs2,loop(periods,
        if( hubspp(plants, products, hubs1, hubs2, periods),
             arcsize  = arcsize + 1;
           );
);););););
display arcsize;


parameter prodcost(products, plants, periods) 'unit of production cost';
prodcost(products, plants, periods) = %LSCST%*ceil(uniform(3, 3.2)*1000)/1000;

parameter InvCost(products, plants, periods) 'inventory cost';
parameter InvCosttemp(products, plants);
InvCost(products, plants, periods) = 0.1*prodcost(products, plants, periods);

parameter setCost(products, plants, periods) 'Setup Cost';
setCost(products, plants, periods) = 100*prodcost(products, plants, periods) ;

parameter HubCost(hubs, periods);
*loop(TNhubs$(ord(TNhubs) gt 10 and ord(TNhubs) le 10 + card(hubs)),
*         HubCost(hubs, periods)$(ord(hubs) eq ord(TNhubs) - 10) = FixedHubCost(TNhubs, '1');
*     );
HubCost(hubs, '1') = %HBCST%*uniformint(200, 1000);
HubCost(hubs, periods) = HubCost(hubs, '1');
HubCost(hubs, periods)$(ord(hubs) le card(plants)) = 0;
display HubCost;
parameter BM(products, periods);
BM(products, periods) = sum(periods1$(ord(periods1) ge ord(periods)), demands(products, periods1))  ;

********************************* Mathematical Models ******************************************
positive variables X(plants, products, periods),
                   I(plants, products, periods),
                   F(plants, products, hubs1, hubs2, periods);
binary variables   Y(plants, products, periods),
                   Z(hubs, periods),
                   U(plants, products);
variable totalcost;

equations objective,
          demandsatisfy(plants, products, periods),
          prodsetuprel(plants, products, periods),
          singleroute(products, periods),
          nononsetuphub1(products, hubs, periods),
          nononsetuphub2(products, hubs, periods),
          plantloc(products),
          Singleplant(plants, products, periods),
          singplantroute(plants, products, hubs1, hubs2, periods) ;

objective..
       totalcost =e= sum((plants, products, periods), prodcost(products, plants, periods)*X(plants, products, periods) + setCost(products, plants, periods)*Y(plants, products, periods)
                         + InvCost(products, plants, periods)*I(plants, products, periods))
                         + sum((hubs, periods), HubCost(hubs, periods)*Z(hubs, periods))
                         + sum((plants, hubs1, hubs2, products, periods)$(hubspp(plants, products, hubs1, hubs2, periods)), transcost(plants, hubs1, hubs2, products, periods)*F(plants, products, hubs1, hubs2, periods));

demandsatisfy(plants, products, periods)..
      X(plants, products, periods) + I(plants, products, periods - 1) =e= sum((hubs1, hubs2)$(hubspp(plants, products, hubs1, hubs2, periods)), demands(products, periods)*F(plants, products, hubs1, hubs2, periods)) + I(plants, products, periods);

prodsetuprel(plants, products, periods)..
      X(plants, products, periods) =l= BM(products, periods)*Y(plants, products, periods) ;

singleroute(products, periods)..
      sum((plants, hubs1, hubs2)$(hubspp(plants, products, hubs1, hubs2, periods)), F(plants, products, hubs1, hubs2, periods)) =e= 1 ;

nononsetuphub1(products, hubs, periods)..
      sum((plants, hubs2)$(hubspp(plants, products, hubs, hubs2, periods)), F(plants, products, hubs, hubs2, periods) ) =l= Z(hubs, periods);

nononsetuphub2(products, hubs, periods)..
      sum((plants, hubs1)$(hubspp(plants, products, hubs1, hubs, periods) and ord(hubs1) ne ord(hubs)), F(plants, products, hubs1, hubs, periods) ) =l= Z(hubs, periods);

plantloc(products)..
      sum(plants, U(plants, products)) =e= 1 ;

Singleplant(plants, products, periods)..
      Y(plants, products, periods) =l= U(plants, products);

singplantroute(plants, products, hubs1, hubs2, periods)$(hubspp(plants, products, hubs1, hubs2, periods))..
      F(plants, products, hubs1, hubs2, periods) =l= U(plants, products);

model SupplyChain /objective, demandsatisfy, prodsetuprel, singleroute, nononsetuphub1,
          nononsetuphub2, plantloc, Singleplant, singplantroute/;
SupplyChain.solprint = 2;
SupplyChain.reslim = 1200;
SupplyChain.optca = 0.000;
SupplyChain.optcr = 0.000;
SupplyChain.iterlim = 4000000;

file DP_BD_Basic /DP_BD_Basic.dat/;
put DP_BD_Basic;
DP_BD_Basic.ap = 1;

****************************************Dynamic Programming Algorithm**************************************************
parameter M(plants, products, periods, periods1);
parameter F_min(plants, products, periods);
F_min(plants, products, periods) = inf;
parameter F_min_temp(plants, products, periods);
parameter total_product_cost(plants, products);
set revperiods(periods, periods1);
revperiods(periods, periods + [card(periods)-2*ord(periods)+1]) = yes;

loop(products,
*
* solve each subproblem
*
* get the coefficients for setup, production, and inventory, and other costs
* The algorithm is referred to An Efficient Implementation of the Wagner-Whitin Algorithm for Dynamic Lot-Sizing
* authored by James R. Evans

* get the cost incurred by procuring in period periods for all periods periods through periods1.
         loop(periods,
                  M(plants, products, periods, periods) = setCost(products, plants, periods) + prodcost(products, plants, periods)*demands(products, periods) ;
                  loop(periods1$(ord(periods1) gt ord(periods)),
                           M(plants, products, periods, periods1) = M(plants, products, periods, periods1 - 1) + demands(products, periods1)*(prodcost(products, plants, periods) + sum(periods2$(ord(periods2) ge ord(periods) and ord(periods2) le ord(periods1) - 1), InvCost(products, plants, periods2) ));
                       );
              );
* get the mimimal cost for periods 1 through periods
* get the solution of setup variables
         F_min(plants, products, periods) = inf;
         F_min(plants, products, '1') = M(plants, products, '1', '1');
         loop(plants,
                  loop(periods$(ord(periods) gt 1),
                           loop(periods1$(ord(periods1) le ord(periods)),
                                  F_min_temp(plants, products, periods) = F_min(plants, products, periods1 - 1) + M(plants, products, periods1, periods) ;
                                  if (F_min_temp(plants, products, periods) lt F_min(plants, products, periods),
                                          F_min(plants, products, periods) = F_min_temp(plants, products, periods) ;
                                      );
                                );
                       );
              );


* get the total objective corresponding to each facility
          loop(periods$(ord(periods) ge card(periods)),
                     total_product_cost(plants, products) = F_min(plants, products, periods) ;
               );

);

variable totalcost2;
equations objective2;

objective2..
       totalcost2 =e= sum((plants, products), total_product_cost(plants, products)*U(plants, products))
                         + sum((hubs, periods), HubCost(hubs, periods)*Z(hubs, periods))
                         + sum((plants, hubs1, hubs2, products, periods)$(hubspp(plants, products, hubs1, hubs2, periods)), transcost(plants, hubs1, hubs2, products, periods)*F(plants, products, hubs1, hubs2, periods));

model SupplyChain2 /objective2, singleroute, nononsetuphub1,
          nononsetuphub2, plantloc, singplantroute/;
SupplyChain2.solprint = 2;
SupplyChain2.reslim = 3600;
SupplyChain2.optca = 0.000;
SupplyChain2.optcr = 0.000;
SupplyChain2.iterlim = 4000000;
*solve SupplyChain2 using mip minimizing totalcost2;
*parameter optobj2;
*optobj2 = totalcost2.l;
*display optobj2 ;

parameter zsol(hubs, periods), usol(plants, products);
zsol(hubs, periods) = 0 ;
usol(plants, products) = 0 ;

parameter maxtime;
maxtime = 300;
parameter totaltime;
totaltime = 0 ;
*---------------------------------------------------------------------
* Benders Decomposition Initialization
*---------------------------------------------------------------------
display "------------------ BENDERS ALGORITHM -----------------------";
scalar UB 'upperbound' /INF/;
scalar LB 'lowerbound' /-INF/;

*---------------------------------------------------------------------
* Benders Dual Subproblem
*---------------------------------------------------------------------
variable dualTC 'objective variable' ;
variables AlphaVar(periods) ;
positive variables
ThetaVar(hubs, periods)
BetaVar(plants, hubs1, hubs2, periods)  ;
parameter usolprod(plants)  ;
parameter transcostsub(plants, hubs1, hubs2, periods) ;
set hubssub(plants, hubs1, hubs2, periods) ;

equations
dualsubprob_obj 'objective'
dualsubprob_constr1(plants, hubs1, hubs2, periods) 'dual constraint 1'
dualsubprob_constr2(plants, hubs, hubs, periods) 'dual constraint 2'
;

dualsubprob_obj.. dualTC =e= sum((periods), AlphaVar(periods))
                         - sum((hubs, periods), zsol(hubs, periods)*ThetaVar(hubs, periods))
                         - sum((plants, hubs1, hubs2, periods)$(hubssub(plants, hubs1, hubs2, periods)), usolprod(plants)*BetaVar(plants, hubs1, hubs2, periods)) ;

dualsubprob_constr1(plants, hubs1, hubs2, periods)$(hubssub(plants, hubs1, hubs2, periods) and ord(hubs1) ne ord(hubs2))..
AlphaVar(periods) - ThetaVar(hubs1, periods) - ThetaVar(hubs2, periods) - BetaVar(plants, hubs1, hubs2, periods) =l= transcostsub(plants, hubs1, hubs2, periods) ;

dualsubprob_constr2(plants, hubs, hubs, periods)$(hubssub(plants, hubs, hubs, periods))..
AlphaVar(periods) - ThetaVar(hubs, periods) - BetaVar(plants, hubs, hubs, periods) =l= transcostsub(plants, hubs, hubs, periods) ;

model dualsubproblem /dualsubprob_obj, dualsubprob_constr1, dualsubprob_constr2/;
dualsubproblem.solprint=2;
*Keep GAMS in memory
dualsubproblem.solvelink=2;
dualsubproblem.reslim = 3600;
dualsubproblem.optca = 0.000;
dualsubproblem.optcr = 0.000;
dualsubproblem.iterlim = 40000;

*---------------------------------------------------------------------
* Benders Restricted Master Problem
*---------------------------------------------------------------------
set iter /iter1*iter5000/;
set cutset(iter) 'dynamic set';
cutset(iter)=no;

variables zetavar,
          MasterCost 'relaxed master objective variable';

equations
master_obj
master_obj1
cut(iter) 'Benders cut for optimal subproblem'
HubOpenMstr(periods)
;
parameters
cutconst(iter, products, periods) 'constant term in cuts'
cutcoeff1(iter, hubs, products, periods)
cutcoeff2(iter, plants, products, periods)
;
cutconst(iter, products, periods) = 0;
cutcoeff1(cutset, hubs, products, periods) = 0;
cutcoeff2(iter, plants, products, periods) = 0;


master_obj..  MasterCost =e= zetavar + sum((hubs, periods), HubCost(hubs, periods)*z(hubs, periods))
                                 + sum((plants, products), total_product_cost(plants, products)*U(plants, products)) ;

master_obj1..  MasterCost =e= sum((hubs, periods), HubCost(hubs, periods)*z(hubs, periods))
                                 + sum((plants, products), total_product_cost(plants, products)*U(plants, products)) ;

cut(cutset)..
              zetavar =g= sum((products, periods), cutconst(cutset, products, periods)) - sum((products, periods, hubs), cutcoeff1(cutset, hubs, products, periods)*z(hubs, periods))
                          - sum((products, periods, plants), cutcoeff2(cutset, plants, products, periods)*U(plants, products))  ;

HubOpenMstr(periods)..
         sum(hubs, z(hubs, periods)) =g= 1 ;

model master1 /master_obj1, plantloc, HubOpenMstr/;
* reduce output to listing file:
master1.solprint=2;
* speed up by keeping GAMS in memory:
master1.solvelink=2;
* solve to optimality
master1.optcr=0;
master1.reslim = 200;
master1.optca = 0.000;
master1.optcr = 0.000;
master1.iterlim = 4000000;

model master /master_obj, cut, plantloc, HubOpenMstr/;
* reduce output to listing file:
master.solprint=2;
* speed up by keeping GAMS in memory:
master.solvelink=2;
* solve to optimality
master.optcr=0;
master.reslim = 200;
master.optca = 0.000;
master.optcr = 0.000;
master.iterlim = 4000000;

*---------------------------------------------------------------------
* Benders Algorithm
*---------------------------------------------------------------------
scalar converged /0/;
scalar iteration;
scalar bound;
parameter totalprodcost, totalhubcost, totaltransportcost;
parameter totalopenhubs;
parameter tempbound;
parameter gap;
*parameter select_best(flows);
*parameter hubsopen_best(hubs);
parameter log(iter,*) 'logging info';
loop(iter$(not converged and totaltime lt maxtime),

         option optcr=0;
         if(ord(iter) eq 1,
                  solve master1 minimizing MasterCost using mip;
                  LB = master1.ObjEst;
                  totaltime = totaltime + master1.etSolve;
            );
         if(ord(iter) gt 1,
                  solve master minimizing MasterCost using mip;
                  LB = master.ObjEst;
                  totaltime = totaltime + master.etSolve;
          );

         zsol(hubs, periods) = Z.l(hubs, periods) ;
         usol(plants, products) = U.l(plants, products) ;
         totalopenhubs = sum((hubs, periods), Z.l(hubs, periods));
*
* check results.
*
         abort$(master.modelstat=4) "Relaxed Master is infeasible";
*abort$(master.modelstat>=2) "Masterproblem not solved to optimality";
*
* update lowerbound
*

*
* solve Benders subproblem
*

         bound = 0 ;
         loop(products,
                  transcostsub(plants, hubs1, hubs2, periods) = transcost(plants, hubs1, hubs2, products, periods) ;
                  hubssub(plants, hubs1, hubs2, periods) = hubspp(plants, products, hubs1, hubs2, periods);
                  usolprod(plants) = usol(plants, products) ;

                  solve dualsubproblem maximizing dualTC using lp;
                  totaltime = totaltime + dualsubproblem.etSolve;
                  abort$(dualsubproblem.modelstat>=2) "Dualsubproblem not solved to optimality";
                  bound = bound + dualTC.l;
                  cutconst(iter, products, periods) = AlphaVar.l(periods) ;
                  cutcoeff1(iter, hubs, products, periods) = ThetaVar.l(hubs, periods) ;
                  cutcoeff2(iter, plants, products, periods) = sum((hubs1, hubs2)$(hubssub(plants, hubs1, hubs2, periods)), BetaVar.l(plants, hubs1, hubs2, periods)) ;
              );

         bound = sum((hubs, periods), HubCost(hubs, periods)*zsol(hubs, periods))
                    + sum((plants, products), total_product_cost(plants, products)*usol(plants, products))
                    + bound  ;

         if (bound < UB,
               UB = bound;
               totalprodcost = sum((plants, products), total_product_cost(plants, products)*usol(plants, products)) ;
               totalhubcost = sum((hubs, periods), HubCost(hubs, periods)*zsol(hubs, periods));
               totaltransportcost = bound - totalprodcost - totalhubcost;
            );
         cutset(iter) = yes;

*
* solve Relaxed Master Problem
*

         log(iter,'LB') = LB;
         log(iter,'UB') = UB;
         iteration = ord(iter);
         display iteration,LB,UB;
         gap = UB - LB;
         display gap;
         converged$((UB-LB) < 0.01) = 1;
         display$converged "Converged";
         put  %ID%, %PLTSET%, %PRTSET%, %PRSET%, %HBSET%, totalopenhubs, totalprodcost,  " ", totalhubcost,  " ", totaltransportcost, " ",  iteration, "  ", LB, " ", UB, " ",  totaltime ///
);
