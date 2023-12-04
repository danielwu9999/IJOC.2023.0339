*********************************************************************************************************************************************
**************** This description is for the S4-PHL03600410 data set generated for the computational tests of the IJOC paper ****************
**************************************** "Exact Method for Production Hub Location"    ******************************************************
********************************************************************************************************************************************* 

This data set contains 81 test instances with the ID number ranging from 1 to 81. The parameter settings of all 81 test instances are given as below: 

_______________________________________________________________________
ID	|L|	|K|	|T|	|H|	C_{d}	C_{pc}	C_{hc}	C_{tc}
_______________________________________________________________________
1	3	60	4	10	0.3	0.3	0.3	0.3
2	3	60	4	10	0.3	0.3	0.3	1
3	3	60	4	10	0.3	0.3	0.3	3
4	3	60	4	10	0.3	0.3	1	0.3
5	3	60	4	10	0.3	0.3	1	1
6	3	60	4	10	0.3	0.3	1	3
7	3	60	4	10	0.3	0.3	3	0.3
8	3	60	4	10	0.3	0.3	3	1
9	3	60	4	10	0.3	0.3	3	3
10	3	60	4	10	0.3	1	0.3	0.3
11	3	60	4	10	0.3	1	0.3	1
12	3	60	4	10	0.3	1	0.3	3
13	3	60	4	10	0.3	1	1	0.3
14	3	60	4	10	0.3	1	1	1
15	3	60	4	10	0.3	1	1	3
16	3	60	4	10	0.3	1	3	0.3
17	3	60	4	10	0.3	1	3	1
18	3	60	4	10	0.3	1	3	3
19	3	60	4	10	0.3	3	0.3	0.3
20	3	60	4	10	0.3	3	0.3	1
21	3	60	4	10	0.3	3	0.3	3
22	3	60	4	10	0.3	3	1	0.3
23	3	60	4	10	0.3	3	1	1
24	3	60	4	10	0.3	3	1	3
25	3	60	4	10	0.3	3	3	0.3
26	3	60	4	10	0.3	3	3	1
27	3	60	4	10	0.3	3	3	3
28	3	60	4	10	1	0.3	0.3	0.3
29	3	60	4	10	1	0.3	0.3	1
30	3	60	4	10	1	0.3	0.3	3
31	3	60	4	10	1	0.3	1	0.3
32	3	60	4	10	1	0.3	1	1
33	3	60	4	10	1	0.3	1	3
34	3	60	4	10	1	0.3	3	0.3
35	3	60	4	10	1	0.3	3	1
36	3	60	4	10	1	0.3	3	3
37	3	60	4	10	1	1	0.3	0.3
38	3	60	4	10	1	1	0.3	1
39	3	60	4	10	1	1	0.3	3
40	3	60	4	10	1	1	1	0.3
41	3	60	4	10	1	1	1	1
42	3	60	4	10	1	1	1	3
43	3	60	4	10	1	1	3	0.3
44	3	60	4	10	1	1	3	1
45	3	60	4	10	1	1	3	3
46	3	60	4	10	1	3	0.3	0.3
47	3	60	4	10	1	3	0.3	1
48	3	60	4	10	1	3	0.3	3
49	3	60	4	10	1	3	1	0.3
50	3	60	4	10	1	3	1	1
51	3	60	4	10	1	3	1	3
52	3	60	4	10	1	3	3	0.3
53	3	60	4	10	1	3	3	1
54	3	60	4	10	1	3	3	3
55	3	60	4	10	3	0.3	0.3	0.3
56	3	60	4	10	3	0.3	0.3	1
57	3	60	4	10	3	0.3	0.3	3
58	3	60	4	10	3	0.3	1	0.3
59	3	60	4	10	3	0.3	1	1
60	3	60	4	10	3	0.3	1	3
61	3	60	4	10	3	0.3	3	0.3
62	3	60	4	10	3	0.3	3	1
63	3	60	4	10	3	0.3	3	3
64	3	60	4	10	3	1	0.3	0.3
65	3	60	4	10	3	1	0.3	1
66	3	60	4	10	3	1	0.3	3
67	3	60	4	10	3	1	1	0.3
68	3	60	4	10	3	1	1	1
69	3	60	4	10	3	1	1	3
70	3	60	4	10	3	1	3	0.3
71	3	60	4	10	3	1	3	1
72	3	60	4	10	3	1	3	3
73	3	60	4	10	3	3	0.3	0.3
74	3	60	4	10	3	3	0.3	1
75	3	60	4	10	3	3	0.3	3
76	3	60	4	10	3	3	1	0.3
77	3	60	4	10	3	3	1	1
78	3	60	4	10	3	3	1	3
79	3	60	4	10	3	3	3	0.3
80	3	60	4	10	3	3	3	1
81	3	60	4	10	3	3	3	3
_______________________________________________________________________


In each data file, the parameter values are given in the below sequence:

1. PHdistance(plants, hubs) - The distance between plants and hubs.
2. HHdistance(hubs1, hubs2) - The distance between hub1 and hub2.
3. HPDdistance(hubs, products) - The distance between hubs and product demand locations.
4. PCoordinate(plants, latitude-or-longitude) - The plant coordinates 1=latitude, 2=longitude.
5. HCoordinate(hubs, latitude-or-longitude) - The hub coordinates 1=latitude, 2=longitude.
6. ProdCoordinate(products, latitude-or-longitude) - The product location coordinates 1=latitude, 2=longitude.
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


 

