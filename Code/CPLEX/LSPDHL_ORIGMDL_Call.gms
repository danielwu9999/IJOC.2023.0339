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
SupplyChain.reslim = 3600;
SupplyChain.optca = 0.000;
SupplyChain.optcr = 0.000;
SupplyChain.iterlim = 4000000;
solve SupplyChain using mip minimizing totalcost;
parameter optobj;
optobj = totalcost.l;
display optobj ;
parameter modelsolvetime;
modelsolvetime = SupplyChain.etSolve;
parameter modelsovstatus;
modelsovstatus = SupplyChain.modelstat ;
parameter LowerB;
LowerB = SupplyChain.ObjEst;

parameter prodcostout, setupcotout, inventorycostout, hubrentcostout, transcostout;
prodcostout = sum((plants, products, periods), prodcost(products, plants, periods)*X.l(plants, products, periods));
setupcotout = sum((plants, products, periods), setCost(products, plants, periods)*Y.l(plants, products, periods));
inventorycostout = sum((plants, products, periods), InvCost(products, plants, periods)*I.l(plants, products, periods));
hubrentcostout = sum((hubs, periods), HubCost(hubs, periods)*Z.l(hubs, periods)) ;
transcostout = sum((plants, hubs1, hubs2, products, periods)$(hubspp(plants, products, hubs1, hubs2, periods)), transcost(plants, hubs1, hubs2, products, periods)*F.l(plants, products, hubs1, hubs2, periods));
display prodcostout ;
display setupcotout ;
display inventorycostout ;
display hubrentcostout ;
display transcostout ;
display Z.l;
display modelsolvetime;

parameter totalopenhubs;
totalopenhubs = sum((hubs, periods), Z.l(hubs, periods));

file LSPDHL_ORIGMDL_Call /LSPDHL_ORIGMDL_Call.dat/;
put LSPDHL_ORIGMDL_Call;
LSPDHL_ORIGMDL_Call.ap = 1;
put  %ID%, %PLTSET%, %PRTSET%, %PRSET%, %HBSET%, totalopenhubs, prodcostout,  " ", setupcotout,  " ", inventorycostout,  " ", hubrentcostout, " ",  transcostout, " ",  LowerB, "  ", optobj, " ", modelsovstatus, " ", modelsolvetime ///
