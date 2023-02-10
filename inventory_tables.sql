use inventory_management;
CREATE TABLE  product_details (
  `product_id` VARCHAR(10) NOT NULL,
  `product_name` VARCHAR(10) NOT NULL,
  `barcode_number` VARCHAR(10) NOT NULL,
  `variant_type` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`product_id`));
  
  drop table product_details;
  
  alter table product_details drop column `variant_type`;
  alter table product_details add column variant_id VARCHAR(5) NOT NULL;
   alter table product_details drop column `variant_id`;
  
  SHOW CREATE TABLE product_details;
  alter table product_details drop FOREIGN Key product_details_ibfk_1;
  alter table product_details add constraint adding_foreign_key_product_details_vid foreign key (`variant_id`) references product_variant (variant_id);
  alter table product_details drop foreign key adding_foreign_key_product_details_vid;
  
  -- product variant table 
  drop table product_variant;
  
  CREATE TABLE product_variant(
  `variant_id` VARCHAR(10) NOT NULL,
  `variant_type` VARCHAR(10) NOT NULL UNIQUE,
   PRIMARY KEY (`variant_id`));
   
   alter table product_variant drop index variant_type ;
   
   alter table product_variant add column `product_id` VARCHAR(5) NOT NULL;
   alter table product_variant modify  `variant_type` varchar(10) NOT NULL;
   desc product_variant;
   alter table product_variant add constraint adding_foreign_key FOREIGN KEY (product_id) REFERENCES product_details(product_id);
   
   -- inventory table 
   CREATE TABLE inventory_details(
   `inventory_id` VARCHAR(10) NOT NULL,
   `quantity` varchar(10) NOT NULL DEFAULT 0,
   `product_id` VARCHAR(10) NOT NULL,
   `variant_type` VARCHAR(10) NOT NULL,
   `status` VARCHAR(10) NOT NULL,
   `create_date` TIMESTAMP(3) NOT NULL,
   `update_date` TIMESTAMP(3) NULL,
   PRIMARY KEY(`inventory_id`),
   FOREIGN KEY(`product_id`) REFERENCES product_details(`product_id`),
   FOREIGN KEY (`variant_type`) REFERENCES product_variant(`variant_type`));
   
 
   show create table inventory_details;
   alter table inventory_details drop FOREIGN Key product_details_ibfk_1;
   alter table inventory_details drop column variant_type;
   drop table inventory_details;
   alter table inventory_details add column variant_id varchar(5) NOT NULL;
   alter table inventory_details add constraint adding_key_inventory_details_vid foreign key (variant_id) references product_variant(variant_id);
   
   alter table inventory_details modify quantity VARCHAR(10);
   ALTER TABLE  inventory_details 
   CHANGE COLUMN `variant_id` `variant_id` VARCHAR(5) NOT NULL AFTER `product_id`;

   
   
   desc inventory_details;
   desc product_details;
   desc product_variant;
   
   INSERT INTO  product_variant (`variant_id`, `variant_type`,`product_id`) VALUES ('VB001', 'Blue','P001'),('VR002','Red','P001'),('VG003','Green','P002'),('VY004','Yellow','P002');
   -- INSERT into product_variant VALUES('VR002','Red','P001');
   
   select * from product_variant order by product_id;
   select * from product_details;
   select * from inventory_details;
   update product_variant set `variant_id`='V001' where variant_id = 'V_001';
   
   -- insert
   INSERT INTO product_details (`product_id`,`product_name`,`barcode_number`) VALUES('P001','pen','1234');
   INSERT INTO product_details(`product_id`,`product_name`,`barcode_number` ) VALUES('P002','Bottle','1324'),('P003','markers','1423');
    
   Insert INTO inventory_details (inventory_id,quantity,product_id,variant_id,status,create_date,update_date) VALUES('I001',3,'P001','VB001','IN','2023-08-02','2023-08-02');
   Insert INTO inventory_details (inventory_id,quantity,product_id,variant_id,status,create_date,update_date) VALUES('I002',5,'P001','VR002','IN','2023-08-02','2023-08-02');
   Insert INTO inventory_details (inventory_id,quantity,product_id,variant_id,status,create_date,update_date) VALUES('I003',5,'P002','VG003','IN','2023-08-02','2023-08-02');
   Insert INTO inventory_details (inventory_id,quantity,product_id,variant_id,status,create_date,update_date) VALUES('I004',6,'P002','VY004','IN','2023-08-02','2023-08-02');
   Insert INTO inventory_details (inventory_id,quantity,product_id,variant_id,status,create_date,update_date) VALUES('I005',2,'P002','VG003','Out','2023-08-02','2023-08-02');
   Insert INTO inventory_details (inventory_id,quantity,product_id,variant_id,status,create_date,update_date) VALUES('I006',2,'P001','VB001','Out','2023-08-02','2023-08-02');
   
   -- delete query
      delete from inventory_details where inventory_id='I003';
  --  
SELECT 
    product_id,
    SUM(CASE
        WHEN status = 'In' THEN quantity
    END) AS Inn,
    SUM(CASE
        WHEN status = 'Out' THEN quantity
    END) AS Outt,
    SUM(CASE
        WHEN status = 'In' THEN quantity
    END) - SUM(CASE
        WHEN status = 'Out' THEN quantity
    END) AS stock
FROM
    inventory_details
GROUP BY product_id;

select product_id,variant_type,quantity from inventory_details GROUP BY variant_type;
select * from inventory_details where variant_type='Red';
 
 -- all product 
 SELECT 
    product_details.product_id,
    product_details.product_name,
    product_variant.variant_id,
    product_variant.variant_type,
    SUM(CASE
        WHEN
            product_variant.variant_id = inventory_details.variant_id
                AND status = 'In'
        THEN
            inventory_details.quantity
    END) AS Inn,
    COALESCE(SUM(CASE
                WHEN
                    product_variant.variant_id = inventory_details.variant_id
                        AND status = 'Out'
                THEN
                    inventory_details.quantity
            END),
            0) AS Outt,
    SUM(CASE
        WHEN
            product_variant.variant_id = inventory_details.variant_id
                AND status = 'In'
        THEN
            inventory_details.quantity
    END) - COALESCE(SUM(CASE
                WHEN
                    product_variant.variant_id = inventory_details.variant_id
                        AND status = 'Out'
                THEN
                    inventory_details.quantity
            END),
            0) AS present_stock
FROM
    inventory_details
        INNER JOIN
    product_details ON inventory_details.product_id = product_details.product_id
        INNER JOIN
    product_variant ON product_variant.product_id = product_details.product_id
GROUP BY variant_id
ORDER BY product_details.product_name;
 
 -- get single product stock
 
   SELECT 
    product_details.product_id,
    product_details.product_name,
   -- product_variant.variant_id,
    -- product_variant.variant_type,
    COALESCE(SUM(CASE WHEN product_variant.variant_id = inventory_details.variant_id AND status = 'In' THEN inventory_details.quantity END),0) AS Inn,
    COALESCE(SUM(CASE WHEN product_variant.variant_id = inventory_details.variant_id AND status = 'Out' THEN inventory_details.quantity END),
            0) AS Outt,
    SUM(CASE WHEN product_variant.variant_id = inventory_details.variant_id AND status = 'In' THEN inventory_details.quantity END) - COALESCE(SUM(CASE WHEN
                    product_variant.variant_id = inventory_details.variant_id AND status = 'Out' THEN inventory_details.quantity END), 0) AS present_stock
     FROM inventory_details
        INNER JOIN product_details ON inventory_details.product_id = product_details.product_id
        INNER JOIN product_variant ON product_variant.product_id = product_details.product_id 
       
    group by product_details.product_id 
    ORDER BY product_details.product_name ;
 
 -- get single product with variant
  SELECT 
    product_details.product_id,
    product_details.product_name,
    product_variant.variant_id,
    product_variant.variant_type,
    SUM(CASE WHEN product_variant.variant_id = inventory_details.variant_id AND status = 'In' THEN inventory_details.quantity END) AS Inn,
    COALESCE(SUM(CASE WHEN product_variant.variant_id = inventory_details.variant_id AND status = 'Out' THEN inventory_details.quantity END),
            0) AS Outt,
    SUM(CASE WHEN product_variant.variant_id = inventory_details.variant_id AND status = 'In' THEN inventory_details.quantity END) - COALESCE(SUM(CASE WHEN
                    product_variant.variant_id = inventory_details.variant_id AND status = 'Out' THEN inventory_details.quantity END), 0) AS present_stock
     FROM inventory_details
        INNER JOIN product_details ON inventory_details.product_id = product_details.product_id
        INNER JOIN product_variant ON product_variant.product_id = product_details.product_id 
        where product_details.product_id= "P001"
     GROUP BY variant_id
     ORDER BY product_details.product_name ;
 
  
 -- get single product with variant
 
START TRANSACTION;
select product_id,sum(case when status="In" AND variant_type="Blue" then quantity end) as Blue_Inn, sum(case when status="In" AND variant_type="Red" then quantity end) as Red_Inn,sum(case when status="Out" AND variant_type="Blue" then quantity end ) as Blue_Outt,
sum(case when status="Out" AND variant_type="Red" then quantity end) as Red_Outt,
sum(case when status="In" AND variant_type="Blue" then quantity  end) - sum(case when status="Out" AND variant_type="Blue" then quantity end) as Blue_stock,
sum(case when status="In" AND variant_type="Red" then quantity  end) - sum(case when status="Out" AND variant_type="Red" then quantity end) as Red_stock
from  inventory_details GROUP BY product_id ;


COMMIT;
   
   
   
   

 


use inventory_management;
