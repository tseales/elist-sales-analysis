# Elist Sales Analysis

## About Our Company & Data
Founded in 2018, Elist is an e-commerce company that sells popular electronics products and has since expanded to a global customer base. With this expansion, Elist has become interested in conducting a 2019-2022 analysis for uncovering insights that can further progress the organization. This project conducts a focused analysis, investigating trends in MoM & YoY sales, average order value, growth rates, refund rates, and loyalty program performance. The insights garnered will be used for reporting to the Head of Operations, informing teams - Finance, Sales, Product, Marketing - across the company on opportune areas of growth/improvement in a competitive e-commerce landscape.

An Excel binary workbook can be found [here](https://github.com/tseales/Elist-Sales-Analysis/blob/63f3f72027eed56ee4edcd3539571439e38cc00d/excel/Elist%20Analysis.xlsb). Supplemental SQL queries used for analysis can be found [here](https://github.com/tseales/Elist-Sales-Analysis/blob/26637fb84fc2e7795798d75111d2d524489c4226/sql/sql-analysis.sql).

## [ERD](https://github.com/tseales/Elist-Sales-Analysis/blob/63f3f72027eed56ee4edcd3539571439e38cc00d/sql/ERD.md)
![erd](https://github.com/user-attachments/assets/7058ad8d-2c50-439f-b5bf-3e5b26e39388)
</br></br>

## Interactive Tableau Dashboard
An interactive *Tableau Public* dashboard can be found [here](https://public.tableau.com/views/Elist/Dashboard2-horizontal?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link). This dashboard focuses on Sales & Orders, enabling stakeholders to garner comparative insights on the selected year's metrics vs. its predecessor. 

![elist-tableau](https://github.com/user-attachments/assets/8185b3e3-85dd-4bb6-b9ae-e6257993e568)
</br></br>

## Summary of Insights
<details>
<summary>Stakeholder Initial Questions</summary>
  - What were the overall trends in sales during 2019-2022?</br>
  - What were our monthly and yearly growth rates?</br>
  - How is the new loyalty program performing? Should we keep using it?
</details>

Conducting an analysis on 108k+ sales records for the years 2019-2022, key insights in the following areas were made:
### 1) Seasonality
- **Elist observes a notable holiday surge during the months of November & December**.
  - Increasing 21% & 22% on average, respectively, after consistent declines in October (average -31%). This correlates with general seasonal trends of increased consumer spending during the end-of-year Holiday season - commonly seen in North America - for things such as gift-giving and holiday sales.
- **Sales subsequently fell (average -18%) during the January & February months**.
  - Following the aforementioned seasonal spending trend - this reduction can be indicative of consumer spending decreasing after frequent high-spending during the latter months of the year. Notably, there is a spike in sales during 2020, due to the inception of Covid and increased consumer spending to account for the shift to remote work:

![new-MoM-trends](https://github.com/user-attachments/assets/9abd1900-8804-4d46-98aa-ed11983c05f0)
</br></br>

### 2) Product & Regional Segmentation
- **Elist generated $28.1M in total sales**.
  - The "27in 4k gaming monitor" has consitently been the highest selling product. Additionally, while investigating the notable spike in 2020 total sales, the "Macbook Air Laptop" was also found to undergo a sharp increase in sales & is likely the main product responsible for the overall surge. This is likely correlated to the inception of Covid-19 and the 2020 shift to remote work/opportunities, causing consumers - e.g. students - to purchase laptops for adjusting to this social change.
  - Our lowest selling product, "Bose Soundsport Headphones", consisently performs relatively poorly in sales. When taking a bird's eye view at regional product sales, our highest selling product remains consistent amongst all regions - while our lowest selling product is also consistently the worst performer.
- **North America makes up the most of our global sales**.
  - 52% being attributed to this region, contrasting with the Latin American region having the lowest percentage of sales (6%).
  - Overall, Elist's main contributors to sales are high-end gaming monitors, Apple headphones, and laptops.
- **The most popular product across all regions, based on total orders, is "Apple Airpods Headphones"**.
  - This product was found to unequivocally lead this ranking. It does, however, also lead the ranking in total amount of refunds at 2.6K - although, it does have a relatively smaller refund rate at 5.4%, when comparing to the highest refunded "ThinkPad Laptop" product with a rate of 11.7%.

![product-analysis](https://github.com/user-attachments/assets/3825056c-cd17-4a4e-9f2b-ff773fee9c62)
![regional-perf](https://github.com/user-attachments/assets/dc6e07d7-95e8-4818-a318-0f3c16b60f55)
</br></br>

### 3) Loyalty Program
- **The loyalty program seemed to perform exponentially well during the 2020 spike in total sales, outperforming 2019.**
  - While measurements - total sales, AOV, total orders - throughout 2019 & 2020 were less than its non-loyalty counterpart, loyalty program performance began to outpace that of non-loyalty during 2021 & 2022, realizing sales gains of $544k on average. However, loyalty program performance declined in 2022, likely correlating to a reduced consumer need for specific Elist product offerings due to the social shift of returning to in-person work/opportunities.
  - Both loyalty & non-loyalty customers comprised most of their sales from a 'direct' marketing channel - appx. 76% and 86% respectively - meaning that they purchased directly from the Elist site, via a search engine's link. Email marketing campaigns came in second for overall contributions to sales, making-up appx. 19% of overall loyalty sales & 7% of non-loyalty.
  - Loyalty customers were found to take ~30% less time than non-loyalty customers in making a purchase after account creation.

![loyalty-program2](https://github.com/user-attachments/assets/a45b67b8-8420-4376-b3f3-ff77dcdea22b)

## Recommendations
1. **Continue the loyalty program & investigate the drop in sales & AOV.**
    - While the loyalty program metrics are outperforming non-loyalty, an understanding of contributing factors to the recent drop in total sales & AOV can provide direction on ensuring that this continues to do well. Further understanding factors correlated with loyalty customers' purchases - e.g., relative marketing channels, types of products purchased, customer's value from being in the program - can provide supplemental insight into paths available to be taken for increasing the vigor of the program. It would be worth continuing the loyalty program for atleast another year to allow for a more comprehensive understanding of its performance.

2. **Investigate expanding product catalog.**
    - With high-end gaming monitors, Apple headphones, and laptops comprising most of Elist's sales, expanding product offerings to align more with the charactersitics of current high-selling products will likely result in increased sales. A supplemental investigation into factors contributing to the high amount of refunds for "Apple Airpods Headphones" may provide direction on the type(s) of headphones Elist may want to consider offering. It is important to note, that while this may also increase the AOV, customer-sentiment will likely be important to take note of - ensuring that overall orders stay consistent, despite the inclusion of any additional higher-priced items. A possible way to mitigate, could be to increase customer-value in certain facets of the loyalty program *(see Recommendation 1)* - possibly increasing loyalty program sign-ups and sales. 

3. **Investigate higher sales in NA region.**
    - Understanding contributing sales factors in the NA region could provide direction for focused marketing efforts to ensure sales remain consistent & are improved, while allowing for an identification of factors that can be used for finding similar markets that Elist is likely to perform well in. In the same way, understanding contributing factors - like locality - that may play a role in the lower sales numbers for worse-performing regions, such as LATAM, can provide direction on areas Elist may want to avoid, or, focus on strengthening to better expand into the global market.
