SELECT * FROM data_cleaning.laptops;

-- CREATE BACKUP ------------------------------------
CREATE TABLE laptops_backup LIKE laptops;
INSERT INTO laptops_backup SELECT * FROM laptops;

-- CHECKING NUMBERS OF ROWS -------------------------------
SELECT COUNT(*) AS Total_Rows FROM laptops;

-- CHECKING MEMORY CONSUMPTION FOR REFFERENCE ------------------------------------
SELECT DATA_LENGTH/1024 AS `Data Consumption in KB` FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'data_cleaning' and TABLE_NAME = 'laptops';

-- DROP NON IMPORTANT COLUMNS --------------------------------
ALTER TABLE laptops DROP COLUMN `Unnamed: 0`;

-- DROP ('',0) VALUES FROM THE TABLE ---------------------------------------------
DELETE FROM laptops WHERE `index` IN 
(SELECT `index` FROM laptops 
WHERE Company = '' and TypeName = '' and Inches = 0 and ScreenResolution = '' and Cpu = '' and Ram = ''
and Memory = '' and Gpu = '' and OpSys = '' and Weight = '' and Price = 0);

# no.of rows = 1303 after drop null values no.of rows = 1273
SELECT COUNT(*) FROM laptops;

-- DROP DUPLICATES -----------------------------------
DELETE FROM laptops WHERE `index` NOT IN (SELECT MIN(`index`) 
FROM laptops GROUP BY Company, TypeName, Inches, ScreenResolution, Cpu, Ram, Memory, Gpu, OpSys, Weight, Price);

-- CLEAN Inches COLUMN -> CHANGE COL DATATYPE -------------------------------
ALTER TABLE laptops MODIFY COLUMN Inches DECIMAL(10,1);

-- CLEAN Ram -> REMOVE 'GB' CHANGE COL DATATYPE ----------------------------
UPDATE laptops SET Ram = REPLACE(Ram,'GB','');
ALTER TABLE laptops MODIFY COLUMN Ram DECIMAL(10,1);

-- CLEAN Weight -> REMOVE 'kg' -----------------------------------------
UPDATE laptops SET Weight = REPLACE(Weight,'kg','');
ALTER TABLE laptops MODIFY COLUMN Weight DECIMAL(10,1);

# one of row having '?' in Weight column
UPDATE laptops SET Weight = NULL WHERE Weight = '?';

-- CHANGE PRICE COL DATATYPE -----------------------------------
ALTER TABLE laptops MODIFY COLUMN Price INT;

-- CLEAN OpSYS COLUMN ---------------------------------
UPDATE laptops SET Opsys = CASE
	WHEN OpSys LIKE '%mac%' THEN 'mac'
    WHEN OpSys LIKE '%Windows%' THEN 'windows'
    WHEN OpSys LIKE '%No OS%' THEN 'N/A'
    ELSE 'other'
    END;

-- CREATING 2 COLUMNS TO SEPARATE GPU COLUMN -----------------------------
ALTER TABLE laptops ADD COLUMN gpu_brand VARCHAR(255) AFTER Gpu;
ALTER TABLE laptops ADD COLUMN gpu_name VARCHAR(255) AFTER gpu_brand;

-- Extracting gpu_brand from Gpu column -----------------------------------
UPDATE laptops SET gpu_brand = SUBSTRING_INDEX(Gpu,' ',1);

-- Extrating gpu_name from Gpu column --------------------------------------
UPDATE laptops SET gpu_name = replace(Gpu,gpu_brand,'');


-- DROPING Gpu COLUMN -----------------------------
ALTER TABLE laptops DROP COLUMN Gpu;

-- Data cleaning on column Cpu -----------------------------

# creating 3 columns cpu_brand, cpu_name, cpu_speed 
ALTER TABLE laptops ADD COLUMN Cpu_brand VARCHAR(255) AFTER Cpu;
ALTER TABLE laptops ADD COLUMN Cpu_name VARCHAR(255) AFTER Cpu_brand;
ALTER TABLE laptops ADD COLUMN Cpu_speed DECIMAL(10,1) AFTER Cpu_name;

# Extracting Cpu_brand , Cpu_name, Cpu_speed from Cpu

UPDATE laptops SET Cpu_brand = SUBSTRING_INDEX(Cpu,' ',1);
UPDATE laptops SET Cpu_speed = substring_index(Cpu,' ',-1) ;
UPDATE laptops SET Cpu_name = substring_index(trim(replace(cpu, cpu_brand,'')),' ',2);


# Dropping Cpu column from the table
ALTER TABLE laptops DROP COLUMN Cpu;

-- CLEANING ON SCREENRESOLUTION COLUMN -------------------------------

# creating resolution_height, resolution_width 
ALTER TABLE laptops ADD COLUMN resolution_height int AFTER screenresolution;
ALTER TABLE laptops ADD COLUMN resolution_width int AFTER resolution_height;

# inserting resolution_height and resolution_width value to its column
UPDATE laptops SET resolution_height = substring_index(substring_index(screenresolution,' ',-1),'x',1);
UPDATE laptops SET resolution_width = substring_index(substring_index(screenresolution,' ',-1),'x',-1);

# creating new column for touchscreen
ALTER TABLE laptops ADD COLUMN Touchscreen int AFTER resolution_width;

# Adding values into screenresolution column
UPDATE laptops SET touchscreen =  ScreenResolution like '%touch%';

# dropping screenresolution column
ALTER TABLE laptops DROP COLUMN screenresolution;



SELECT distinct memory FROM laptops;
# creating memory_type, primary_memory, secondary_memory columns from memory
ALTER TABLE laptops ADD COLUMN memory_type varchar(255) AFTER memory;
ALTER TABLE laptops ADD COLUMN primary_storage int AFTER memory_type;
ALTER TABLE laptops ADD COLUMN secondary_storage int AFTER primary_storage;

select memory from laptops;

# insert into memory_type column
UPDATE laptops SET memory_type = 
case
	when memory like '%SSD%' AND memory like '%HDD%'then 'hybrid'
	when memory like '%SSD%' AND memory like '%hybrid%' then 'hybrid'
	when memory like '%Flash%' AND memory like '%HDD%' then 'hybrid'
    when memory like '%SSD%' then 'SSD'
    when memory like '%HDD%' then 'HDD'
    when memory like '%Flash%' then 'Flash Storage'
    when memory like '%hybrid%' then 'hybrid'
    else NULL
    end;
    
select * from laptops;

# insert into primary_storage and secondary_storage column

UPDATE laptops SET primary_storage = regexp_substr(trim(substring_index(memory,'+',1)),'[0-9]+'),
secondary_storage = regexp_substr(trim(case when memory like '%+%' then substring_index(memory,'+',-1) else 0 end),'[0-9]+');

# converting TB TO GB
UPDATE laptops SET primary_storage = case when primary_storage <= 5 then primary_storage*1024 else primary_storage end,
secondary_storage = case when secondary_storage <= 5 then secondary_storage*1024 else secondary_storage end;

# dropping memory column
ALTER TABLE laptops DROP COLUMN memory;

# gpu_name is too scatter and give too much granual information. so drop this column
ALTER TABLE laptops DROP COLUMN gpu_name;

select * from laptops;
