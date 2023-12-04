*********************************************************************************************************************************************
**************** This description is for the S2-PHL10201010 data set generated for the computational tests of the IJOC paper ****************
**************************************** "Exact Method for Production Hub Location"    ******************************************************
********************************************************************************************************************************************* 

This data set contains 81 test instances with the ID number ranging from 1 to 81. The parameter settings of all 81 test instances are given as below: 

_______________________________________________________________________
ID	|L|	|K|	|T|	|H|	C_{d}	C_{pc}	C_{hc}	C_{tc}
_______________________________________________________________________
1	10	20	10	10	0.3	0.3	0.3	0.3
2	10	20	10	10	0.3	0.3	0.3	1
3	10	20	10	10	0.3	0.3	0.3	3
4	10	20	10	10	0.3	0.3	1	0.3
5	10	20	10	10	0.3	0.3	1	1
6	10	20	10	10	0.3	0.3	1	3
7	10	20	10	10	0.3	0.3	3	0.3
8	10	20	10	10	0.3	0.3	3	1
9	10	20	10	10	0.3	0.3	3	3
10	10	20	10	10	0.3	1	0.3	0.3
11	10	20	10	10	0.3	1	0.3	1
12	10	20	10	10	0.3	1	0.3	3
13	10	20	10	10	0.3	1	1	0.3
14	10	20	10	10	0.3	1	1	1
15	10	20	10	10	0.3	1	1	3
16	10	20	10	10	0.3	1	3	0.3
17	10	20	10	10	0.3	1	3	1
18	10	20	10	10	0.3	1	3	3
19	10	20	10	10	0.3	3	0.3	0.3
20	10	20	10	10	0.3	3	0.3	1
21	10	20	10	10	0.3	3	0.3	3
22	10	20	10	10	0.3	3	1	0.3
23	10	20	10	10	0.3	3	1	1
24	10	20	10	10	0.3	3	1	3
25	10	20	10	10	0.3	3	3	0.3
26	10	20	10	10	0.3	3	3	1
27	10	20	10	10	0.3	3	3	3
28	10	20	10	10	1	0.3	0.3	0.3
29	10	20	10	10	1	0.3	0.3	1
30	10	20	10	10	1	0.3	0.3	3
31	10	20	10	10	1	0.3	1	0.3
32	10	20	10	10	1	0.3	1	1
33	10	20	10	10	1	0.3	1	3
34	10	20	10	10	1	0.3	3	0.3
35	10	20	10	10	1	0.3	3	1
36	10	20	10	10	1	0.3	3	3
37	10	20	10	10	1	1	0.3	0.3
38	10	20	10	10	1	1	0.3	1
39	10	20	10	10	1	1	0.3	3
40	10	20	10	10	1	1	1	0.3
41	10	20	10	10	1	1	1	1
42	10	20	10	10	1	1	1	3
43	10	20	10	10	1	1	3	0.3
44	10	20	10	10	1	1	3	1
45	10	20	10	10	1	1	3	3
46	10	20	10	10	1	3	0.3	0.3
47	10	20	10	10	1	3	0.3	1
48	10	20	10	10	1	3	0.3	3
49	10	20	10	10	1	3	1	0.3
50	10	20	10	10	1	3	1	1
51	10	20	10	10	1	3	1	3
52	10	20	10	10	1	3	3	0.3
53	10	20	10	10	1	3	3	1
54	10	20	10	10	1	3	3	3
55	10	20	10	10	3	0.3	0.3	0.3
56	10	20	10	10	3	0.3	0.3	1
57	10	20	10	10	3	0.3	0.3	3
58	10	20	10	10	3	0.3	1	0.3
59	10	20	10	10	3	0.3	1	1
60	10	20	10	10	3	0.3	1	3
61	10	20	10	10	3	0.3	3	0.3
62	10	20	10	10	3	0.3	3	1
63	10	20	10	10	3	0.3	3	3
64	10	20	10	10	3	1	0.3	0.3
65	10	20	10	10	3	1	0.3	1
66	10	20	10	10	3	1	0.3	3
67	10	20	10	10	3	1	1	0.3
68	10	20	10	10	3	1	1	1
69	10	20	10	10	3	1	1	3
70	10	20	10	10	3	1	3	0.3
71	10	20	10	10	3	1	3	1
72	10	20	10	10	3	1	3	3
73	10	20	10	10	3	3	0.3	0.3
74	10	20	10	10	3	3	0.3	1
75	10	20	10	10	3	3	0.3	3
76	10	20	10	10	3	3	1	0.3
77	10	20	10	10	3	3	1	1
78	10	20	10	10	3	3	1	3
79	10	20	10	10	3	3	3	0.3
80	10	20	10	10	3	3	3	1
81	10	20	10	10	3	3	3	3
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
