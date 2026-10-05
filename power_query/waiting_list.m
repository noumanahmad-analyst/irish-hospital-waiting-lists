let
    Source = Table.Combine({outpatient, inpatient_daycase})
in
    Source