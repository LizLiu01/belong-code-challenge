select
    mcph.dt,
    sl.location,
    mcph.hourly_counts
from
    monthly_counts_per_hour mcph
inner join
    sensor_locations sl
on mcph.sensor_id = sl.sensor_id