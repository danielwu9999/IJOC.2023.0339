1. The folder "1-Economies of scale" contains 110 instances. Their naming style is EconomyOfScale - Seed number for generating parameter values - Coefficients of economies of scale (C_{eos}) - ID.  The computational results of these test instances are given in Folder "Results/S5-PHL03600410E/Online Supplement Figure 2". 

2. The folder "2-Hub operating cost" contains 190 instances. Their naming style is HubCost - Seed number for generating parameter values - Coefficients of hub costs (C_{hc}) - ID.  The computational results of these test instances are given in Folder "Results/S5-PHL03600410E/Figure 6". 

3. The folder "3-Network property" contains 190 instances with undistributed networks. Their naming style is HubCost-Undistributed - Seed number for generating parameter values - Coefficients of hub costs (C_{hc}) - ID. 

4. The folder "4-Deviation of production costs" contains 400 instances. Their naming style is ProdCostDeviation - Seed number for generating parameter values - ID.  The computational results of these test instances are given in Folder "Results/S5-PHL03600410E/Online Supplement Figure 4".

5. The folder "5-Cost ratio" contains 200 instances. Their naming style is CostRatio - Seed number for generating parameter values - Ratio - ID.  The computational results of these test instances are given in Folder "Results/S5-PHL03600410E/Online Supplement Figure 5". 

6. The folder "6-Deviation of hub operating costs" contains 200 instances. Their naming style is HubCost - Seed number for generating parameter values - Coefficients of hub costs (C_{hc}) - Hub Cost Factors (HBCSTF) - ID.  The computational results of these test instances are given in Folder "Results/S5-PHL03600410E/Online Supplement Figure 6". 


In each data file within these folders, the parameter values are given in the below sequence:

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
