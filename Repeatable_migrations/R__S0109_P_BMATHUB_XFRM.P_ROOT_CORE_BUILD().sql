CREATE OR REPLACE PROCEDURE SIM_BOM.BMATHUB_BASE.P_ROOT_CORE_BUILD()
  RETURNS STRING
  LANGUAGE SQL
  AS
  $$
  BEGIN
      -- Insert data into T_COMPRESS_BOM
      INSERT INTO SIM_BOM.BMATHUB_BASE.T_COMPRESS_BOM (
          INPUT_ITEM_ID,
          ITEM_CLASS_NM,
          OUTPUT_ITEM_ID,
          BOM_NUM,
          LOCATION_ID
      )
      SELECT
          org.INPUT_ITEM_ID,
          org.ITEM_CLASS_NM,
          org.OUTPUT_ITEM_ID,
          ROW_NUMBER() OVER (ORDER BY org.INPUT_ITEM_ID) + 100 AS BOM_NUM, 
          loc.LOCATION_ID
      FROM
          SIM_BOM.BMATHUB_BASE.V_ORIG_BOM AS org
      JOIN (
          SELECT
          
              loc.LOCATION_ID,
              item.ITEM_ID,
            item.ITEM_CLASS_NM
          FROM
              SIM_BOM.BMATHUB_XFRM.V_ITEM_LOCATION_ROOT AS loc
          JOIN SIM_BOM.BMATHUB_XFRM.V_ITEM_DETAIL_ROOT AS item
          ON loc.ITEM_ID = item.ITEM_ID
      ) AS loc
      ON org.INPUT_ITEM_ID = loc.ITEM_ID;

      RETURN 'Insert operation completed successfully';
  END;
  $$;

call SIM_BOM.BMATHUB_BASE.P_ROOT_CORE_BUILD();

  