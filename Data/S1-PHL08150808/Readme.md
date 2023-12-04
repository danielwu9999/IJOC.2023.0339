*********************************************************************************************************************************************
**************** This description is for the S1-PHL08150808 data set generated for the computational tests of the IJOC paper ****************
**************************************** "Exact Method for Production Hub Location"    ******************************************************
********************************************************************************************************************************************* 

This data set contains 81 test instances with the ID number ranging from 1 to 81. The parameter settings of all 81 test instances are given as below: 

_______________________________________________________________________
ID	|L|	|K|	|T|	|H|	C_{d}	C_{pc}	C_{hc}	C_{tc}
_______________________________________________________________________
1	8	15	8	8	0.3	0.3	0.3	0.3
2	8	15	8	8	0.3	0.3	0.3	1
3	8	15	8	8	0.3	0.3	0.3	3
4	8	15	8	8	0.3	0.3	1	0.3
5	8	15	8	8	0.3	0.3	1	1
6	8	15	8	8	0.3	0.3	1	3
7	8	15	8	8	0.3	0.3	3	0.3
8	8	15	8	8	0.3	0.3	3	1
9	8	15	8	8	0.3	0.3	3	3
10	8	15	8	8	0.3	1	0.3	0.3
11	8	15	8	8	0.3	1	0.3	1
12	8	15	8	8	0.3	1	0.3	3
13	8	15	8	8	0.3	1	1	0.3
14	8	15	8	8	0.3	1	1	1
15	8	15	8	8	0.3	1	1	3
16	8	15	8	8	0.3	1	3	0.3
17	8	15	8	8	0.3	1	3	1
18	8	15	8	8	0.3	1	3	3
19	8	15	8	8	0.3	3	0.3	0.3
20	8	15	8	8	0.3	3	0.3	1
21	8	15	8	8	0.3	3	0.3	3
22	8	15	8	8	0.3	3	1	0.3
23	8	15	8	8	0.3	3	1	1
24	8	15	8	8	0.3	3	1	3
25	8	15	8	8	0.3	3	3	0.3
26	8	15	8	8	0.3	3	3	1
27	8	15	8	8	0.3	3	3	3
28	8	15	8	8	1	0.3	0.3	0.3
29	8	15	8	8	1	0.3	0.3	1
30	8	15	8	8	1	0.3	0.3	3
31	8	15	8	8	1	0.3	1	0.3
32	8	15	8	8	1	0.3	1	1
33	8	15	8	8	1	0.3	1	3
34	8	15	8	8	1	0.3	3	0.3
35	8	15	8	8	1	0.3	3	1
36	8	15	8	8	1	0.3	3	3
37	8	15	8	8	1	1	0.3	0.3
38	8	15	8	8	1	1	0.3	1
39	8	15	8	8	1	1	0.3	3
40	8	15	8	8	1	1	1	0.3
41	8	15	8	8	1	1	1	1
42	8	15	8	8	1	1	1	3
43	8	15	8	8	1	1	3	0.3
44	8	15	8	8	1	1	3	1
45	8	15	8	8	1	1	3	3
46	8	15	8	8	1	3	0.3	0.3
47	8	15	8	8	1	3	0.3	1
48	8	15	8	8	1	3	0.3	3
49	8	15	8	8	1	3	1	0.3
50	8	15	8	8	1	3	1	1
51	8	15	8	8	1	3	1	3
52	8	15	8	8	1	3	3	0.3
53	8	15	8	8	1	3	3	1
54	8	15	8	8	1	3	3	3
55	8	15	8	8	3	0.3	0.3	0.3
56	8	15	8	8	3	0.3	0.3	1
57	8	15	8	8	3	0.3	0.3	3
58	8	15	8	8	3	0.3	1	0.3
59	8	15	8	8	3	0.3	1	1
60	8	15	8	8	3	0.3	1	3
61	8	15	8	8	3	0.3	3	0.3
62	8	15	8	8	3	0.3	3	1
63	8	15	8	8	3	0.3	3	3
64	8	15	8	8	3	1	0.3	0.3
65	8	15	8	8	3	1	0.3	1
66	8	15	8	8	3	1	0.3	3
67	8	15	8	8	3	1	1	0.3
68	8	15	8	8	3	1	1	1
69	8	15	8	8	3	1	1	3
70	8	15	8	8	3	1	3	0.3
71	8	15	8	8	3	1	3	1
72	8	15	8	8	3	1	3	3
73	8	15	8	8	3	3	0.3	0.3
74	8	15	8	8	3	3	0.3	1
75	8	15	8	8	3	3	0.3	3
76	8	15	8	8	3	3	1	0.3
77	8	15	8	8	3	3	1	1
78	8	15	8	8	3	3	1	3
79	8	15	8	8	3	3	3	0.3
80	8	15	8	8	3	3	3	1
81	8	15	8	8	3	3	3	3
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


 

