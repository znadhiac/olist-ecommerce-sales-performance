# **OLIST BRAZILIAN E-COMMERCE SALES PERFORMANCE ANALYSIS** 
### Author: Zulfi Nadhia Cahyani 

## **I. PROJECT OVERVIEW**  

This project analyzes the Olist Brazilian e-commerce dataset to uncover insights that support data-driven decision-making in an online retail environment. Olist connects small and medium-sized sellers with customers across Brazil, making the dataset well suited for examining sales performance, customer purchasing behavior, logistics efficiency, and customer satisfaction. Using the Kaggle dataset, SQL techniques such as joins, aggregations, window functions, and time-based analysis are applied to extract actionable insights related to revenue drivers, operational efficiency, and customer experience. The findings translate raw transactional data into meaningful business insights applicable to real-world e-commerce decision-making.  

---

## **II. BUSINESS QUESTIONS**  

1. **Sales and Revenue Performance** 
    - What were the total orders and total revenue per month?
    - Which products generated the highest revenue and had the most orders?
    - What is the average order value (AOV) per customer?
    - Which sellers generated the highest revenue?
    - Which states contributed the most to total revenue?  

2. **Customer Behavior** 
    - How many unique customers placed orders each month?
    - Who are the top customers by total spending?  

3. **Delivery and Operational Metrics** 
    - What is the average delivery time per order?
    - Which sellers and states have the fastest or slowest delivery times?
    - How many deliveries were late?  

4. **Customer Feedback/ Satisfaction** 
    - What is the average review score per product?
    - Is there a correlation between delay delivery time and review score?

---

## **III. OBJECTIVES**  

1. Analyze sales and revenue performance, including monthly trends, top products and sellers, regional contributions, and average order value (AOV).  
2. Examine customer behavior by tracking customer activity over time and identifying high-value customers.  
3. Evaluate delivery and operational performance by assessing delivery times, late deliveries, and variations across sellers and regions.  
4. Assess customer satisfaction through review scores and analyze its relationship with delivery performance.  
5. Deliver actionable insights to support operational efficiency, improve customer experience, and enable data-driven decision-making.  

---

## **IV. DATASET**  

**Source:** [**Olist E-commerce Dataset on Kaggle**](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)  

**Tables Used:**  
- **Customers:** dimension table storing customer information.  
- **Orders:** fact table containing order-level details.  
- **Order Items:** fact table with item-level order details.  
- **Order Payments:** fact table with payment details.  
- **Order Reviews:** table containing customer feedback and review scores.  
- **Products:** dimension table with product attributes.  
- **Sellers:** dimension table with seller information.  
- **Product Category Translation:** maps product categories from Portuguese to English.  

**Excluded Tables:** **Geolocation** (not used in analysis)  

**Timeframe:** Analysis focused on **orders from 2018** to limit dataset size and ensure efficiency.  

---

## **V. DATA MODEL OVERVIEW**  

The data is structured as a **relational model** with fact and dimension tables to support join-based analysis and actionable insights across orders, customers, products, and sellers.  Referential integrity is maintained through **primary key–foreign key relationships**, ensuring reliable joins and accurate aggregations.  

- **Primary Keys (PK)** uniquely identify each record in a table.  
- **Foreign Keys (FK)** are fields in a table that reference primary keys in another table to maintain relationships and ensure referential integrity.   

**Fact Tables:**  
- **Orders** (PK: `order_id`, FK: `customer_id`)  
- **Order Items** (PK: `order_item_id`, FK: `order_id`, `product_id`, `seller_id`)  
- **Order Payments** (FK: `order_id`)  
- **Order Reviews** (PK: `review_id`, FK: `order_id`)  

**Dimension Tables:**  
- **Customers** (PK: `customer_id`)  
- **Products** (PK: `product_id`)  
- **Sellers** (PK: `seller_id`)  
- **Product Category Translation** (PK: `product_category_name`)  

**Data Cleaning:**  
Data cleaning was performed using **Python (Pandas)**, including handling missing values, duplicates, correcting data types, and filtering for **2018 orders** to ensure dataset consistency and analysis efficiency. Data analysis and queries were conducted using **MySQL**, leveraging the relational structure to extract insights efficiently.  

---

## **VI. KEY INSIGHTS**  

### **VI.1 Sales and Revenue Performance**  

#### **VI.1.1 Total Orders and Total Revenue per Month**  
1. Highest revenue months are April ($965,546.19) and May ($974,447.65), despite not having the highest order count. This suggests that either the items sold were higher-priced on average.  
2. February ($813,775.15) and August ($836,377.59) are the lowest revenue months, possibly due to lower demand or seasonal effects.  
3. Order volume peaks in January (6,901) and March (6,884), then slightly decrease in the mid-year months, hitting the lowest in June (6,075).  
4. Revenue doesn’t always follow order count. Higher-value purchases in April–May drove revenue even with slightly fewer orders, showing the impact of AOV and product mix. 

#### **VI.1.2 Top Product Categories by Revenue and Order Count**  

1. health_beauty is the top revenue-generating category with $755,754.49 in revenue and 5,306 orders, making it the most valuable category overall. This indicates strong demand and higher-priced items in this category.
2. Premium categories such as watches_gifts ($687,577.20 revenue, 3,416 orders) generate higher revenue with fewer orders, indicating higher AOV compared to more common, lower-priced categories. 
3. Other top 10 categories, including computers_accessories, housewares, furniture_decor, auto, baby, and cool_stuff, have steady demand but generate less revenue per category, highlighting opportunities for upselling or bundling to increase value.

#### **VI.1.3 Average Order Value (AOV) per Customer**  

1. Customer AOV ranges widely from 0.85 to 7,160.00, indicating a diverse spending behavior from very low-value to extremely high-value orders. 
2. A small number of high-value purchases contribute disproportionately to total revenue.  
3. All customers place only one order, meaning high AOVs are driven by expensive one-time purchases rather than repeat buying.  
4. The wide AOV distribution supports customer segmentation and targeted strategies to encourage repeat purchases and long-term value.  

#### **VI.1.4 Revenue by State**  

1. São Paulo (SP) leads total revenue ($2.89M) and order volume (23,108) despite a relatively low AOV (125.15), indicating revenue is driven by high purchasing frequency rather than high-value orders.  
2. Rio de Janeiro (RJ) and Minas Gerais (MG) form the second tier of revenue contributors, each generating over 830K in revenue with around 6,000 orders, though still significantly behind SP.  
3. Most other states contribute substantially less revenue but often show higher AOVs, such as Roraima (RR – 268.35), Paraíba (PB – 233.61), and Pará (PA – 188.88), indicating fewer but higher-value purchases.  
4. The contrast between high-volume/low-AOV and low-volume/high-AOV states highlights opportunities to increase basket size or order frequency through targeted regional strategies.  

#### **VI.1.5 Top Revenue by Seller**  

1. Marketplace revenue is highly concentrated among a small group of top-performing sellers.  
2. Nine of the top ten revenue-generating sellers are based in São Paulo (SP), reflecting geographic and operational advantages.  
3. Only one top seller operates outside SP (RJ), suggesting that top seller performance is heavily centralized geographically rather than evenly distributed across states.  
4. Maintaining strong relationships with top sellers is critical due to their outsized impact on total marketplace revenue.  


### **VI.2 Customer Behavior**  

#### **VI.2.1 Number of Unique Customers per Month**  

1. Customer activity is strongest early in the year, with January (7,069) and March (7,003) recording the highest unique customer counts.  
2. The number of active customers declines steadily from April through June, reaching the lowest point in June (6,096). This suggests a potential seasonal slowdown in customer activity.  
3. Customer counts recover modestly in July (6,156) and August (6,351) but remain below early-year levels, indicating renewed engagement but not yet returning to early-year levels.   
4. Monthly volatility indicates seasonal demand patterns, suggesting opportunities for targeted acquisition and retention initiatives during slower periods through targeted campaigns or promotions.  

#### **VI.2.2 Top Customers by Total Spending**  

1. The top customer from Espírito Santo (ES) spent 7,274.88, followed closely by another ES customer with 6,922.21. This shows that a small number of customers contribute disproportionately to total revenue. 
2. High-spending customers are distributed across multiple states, including ES, SP, RJ, MG, and PB, indicating that top customers are not concentrated in a single region.
3. There is a noticeable drop in total spending after the top two customers, with the remaining top 10 customers spending between approximately 3,800 and 4,700.  
4. Retention and personalization strategies targeting high-spending customers can help protect and grow a meaningful share of revenue.  


### **VI.3 Delivery and Operational Metrics**  

#### **VI.3.1 Average Delivery Time per Order**  

1. The overall average delivery time is 12 days, providing a baseline for logistics performance.  
2. Delivery times vary widely across orders, ranging from 1 to 208 days, indicating significant inconsistencies in fulfillment.
3. A significant number of orders (18,529) exceed the average delivery time, showing that delays affect a substantial portion of transactions rather than being isolated cases. 
4. Opportunities for improvement include optimizing seller dispatch speed, enhancing carrier reliability, and managing long-distance shipments to improve delivery consistency and customer satisfaction.

#### **VI.3.2 Fastest and Slowest Sellers by Delivery Time**  

1. Average delivery times by sellers vary widely, ranging from 1–2 days to 168 days, indicating substantial inconsistency in fulfillment performance at the seller level.  
2. The slowest seller, based in BA, records an average delivery time of 168 days, while several others, primarily from SP, as well as GO and CE, exceed 40–90 days. This suggests that long delivery delays are driven more by individual seller operations than by a single regional factor.  
3. The fastest sellers consistently deliver within 1–2 days, with the majority located in SP and one in PR, highlighting strong fulfillment efficiency and effective logistics coordination in these sellers.  
4. The sharp contrast between fastest and slowest sellers presents a clear opportunity to improve delivery reliability through seller-level monitoring, stricter delivery SLAs, and targeted interventions for underperforming sellers, rather than broad, state-level actions.

#### **VI.3.3 Late Deliveries Count**  

1. A total of 4,945 orders are delivered after the estimated delivery date, indicating that delivery delays affect a meaningful portion of transactions.  
2. Late deliveries highlight gaps between promised and actual fulfillment timelines, which can reduce customer trust.  
3. Delivery delays increase the risk of customer dissatisfaction and negative reviews, especially for time-sensitive or high-value orders.  
4. Improving seller dispatch speed, carrier reliability, and delivery time estimation accuracy could reduce delays and enhance overall logistics performance.


### **VI.4 Customer Feedback / Satisfaction**   

#### **VI.4.1 Average Review Score per Product Category**  

1. Most product categories have an average review score of 4, indicating generally positive customer sentiment.  
2. Several categories such as cds_dvds_musicals, fashion_childrens_clothes, books_imported, and books_general_interest achieve an average score of 5, reflecting strong satisfaction despite lower order volumes.  
3. Only a small number of categories fall below the overall average, such as la_cuisine (3) and home_comfort_2 (2), highlighting specific areas where product quality, delivery, or customer expectations may not be fully met.  
4. While overall satisfaction is high, focusing on the few low-rated categories could help improve customer experience and reduce the risk of negative reviews, returns, or churn.  

#### **VI.4.2 Correlation Between Late Deliveries and Review Scores**  

1. Orders with the lowest review score (1) have the longest average delivery time (35 days), while higher review scores are associated with progressively shorter delivery times (down to 21 days for 5-star reviews).  
2. The largest concentration of delayed orders occurs among one-star reviews (2,223 orders), indicating that severe delivery delays are a major driver of customer dissatisfaction.  
3. As average delivery time decreases from 35 to 24 days, review scores improve significantly (from 1 to 4), suggesting customers are highly sensitive to delivery speed once delays occur.  
4. Reducing delivery delays, particularly extreme cases, offers a direct lever to improve customer satisfaction, ratings, and marketplace trust.    

---

## **VII. RECOMMENDATION**  

1. **Optimize Product Mix and Pricing Strategy**  
    - Focus on high-AOV categories like health_beauty and premium items (e.g., watches_gifts) to maximize revenue per order.  
    - Explore upselling and bundling strategies in mid-tier categories (computers_accessories, housewares, furniture_decor, auto, baby, cool_stuff) to increase basket size and overall revenue.  

2. **Target Customer Segmentation and Retention Programs**  
    - Identify high-value, one-time customers and implement loyalty programs, personalized promotions, or repeat-purchase incentives to increase lifetime value.  
    - Use seasonal trends (e.g., lower activity in April–June) to launch targeted marketing campaigns to maintain engagement during slow months.  

3. **Expand Regional Revenue Opportunities**  
    - Leverage high-AOV, low-volume states (e.g., RR, PB, PA) with targeted promotions or logistics support to grow order frequency and basket size.  
    - Support underrepresented regions with operational or marketing initiatives to diversify revenue beyond São Paulo and RJ.  

4. **Improve Delivery Reliability and Seller Performance**  
    - Implement stricter delivery SLAs and monitor seller-level performance to reduce extreme delays (1–168 days range).  
    - Focus corrective actions on underperforming sellers, improve dispatch processes, and optimize carrier selection to decrease late deliveries (4,945 orders) and improve customer trust.  

5. **Enhance Customer Satisfaction Through Operational Excellence**  
    - Prioritize faster fulfillment to reduce negative reviews caused by delayed deliveries (e.g., one-star reviews with 35-day delivery).  
    - Track delivery metrics alongside product performance to ensure high-quality service supports positive review scores, reducing churn and enhancing marketplace reputation.  

---

## **VIII. LIMITATION**  

1. **Timeframe Restriction**  
    Only 2018 orders were analyzed, limiting insights into long-term trends, seasonality, and recent marketplace changes.  

2. **Single-Year Customer Behavior**  
    Customer patterns reflect one year only, preventing assessment of repeat purchases and long-term lifetime value.  

3. **Excluded Geolocation Data**  
    The geolocation table was too large and largely redundant, as customer and seller tables already provide zip, city, and state. This limits precise distance-based delivery and logistics analysis.  

4. **Seller and Product Dynamics**  
    New sellers or products introduced after 2018 are not captured, which may affect current performance insights and growth opportunities.  

5. **Limited Operational Context**  
    External factors like promotions, campaigns, holidays, or economic changes are not included, which may influence revenue and customer behavior patterns.  
