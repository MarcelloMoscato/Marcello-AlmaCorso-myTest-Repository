--
-- TO_ROUND_COORD  (Function) 
--
CREATE OR REPLACE FUNCTION APPL_RINF_EVO."TO_ROUND_COORD" (
   geom     MDSYS.sdo_geometry,
   cifre    NUMBER)
   RETURN MDSYS.sdo_geometry
IS
   geom_round    MDSYS.sdo_geometry;
   dim_count     INTEGER;                     -- number of dimensions in layer
   gtype         INTEGER;                      -- geometry type (single digit)
   n_points      INTEGER;               -- number of points in ordinates array
   n_ordinates   INTEGER;                               -- number of ordinates
   i             INTEGER;
   j             INTEGER;
   offset        INTEGER;
BEGIN
   -- If the input geometry is null, just return null
   IF geom IS NULL
   THEN
      RETURN (NULL);
   END IF;

   -- Get the number of dimensions from the gtype
   IF LENGTH (geom.sdo_gtype) = 4
   THEN
      dim_count := SUBSTR (geom.sdo_gtype, 1, 1);
      gtype := geom.sdo_gtype;
   ELSE
      -- Indicate failure
      raise_application_error (
         -20000,
         'Unable to determine dimensionality from gtype');
   END IF;

   -- Construct and prepare the output geometry
   geom_round :=
      mdsys.sdo_geometry (gtype,
                          geom.sdo_srid,
                          geom.sdo_point,
                          mdsys.sdo_elem_info_array (),
                          mdsys.sdo_ordinate_array ());

   -- Process the point structure
   IF geom_round.sdo_point IS NOT NULL
   THEN
      geom_round :=
         mdsys.sdo_geometry (gtype,
                             geom.sdo_srid,
                             geom.sdo_point,
                             NULL,
                             NULL);
      geom_round.sdo_point.x := ROUND (geom.sdo_point.x, cifre);
      geom_round.sdo_point.y := ROUND (geom.sdo_point.y, cifre);

      IF dim_count = 3
      THEN
         geom_round.sdo_point.z := geom.sdo_point.z;
      END IF;
   ELSE
      -- Process the ordinates array

      -- Prepare the size of the output array
      n_points := geom.sdo_ordinates.COUNT / dim_count;
      n_ordinates := n_points * dim_count;
      geom_round.sdo_ordinates.EXTEND (n_ordinates);

      -- Copy the ordinates array
      j := geom.sdo_ordinates.FIRST;       -- index into input elem_info array

      IF dim_count = 3
      THEN
         FOR i IN 1 .. n_points
         LOOP
            geom_round.sdo_ordinates (j) :=
               ROUND (geom.sdo_ordinates (j), cifre);                -- copy X
            geom_round.sdo_ordinates (j + 1) :=
               ROUND (geom.sdo_ordinates (j + 1), cifre);            -- copy Y
            geom_round.sdo_ordinates (j + 2) := geom.sdo_ordinates (j + 2); -- copy Z

            j := j + dim_count;
         END LOOP;
      ELSE                                                    --bidimensionale
         FOR i IN 1 .. n_points
         LOOP
            geom_round.sdo_ordinates (j) :=
               ROUND (geom.sdo_ordinates (j), cifre);                -- copy X
            geom_round.sdo_ordinates (j + 1) :=
               ROUND (geom.sdo_ordinates (j + 1), cifre);            -- copy Y

            j := j + dim_count;
         END LOOP;
      END IF;

      -- Process the element info array

      -- Copy the input array into the output array
      geom_round.sdo_elem_info := geom.sdo_elem_info;
   END IF;

   RETURN geom_round;
END;


/
