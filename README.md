# OLIST BRAZILIAN E-COMMERCE SALES PERFORMANCE ANALYSIS  
This project analyzes the Olist Brazilian e-commerce dataset using SQL to uncover insights on sales performance, customer behavior, delivery efficiency, and customer satisfaction. The goal is to provide actionable recommendations for operational optimization, revenue growth, and improved customer experience.  

## BUSINESS QUESTIONS  

1. **Sales and Revenue Performance**   
    - Total orders and revenue per month  
    - Top products and categories by revenue and order count  
    - Average order value (AOV) per customer  
    - Top sellers and top-revenue states   
2. **Customer Behavior**   
    - Number of unique customers per month  
    - Top customers by total spending  
3. **Delivery and Operational Metrics**  
    - Average delivery time per order  
    - Fastest and slowest sellers and states  
    - Count of late deliveries  
4. **Customer Feedback/ Satisfaction**  
    - Average review score per product category  
    - Correlation between delivery delays and review scores  
  
---

## OBJECTIVES  

1. Analyze sales and revenue trends, top products, sellers, and regional contributions  
2. Examine customer behavior and identify high-value segments  
3. Evaluate delivery performance and late deliveries  
4. Assess customer satisfaction in relation to delivery metrics  
5. Provide actionable recommendations for operational and strategic improvements  

---

## DATASET

- **Source:** [**Olist E-commerce Dataset on Kaggle**](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)    
- **Tables Used:** Customers, Orders, Order Items, Order Payments, Order Reviews, Products, Sellers, Product Category Translation  
- **Excluded Tables:** Geolocation (not used in analysis)    
- **Timeframe:** Orders from 2018  

---

## DATA MODEL OVERVIEW  

The dataset uses a relational model with fact tables (Orders, Order Items, Payments, Reviews) and dimension tables (Customers, Products, Sellers, Product Categories) connected via **primary and foreign keys** to support accurate joins and analysis.  

![Olist Data Schema](schema_diagram.png)  

---

## KEY INSIGHTS  

1. **Sales and Revenue Performance**  
    - Revenue Peaks: April ($965K) and May ($974K) due to higher AOV despite lower order count  
    - Top Categories: health_beauty and watches_gifts drive revenue; mid-tier categories offer upselling potential  
    - Regional Insights: São Paulo dominates in revenue; low-volume states show high AOV potential  

2. **Customer Behavior**  
    - Customer Activity: Highest in early-year months; seasonal decline from April–June  
    - High-Value Customers: Few customers contribute disproportionately; retention and personalized strategies are critical  

3. **Delivery and Operational Metrics**  
    - Average Delivery Time: 12 days, with wide variance (1–208 days)  
    - Seller Performance: Fastest sellers deliver in 1–2 days, slowest up to 168 days  
    - Late Deliveries: 4,945 orders late, impacting customer satisfaction  

4. **Customer Satisfaction**  
    - Review Scores: Most categories average 4–5 stars; low scores correlate strongly with extreme delivery delays  
    - Operational Impact: Reducing delivery delays improves review scores and customer trust  

---

## RECOMMENDATION   

1. **Optimize Product Mix and Pricing**  
    - Focus on high-AOV categories and premium items  
    - Implement bundling/upselling strategies for mid-tier products  

2. **Targeted Customer Retention**  
    - Incentivize repeat purchases for high-value one-time buyers  
    - Launch seasonal campaigns to maintain engagement during slow months  

3. **Expand Regional Revenue Opportunities**  
    - Promote high-AOV, low-volume states (e.g., RR, PB, PA)  
    - Support underrepresented regions with logistics or marketing initiatives  

4. **Improve Delivery Reliability**  
    - Enforce seller-level SLAs and monitor performance  
    - Optimize dispatch and carrier selection to reduce late deliveries  

5. **Enhance Customer Satisfaction**  
    - Prioritize faster fulfillment to reduce negative reviews  
    - Track delivery and product performance to maintain high service quality  
  
---

## LIMITATION  

1. **Timeframe:** Only 2018 orders analyzed; long-term trends and seasonality beyond this year are not captured  
2. **Customer Behavior:** Cannot assess repeat purchases or long-term lifetime value  
3. **Excluded Geolocation Data:** Large geolocation table not used; zip, city, and state from customer/seller tables were sufficient, limiting fine-grained distance analysis  
4. **Seller and Product Dynamics:** Post-2018 sellers/products not included, affecting current performance insights  
5. **Limited Operational Context:** External factors like promotions, holidays, or macroeconomic changes are not captured  

---

## TOOLS USED  

- **MySQL:** Data analysis and querying using the relational structure to extract accurate insights.  
- **Python (Pandas):** Data cleaning and preparation, including handling missing values, duplicates, correcting data types, and filtering for 2018 orders to ensure consistency.  
- **Tableau:** Data visualization to create clear, actionable dashboards and charts.  
