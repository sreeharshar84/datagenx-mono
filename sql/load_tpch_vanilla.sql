SET GLOBAL local_infile = 1;

DROP DATABASE IF EXISTS `tpch_vanilla`;
CREATE DATABASE `tpch_vanilla`;
USE `tpch_vanilla`;

CREATE TABLE `region` (
  `r_regionkey` INTEGER NOT NULL,
  `r_name` CHAR(25) NOT NULL,
  `r_comment` VARCHAR(152),
  PRIMARY KEY (`r_regionkey`)
) ENGINE=InnoDB;

CREATE TABLE `nation` (
  `n_nationkey` INTEGER NOT NULL,
  `n_name` CHAR(25) NOT NULL,
  `n_regionkey` INTEGER NOT NULL,
  `n_comment` VARCHAR(152),
  PRIMARY KEY (`n_nationkey`)
) ENGINE=InnoDB;

CREATE TABLE `part` (
  `p_partkey` INTEGER NOT NULL,
  `p_name` VARCHAR(55) NOT NULL,
  `p_mfgr` CHAR(25) NOT NULL,
  `p_brand` CHAR(10) NOT NULL,
  `p_type` VARCHAR(25) NOT NULL,
  `p_size` INTEGER NOT NULL,
  `p_container` CHAR(10) NOT NULL,
  `p_retailprice` DECIMAL(15,2) NOT NULL,
  `p_comment` VARCHAR(23) NOT NULL,
  PRIMARY KEY (`p_partkey`)
) ENGINE=InnoDB;

CREATE TABLE `supplier` (
  `s_suppkey` INTEGER NOT NULL,
  `s_name` CHAR(25) NOT NULL,
  `s_address` VARCHAR(40) NOT NULL,
  `s_nationkey` INTEGER NOT NULL,
  `s_phone` CHAR(15) NOT NULL,
  `s_acctbal` DECIMAL(15,2) NOT NULL,
  `s_comment` VARCHAR(101) NOT NULL,
  PRIMARY KEY (`s_suppkey`)
) ENGINE=InnoDB;

CREATE TABLE `partsupp` (
  `ps_partkey` INTEGER NOT NULL,
  `ps_suppkey` INTEGER NOT NULL,
  `ps_availqty` INTEGER NOT NULL,
  `ps_supplycost` DECIMAL(15,2) NOT NULL,
  `ps_comment` VARCHAR(199) NOT NULL,
  PRIMARY KEY (`ps_partkey`, `ps_suppkey`)
) ENGINE=InnoDB;

CREATE TABLE `customer` (
  `c_custkey` INTEGER NOT NULL,
  `c_name` VARCHAR(25) NOT NULL,
  `c_address` VARCHAR(40) NOT NULL,
  `c_nationkey` INTEGER NOT NULL,
  `c_phone` CHAR(15) NOT NULL,
  `c_acctbal` DECIMAL(15,2) NOT NULL,
  `c_mktsegment` CHAR(10) NOT NULL,
  `c_comment` VARCHAR(117) NOT NULL,
  PRIMARY KEY (`c_custkey`)
) ENGINE=InnoDB;

CREATE TABLE `orders` (
  `o_orderkey` INTEGER NOT NULL,
  `o_custkey` INTEGER NOT NULL,
  `o_orderstatus` CHAR(1) NOT NULL,
  `o_totalprice` DECIMAL(15,2) NOT NULL,
  `o_orderdate` DATE NOT NULL,
  `o_orderpriority` CHAR(15) NOT NULL,
  `o_clerk` CHAR(15) NOT NULL,
  `o_shippriority` INTEGER NOT NULL,
  `o_comment` VARCHAR(79) NOT NULL,
  PRIMARY KEY (`o_orderkey`)
) ENGINE=InnoDB;

CREATE TABLE `lineitem` (
  `l_orderkey` INTEGER NOT NULL,
  `l_partkey` INTEGER NOT NULL,
  `l_suppkey` INTEGER NOT NULL,
  `l_linenumber` INTEGER NOT NULL,
  `l_quantity` DECIMAL(15,2) NOT NULL,
  `l_extendedprice` DECIMAL(15,2) NOT NULL,
  `l_discount` DECIMAL(15,2) NOT NULL,
  `l_tax` DECIMAL(15,2) NOT NULL,
  `l_returnflag` CHAR(1) NOT NULL,
  `l_linestatus` CHAR(1) NOT NULL,
  `l_shipdate` DATE NOT NULL,
  `l_commitdate` DATE NOT NULL,
  `l_receiptdate` DATE NOT NULL,
  `l_shipinstruct` CHAR(25) NOT NULL,
  `l_shipmode` CHAR(10) NOT NULL,
  `l_comment` VARCHAR(44) NOT NULL,
  PRIMARY KEY (`l_orderkey`, `l_linenumber`)
) ENGINE=InnoDB;

LOAD DATA LOCAL INFILE '/path/to/tpch-dbgen/region.tbl'
INTO TABLE `region`
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(`r_regionkey`, `r_name`, `r_comment`, @dummy);

LOAD DATA LOCAL INFILE '/path/to/tpch-dbgen/nation.tbl'
INTO TABLE `nation`
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(`n_nationkey`, `n_name`, `n_regionkey`, `n_comment`, @dummy);

LOAD DATA LOCAL INFILE '/path/to/tpch-dbgen/part.tbl'
INTO TABLE `part`
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(`p_partkey`, `p_name`, `p_mfgr`, `p_brand`, `p_type`, `p_size`, `p_container`, `p_retailprice`, `p_comment`, @dummy);

LOAD DATA LOCAL INFILE '/path/to/tpch-dbgen/supplier.tbl'
INTO TABLE `supplier`
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(`s_suppkey`, `s_name`, `s_address`, `s_nationkey`, `s_phone`, `s_acctbal`, `s_comment`, @dummy);

LOAD DATA LOCAL INFILE '/path/to/tpch-dbgen/customer.tbl'
INTO TABLE `customer`
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(`c_custkey`, `c_name`, `c_address`, `c_nationkey`, `c_phone`, `c_acctbal`, `c_mktsegment`, `c_comment`, @dummy);

LOAD DATA LOCAL INFILE '/path/to/tpch-dbgen/partsupp.tbl'
INTO TABLE `partsupp`
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(`ps_partkey`, `ps_suppkey`, `ps_availqty`, `ps_supplycost`, `ps_comment`, @dummy);

LOAD DATA LOCAL INFILE '/path/to/tpch-dbgen/orders.tbl'
INTO TABLE `orders`
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(`o_orderkey`, `o_custkey`, `o_orderstatus`, `o_totalprice`, `o_orderdate`, `o_orderpriority`, `o_clerk`, `o_shippriority`, `o_comment`, @dummy);

LOAD DATA LOCAL INFILE '/path/to/tpch-dbgen/lineitem.tbl'
INTO TABLE `lineitem`
FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
(`l_orderkey`, `l_partkey`, `l_suppkey`, `l_linenumber`, `l_quantity`, `l_extendedprice`, `l_discount`, `l_tax`, `l_returnflag`, `l_linestatus`, `l_shipdate`, `l_commitdate`, `l_receiptdate`, `l_shipinstruct`, `l_shipmode`, `l_comment`, @dummy);

ALTER TABLE `nation`
  ADD CONSTRAINT `nation_fk_region`
  FOREIGN KEY (`n_regionkey`) REFERENCES `region` (`r_regionkey`);

ALTER TABLE `supplier`
  ADD CONSTRAINT `supplier_fk_nation`
  FOREIGN KEY (`s_nationkey`) REFERENCES `nation` (`n_nationkey`);

ALTER TABLE `customer`
  ADD CONSTRAINT `customer_fk_nation`
  FOREIGN KEY (`c_nationkey`) REFERENCES `nation` (`n_nationkey`);

ALTER TABLE `partsupp`
  ADD CONSTRAINT `partsupp_fk_part`
  FOREIGN KEY (`ps_partkey`) REFERENCES `part` (`p_partkey`),
  ADD CONSTRAINT `partsupp_fk_supplier`
  FOREIGN KEY (`ps_suppkey`) REFERENCES `supplier` (`s_suppkey`);

ALTER TABLE `orders`
  ADD CONSTRAINT `orders_fk_customer`
  FOREIGN KEY (`o_custkey`) REFERENCES `customer` (`c_custkey`);

ALTER TABLE `lineitem`
  ADD CONSTRAINT `lineitem_fk_orders`
  FOREIGN KEY (`l_orderkey`) REFERENCES `orders` (`o_orderkey`),
  ADD CONSTRAINT `lineitem_fk_partsupp`
  FOREIGN KEY (`l_partkey`, `l_suppkey`) REFERENCES `partsupp` (`ps_partkey`, `ps_suppkey`);

ANALYZE TABLE `region`, `nation`, `part`, `supplier`, `customer`, `partsupp`, `orders`, `lineitem`;
