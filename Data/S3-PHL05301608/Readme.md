*********************************************************************************************************************************************
**************** This description is for the S3-PHL05301608 data set generated for the computational tests of the IJOC paper ****************
**************************************** "Exact Method for Production Hub Location"    ******************************************************
********************************************************************************************************************************************* 

This data set contains 81 test instances with the ID number ranging from 1 to 81. The parameter settings of all 81 test instances are given as below: 

_______________________________________________________________________
ID	|L|	|K|	|T|	|H|	C_{d}	C_{pc}	C_{hc}	C_{tc}
_______________________________________________________________________
1	5	30	16	8	0.3	0.3	0.3	0.3
2	5	30	16	8	0.3	0.3	0.3	1
3	5	30	16	8	0.3	0.3	0.3	3
4	5	30	16	8	0.3	0.3	1	0.3
5	5	30	16	8	0.3	0.3	1	1
6	5	30	16	8	0.3	0.3	1	3
7	5	30	16	8	0.3	0.3	3	0.3
8	5	30	16	8	0.3	0.3	3	1
9	5	30	16	8	0.3	0.3	3	3
10	5	30	16	8	0.3	1	0.3	0.3
11	5	30	16	8	0.3	1	0.3	1
12	5	30	16	8	0.3	1	0.3	3
13	5	30	16	8	0.3	1	1	0.3
14	5	30	16	8	0.3	1	1	1
15	5	30	16	8	0.3	1	1	3
16	5	30	16	8	0.3	1	3	0.3
17	5	30	16	8	0.3	1	3	1
18	5	30	16	8	0.3	1	3	3
19	5	30	16	8	0.3	3	0.3	0.3
20	5	30	16	8	0.3	3	0.3	1
21	5	30	16	8	0.3	3	0.3	3
22	5	30	16	8	0.3	3	1	0.3
23	5	30	16	8	0.3	3	1	1
24	5	30	16	8	0.3	3	1	3
25	5	30	16	8	0.3	3	3	0.3
26	5	30	16	8	0.3	3	3	1
27	5	30	16	8	0.3	3	3	3
28	5	30	16	8	1	0.3	0.3	0.3
29	5	30	16	8	1	0.3	0.3	1
30	5	30	16	8	1	0.3	0.3	3
31	5	30	16	8	1	0.3	1	0.3
32	5	30	16	8	1	0.3	1	1
33	5	30	16	8	1	0.3	1	3
34	5	30	16	8	1	0.3	3	0.3
35	5	30	16	8	1	0.3	3	1
36	5	30	16	8	1	0.3	3	3
37	5	30	16	8	1	1	0.3	0.3
38	5	30	16	8	1	1	0.3	1
39	5	30	16	8	1	1	0.3	3
40	5	30	16	8	1	1	1	0.3
41	5	30	16	8	1	1	1	1
42	5	30	16	8	1	1	1	3
43	5	30	16	8	1	1	3	0.3
44	5	30	16	8	1	1	3	1
45	5	30	16	8	1	1	3	3
46	5	30	16	8	1	3	0.3	0.3
47	5	30	16	8	1	3	0.3	1
48	5	30	16	8	1	3	0.3	3
49	5	30	16	8	1	3	1	0.3
50	5	30	16	8	1	3	1	1
51	5	30	16	8	1	3	1	3
52	5	30	16	8	1	3	3	0.3
53	5	30	16	8	1	3	3	1
54	5	30	16	8	1	3	3	3
55	5	30	16	8	3	0.3	0.3	0.3
56	5	30	16	8	3	0.3	0.3	1
57	5	30	16	8	3	0.3	0.3	3
58	5	30	16	8	3	0.3	1	0.3
59	5	30	16	8	3	0.3	1	1
60	5	30	16	8	3	0.3	1	3
61	5	30	16	8	3	0.3	3	0.3
62	5	30	16	8	3	0.3	3	1
63	5	30	16	8	3	0.3	3	3
64	5	30	16	8	3	1	0.3	0.3
65	5	30	16	8	3	1	0.3	1
66	5	30	16	8	3	1	0.3	3
67	5	30	16	8	3	1	1	0.3
68	5	30	16	8	3	1	1	1
69	5	30	16	8	3	1	1	3
70	5	30	16	8	3	1	3	0.3
71	5	30	16	8	3	1	3	1
72	5	30	16	8	3	1	3	3
73	5	30	16	8	3	3	0.3	0.3
74	5	30	16	8	3	3	0.3	1
75	5	30	16	8	3	3	0.3	3
76	5	30	16	8	3	3	1	0.3
77	5	30	16	8	3	3	1	1
78	5	30	16	8	3	3	1	3
79	5	30	16	8	3	3	3	0.3
80	5	30	16	8	3	3	3	1
81	5	30	16	8	3	3	3	3
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


 

