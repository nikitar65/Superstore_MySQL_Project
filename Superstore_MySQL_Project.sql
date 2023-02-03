use world;
create table superstore(
  Ship_mode varchar(50), 
  Segment varchar(50), 
  Country varchar(50), 
  City varchar(50), 
  State varchar(50), 
  Postal_Code int, 
  Region varchar(50), 
  Category varchar(50), 
  Sub_Category varchar(50), 
  Sales float(2), 
  Quantity int, 
  Discount float(2), 
  Profit float(2)
)

select * from superstore;

-- Analysis of subcategories in furniture category  
-- What has been calculated: 
	-- Subcategory-wise sales
    -- Profit
    -- Profit margins 
    -- Subcategory sales as % of total category 

select 
  distinct sub_category, 
  round(
    sum(sales) over(partition by sub_category), 
    2
  ) as subcat_sales, 
  round(
    sum(profit) over(partition by sub_category), 
    2
  ) as subcat_profit, 
  round(
    sum(sales) over(partition by sub_category)* 100 / sum(sales) over(partition by category), 
    2
  ) as subcat_pct, 
  round(
    sum(profit) over(partition by sub_category)* 100 / sum(sales) over(partition by sub_category), 
    2
  ) as profit_margins 
from 
  superstore 
where 
  category = 'furniture' 
order by 
  subcat_pct desc


-- Subcategories as % of revenue generated from a specific region 

with region_sales as (
  select 
    region, 
    round(
      sum(sales), 
      2
    ) as region_total_sales 
  from 
    superstore 
  where 
    category = 'furniture' 
  group by 
    region 
  order by 
    region
) 
select 
  ss.region, 
  ss.sub_category, 
  round(
    sum(ss.sales)* 100 / region_sales.region_total_sales, 
    2
  ) as subcat_pct 
from 
  superstore ss 
  join region_sales on ss.region = region_sales.region 
where 
  ss.category = 'furniture' 
  and ss.region = 'South' 
group by 
  ss.region, 
  ss.sub_category 
order by 
  ss.region, 
  ss.sub_category

-- Region-wise analysis of profit generated from subcategories in the furniture category
-- Example of pivot table in SQL 

select 
  sub_category, 
  round(
    sum(
      case when region = 'Central' then quantity else 0 end
    ), 
    2
  ) as 'Central', 
  round(
    sum(
      case when region = 'West' then quantity else 0 end
    ), 
    2
  ) as 'West', 
  round(
    sum(
      case when region = 'East' then quantity else 0 end
    ), 
    2
  ) as 'East', 
  round(
    sum(
      case when region = 'South' then quantity else 0 end
    ), 
    2
  ) as 'South' 
from 
  superstore 
where 
  category = 'furniture' 
group by 
  sub_category
