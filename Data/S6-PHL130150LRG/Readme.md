*********************************************************************************************************************************************
**************** This description is for the S6-PHL130150LRG data set generated for the computational tests of the IJOC paper ****************
**************************************** "Exact Method for Production Hub Location"    ******************************************************
********************************************************************************************************************************************* 

This data set contains 36 test instances with the ID number ranging from 1 to 36. The parameter settings of all 36 test instances are given as below: 

_______________________________________________________________________
ID	|L|	|K|	|T|	|H|	C_{d}	C_{pc}	C_{hc}	C_{tc}
_______________________________________________________________________
1	40	60	6	30	1	1	10	1
2	40	60	6	30	1	1	10	1
3	40	60	6	30	1	1	10	1
4	40	55	6	35	1	1	10	1
5	40	55	6	35	1	1	10	1
6	40	55	6	35	1	1	10	1
7	35	60	6	35	1	1	10	1
8	35	60	6	35	1	1	10	1
9	35	60	6	35	1	1	10	1
10	45	55	6	30	1	1	10	1
11	45	55	6	30	1	1	10	1
12	45	55	6	30	1	1	10	1
13	45	60	6	35	1	1	10	1
14	45	60	6	35	1	1	10	1
15	45	60	6	35	1	1	10	1
16	45	55	6	40	1	1	10	1
17	45	55	6	40	1	1	10	1
18	45	55	6	40	1	1	10	1
19	40	60	6	40	1	1	10	1
20	40	60	6	40	1	1	10	1
21	40	60	6	40	1	1	10	1
22	50	55	6	35	1	1	10	1
23	50	55	6	35	1	1	10	1
24	50	55	6	35	1	1	10	1
25	45	65	6	40	1	1	10	1
26	45	65	6	40	1	1	10	1
27	45	65	6	40	1	1	10	1
28	50	55	6	45	1	1	10	1
29	50	55	6	45	1	1	10	1
30	50	55	6	45	1	1	10	1
31	45	60	6	45	1	1	10	1
32	45	60	6	45	1	1	10	1
33	45	60	6	45	1	1	10	1
34	50	60	6	40	1	1	10	1
35	50	60	6	40	1	1	10	1
36	50	60	6	40	1	1	10	1
_______________________________________________________________________


In each data file, the parameter values are given in the below sequence:

1. PHdistance(plants, hubs) - The distance between plants and hubs.
2. HHdistance(hubs1, hubs2) - The distance between hub1 and hub2.
3. HPDdistance(hubs, products) - The distance between hubs and product demand locations.
4. PCoordinate(plants, X-or-Y) - The plant coordinates 1=X, 2=Y.
5. HCoordinate(hubs, X-or-Y) - The hub coordinates 1=X, 2=Y.
6. ProdCoordinate(products, X-or-Y) - The product location coordinates 1=X, 2=Y.
7. values(products) (v_k) - Transportation cost weights for products.
8. demands(products, periods) - Product demand by periods.
9. prodcost(products, plants, periods) - Production costs by products, plants, and periods.
10. InvCost(products, plants, periods) - Inventory costs by products, plants, and periods.
11. setCost(products, plants, periods) - Setup costs by products, plants, and periods.
12. HubCost(hubs, periods) - Hub costs by hubs and periods.

For each parameter, indices are given first, and parameter values are given at last.
Let's take PHdistance(plants, hubs) for example, index of plants is given in the first column, index of hubs is given
in the second column, and values of PHdistance(plants, hubs) are given in the third column.

************************************************************************************************************************************************************ 
************************************************************ END of DESCRIPTION ****************************************************************************
************************************************************************************************************************************************************ 


 

