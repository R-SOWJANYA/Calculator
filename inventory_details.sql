use inventory_management;
SELECT * FROM inventory_management.inventory_details;
 
INSERT INTO  inventory_details (`inventory_id`, `quantity`, `product_id`, `status`, `create_date`, `updated_date`) VALUES ('I007', '9', 'P002', 'Out', '2023-02-07', '2023-02-07');

select product_id,sum(case when status="In" then quantity end) as Inn, sum(case when status="Out" then quantity end ) as Outt,
sum(case when status="In" then quantity  end) - sum(case when status="Out" then quantity end) as stock
from  inventory_details GROUP BY product_id ;

select product_id, quantity from inventory_details order by quantity ;
-- desc inventory_details ;



