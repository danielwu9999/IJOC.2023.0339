*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
*                                             Intergrated Lot Sizing, Production Distribution, and Hub Location Problems
*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

****************************************** AP network data *****************************************
set TNhubs                 "AP network hub location set"      /1*200/;
alias (TNhubs, TNhubs1, TNhubs2);
set aaa /1*2/;
*=== Import from Excel using GDX utilities
parameter HubCordinate(TNhubs, aaa);
$CALL GDXXRW.EXE APData.xlsx par=HubCordinate rng=A1:C201
$GDXIN APData.gdx
$LOAD HubCordinate
$GDXIN
parameter HubDistanceData(TNhubs1, TNhubs2);

HubDistanceData(TNhubs1, TNhubs2) = sqrt((HubCordinate(TNhubs1, '1') - HubCordinate(TNhubs2, '1'))*(HubCordinate(TNhubs1, '1') - HubCordinate(TNhubs2, '1')) + (HubCordinate(TNhubs1, '2') - HubCordinate(TNhubs2, '2'))*(HubCordinate(TNhubs1, '2') - HubCordinate(TNhubs2, '2')));
display HubDistanceData;

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


parameter discoutf1, discoutf2, discoutf3 ;
discoutf1 = 0.0001;
discoutf2 = 0.00003;
discoutf3 = 0.0001;

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
HubCost(hubs, periods) = %HBCST%*uniformint(200, 1000);


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

************************************************************************************************************************
************************************************************************************************************************
**************************************** Heuristic Procedure **************************************************
************************************************************************************************************************
************************************************************************************************************************
parameter Heuristictime;
Heuristictime = 0 ;

************* Phase 1: Randomized Exploration
set Totalsubprob /1*2/;
set samplesize /1*100/;
parameter sampledone, sampled, randomnum, samphubs(hubs), sampplants(plants);
parameter variableZstatus(hubs, periods);
parameter variableUstatus(plants, products);
parameter HPsize1, HPsize2;
parameter LPsize2(products);
parameter heurBestObj;
heurBestObj = inf;
parameter heurBestZsol(hubs, periods), heurBestUsol(plants, products) ;
loop(Totalsubprob,
        variableZstatus(hubs, periods) = 0;
        variableUstatus(plants, products) = 0;
* /------------------------------------- Parameter1 ------------------------------------/
        HPsize1 = uniformint(0, 2);
* /------------------------------------- Parameter2 ------------------------------------/
        HPsize2 = ceil(uniform(1.001, 5));
        sampledone = 0 ;
        sampled = 0;
        samphubs(hubs) = 0;
        loop(samplesize$(sampledone eq 0 and HPsize1 gt 0),
                   randomnum = ceil(uniform(0.001, card(hubs)));
                   loop(hubs,
                             if(ord(hubs) eq randomnum and samphubs(hubs) eq 0,
                                     samphubs(hubs) = 1;
                                     sampled = sampled + 1;
                                     variableZstatus(hubs, periods) = 1;
                                );
                        );
                   if(sampled ge HPsize1,
                             sampledone = 1;
                      );
             );
        sampledone = 0 ;
        sampled = 0;
        loop(samplesize$(sampledone eq 0 and HPsize2 gt 0),
                   randomnum = ceil(uniform(0.001, card(hubs)));
                   loop(hubs,
                             if(ord(hubs) eq randomnum and samphubs(hubs) eq 0,
                                     samphubs(hubs) = 1;
                                     sampled = sampled + 1;
                                     variableZstatus(hubs, periods) = 2;
                                );
                        );
                   if(sampled ge HPsize2,
                             sampledone = 1;
                      );
             );

        loop(products,
* /------------------------------------- Parameter3 ------------------------------------
                 LPsize2(products) = uniformint(1, 3);
                 sampledone = 0 ;
                 sampled = 0;
                 sampplants(plants) = 0;
                 loop(samplesize$(sampledone eq 0),
                            randomnum = ceil(uniform(0.001, card(plants)));
                            loop(plants,
                                      if(ord(plants) eq randomnum and sampplants(plants) eq 0,
                                              sampplants(plants) = 1;
                                              sampled = sampled + 1;
                                              variableUstatus(plants, products) = 2;
                                         );
                                 );
                            if(sampled ge LPsize2(products),
                                      sampledone = 1;
                               );
                      );
              );

*          display HPsize1, HPsize2, variableZstatus;
*          display LPsize2, variableUstatus ;

          Z.fx(hubs, periods)$(variableZstatus(hubs, periods) eq 0) = 0;
          Z.fx(hubs, periods)$(variableZstatus(hubs, periods) eq 1) = 1;
          U.fx(plants, products)$(variableUstatus(plants, products) eq 0) = 0;
          solve SupplyChain2 using mip minimizing totalcost2;
          Heuristictime = Heuristictime + SupplyChain2.etSolve;
*          display totalcost2.l;
          if(totalcost2.l le heurBestObj,
                  heurBestObj = totalcost2.l;
                  heurBestZsol(hubs, periods) = Z.l(hubs, periods);
                  heurBestUsol(plants, products) = U.l(plants, products);
             );
*          display heurBestObj;
          Z.up(hubs, periods) = 1;
          Z.lo(hubs, periods) = 0;
          U.up(plants, products) = 1;
          U.lo(plants, products) = 0;
     );

************* Phase 1: Neighborhood Exploitation
parameter totalhubsopen(periods);
totalhubsopen(periods) = sum(hubs, heurBestZsol(hubs, periods));


parameter releaseZnum(periods);
parameter releaseUpercentage;
set Totalsubprob2 /1*2/;
parameter iternoimprove;
iternoimprove = 0;
* /------------------------------------- Parameter4 ------------------------------------
parameter iternoimprovelimt;
iternoimprovelimt = 3;

loop(Totalsubprob2$(iternoimprove le iternoimprovelimt),
* /------------------------------------- Parameter5 ------------------------------------
         releaseZnum(periods) = uniformint(5, 8);
         variableZstatus(hubs, periods) = heurBestZsol(hubs, periods);
         loop(periods,
                  sampledone = 0 ;
                  sampled = 0;
                  samphubs(hubs) = 0;
                  loop(samplesize$(sampledone eq 0 and HPsize1 gt 0),
                            randomnum = ceil(uniform(0.001, card(hubs)));
                            loop(hubs,
                                      if(ord(hubs) eq randomnum and samphubs(hubs) eq 0,
                                              samphubs(hubs) = 1;
                                              sampled = sampled + 1;
                                              variableZstatus(hubs, periods) = 2;
                                         );
                                 );
                            if(sampled ge releaseZnum(periods),
                                      sampledone = 1;
                               );
                      );
              );
*          display variableZstatus;

* /------------------------------------- Parameter6 ------------------------------------
          releaseUpercentage = 0.5 ;
          variableUstatus(plants, products) = heurBestUsol(plants, products) ;
          loop(products,
                    loop(plants$(heurBestUsol(plants, products) eq 1),
                              randomnum = uniform(0.001, 1);
                              if(randomnum gt releaseUpercentage,
                                      variableUstatus(plants, products) = 2;
                                 );
                         );
               );
          loop(products,
* /------------------------------------- Parameter7 ------------------------------------
                 LPsize2(products) = uniformint(1, 3);
                 sampledone = 0 ;
                 sampled = 0;
                 sampplants(plants) = 0;
                 loop(samplesize$(sampledone eq 0),
                            randomnum = ceil(uniform(0.001, card(plants)));
                            loop(plants,
                                      if(ord(plants) eq randomnum and sampplants(plants) eq 0,
                                              sampplants(plants) = 1;
                                              sampled = sampled + 1;
                                              variableUstatus(plants, products) = 2;
                                         );
                                 );
                            if(sampled ge LPsize2(products),
                                      sampledone = 1;
                               );
                      );
              );
*          display variableUstatus;
          Z.fx(hubs, periods)$(variableZstatus(hubs, periods) eq 0) = 0;
          Z.fx(hubs, periods)$(variableZstatus(hubs, periods) eq 1) = 1;
          U.fx(plants, products)$(variableUstatus(plants, products) eq 0) = 0;
          U.fx(plants, products)$(variableUstatus(plants, products) eq 1) = 1;
          solve SupplyChain2 using mip minimizing totalcost2;
          Heuristictime = Heuristictime + SupplyChain2.etSolve;
          iternoimprove = iternoimprove + 1;
*          display totalcost2.l, iternoimprove;
          if(totalcost2.l lt heurBestObj,
                  heurBestObj = totalcost2.l;
                  heurBestZsol(hubs, periods) = Z.l(hubs, periods);
                  heurBestUsol(plants, products) = U.l(plants, products);
                  iternoimprove = 0;
             );
*          display heurBestObj;
          Z.up(hubs, periods) = 1;
          Z.lo(hubs, periods) = 0;
          U.up(plants, products) = 1;
          U.lo(plants, products) = 0;
     );

file LSPDHLBasicExactAlgorithm /LSPDHLBasicExactAlgorithm.dat/;
put LSPDHLBasicExactAlgorithm;
LSPDHLBasicExactAlgorithm.ap = 1;

************************************************************************************************************************
************************************************************************************************************************
**************************************** Benders Decomposition **************************************************
************************************************************************************************************************
************************************************************************************************************************

parameter zsol(hubs, periods), usol(plants, products);
zsol(hubs, periods) = heurBestZsol(hubs, periods) ;
usol(plants, products) = heurBestUsol(plants, products) ;

parameter maxtime;
maxtime = 3600 - Heuristictime;
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
cut(iter) 'Benders cut for optimal subproblem'
HubOpenMstr(periods)
;
parameters
cutconst(iter, products, periods) 'constant term in cuts'
cutcoeff1(iter, hubs, products, periods)
cutcoeff2(iter, plants, products, periods)
;

master_obj..  MasterCost =e= zetavar + sum((hubs, periods), HubCost(hubs, periods)*z(hubs, periods))
                                 + sum((plants, products), total_product_cost(plants, products)*U(plants, products)) ;

cut(cutset)..
              zetavar =g= sum((products, periods), cutconst(cutset, products, periods)) - sum((products, periods, hubs), cutcoeff1(cutset, hubs, products, periods)*z(hubs, periods))
                          - sum((products, periods, plants), cutcoeff2(cutset, plants, products, periods)*U(plants, products))  ;

HubOpenMstr(periods)..
         sum(hubs, z(hubs, periods)) =g= 1 ;

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
*parameter select_best(flows);
*parameter hubsopen_best(hubs);
parameter log(iter,*) 'logging info';
loop(iter$(not converged and totaltime lt maxtime),
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
option optcr=0;
solve master minimizing MasterCost using mip;
totaltime = totaltime + master.etSolve;
display master.etSolve;
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
LB = master.ObjEst;
log(iter,'LB') = LB;
log(iter,'UB') = UB;
iteration = ord(iter);
display iteration,LB,UB;
converged$( (UB-LB) < 0.001 ) = 1;
display$converged "Converged";
put  %ID%, %PLTSET%, %PRTSET%, %PRSET%, %HBSET%, totalopenhubs, totalprodcost,  " ", totalhubcost,  " ", totaltransportcost, " ",  iteration, "  ", LB, " ", UB, " ", heurBestObj, " ", Heuristictime, " ", totaltime ///
);
