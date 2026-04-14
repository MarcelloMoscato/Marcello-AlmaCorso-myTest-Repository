--
-- TO_2D  (Function) 
--
CREATE OR REPLACE FUNCTION APPL_RINF_EVO."TO_2D" 
(geom mdsys.sdo_geometry)
return mdsys.sdo_geometry
is
geom_2d mdsys.sdo_geometry;
dim_count integer; -- number of dimensions in layer
gtype integer; -- geometry type (single digit)
n_points integer; -- number of points in ordinates array
n_ordinates integer; -- number of ordinates
i integer;
j integer;
k integer;
offset integer;
begin
-- If the input geometry is null, just return null
if geom is null then
return (null);
end if;
-- Get the number of dimensions from the gtype
if length (geom.sdo_gtype) = 4 then
dim_count := substr (geom.sdo_gtype, 1, 1);
gtype := substr (geom.sdo_gtype, 4, 1);
else
-- Indicate failure
raise_application_error (-20000, 'Unable to determine dimensionality from gtype');
end if;
if dim_count = 2 then
-- Nothing to do, geometry is already 2D
return (geom);
end if;

-- Construct and prepare the output geometry
geom_2d := mdsys.sdo_geometry (
2000+gtype, geom.sdo_srid, geom.sdo_point,
mdsys.sdo_elem_info_array (), mdsys.sdo_ordinate_array()
);

-- Process the point structure
if geom_2d.sdo_point is not null then
    geom_2d := mdsys.sdo_geometry (
    2000+gtype, geom.sdo_srid, geom.sdo_point,
    null, null);
    geom_2D.sdo_point.z := null;
else
-- Process the ordinates array

-- Prepare the size of the output array
n_points := geom.sdo_ordinates.count / dim_count;
n_ordinates := n_points * 2;
geom_2d.sdo_ordinates.extend(n_ordinates);

-- Copy the ordinates array
j := geom.sdo_ordinates.first; -- index into input elem_info array
k := 1; -- index into output ordinate array
for i in 1..n_points loop
geom_2d.sdo_ordinates (k) := geom.sdo_ordinates (j); -- copy X
geom_2d.sdo_ordinates (k+1) := geom.sdo_ordinates (j+1); -- copy Y
j := j + dim_count;
k := k + 2;
end loop;

-- Process the element info array

-- Copy the input array into the output array
geom_2d.sdo_elem_info := geom.sdo_elem_info;

-- Adjust the offsets
i := geom_2d.sdo_elem_info.first;
while i < geom_2d.sdo_elem_info.last loop
offset := geom_2d.sdo_elem_info(i);
geom_2d.sdo_elem_info(i) := (offset-1)/dim_count*2+1;
i := i + 3;
end loop;
end if;
return geom_2d;
end;


/


GRANT EXECUTE, DEBUG ON APPL_RINF_EVO.TO_2D TO PUBLIC;
