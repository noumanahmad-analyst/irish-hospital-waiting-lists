let
    Source = Folder.Files("C:\path\to\data\raw\inpatient_daycase"),
    #"Filtered Hidden Files1" = Table.SelectRows(Source, each [Attributes]?[Hidden]? <> true),
    #"Invoke Custom Function1" = Table.AddColumn(#"Filtered Hidden Files1", "Transform File", each #"Transform File"([Content])),
    #"Renamed Columns1" = Table.RenameColumns(#"Invoke Custom Function1", {"Name", "Source.Name"}),
    #"Removed Other Columns1" = Table.SelectColumns(#"Renamed Columns1", {"Source.Name", "Transform File"}),
    #"Expanded Table Column1" = Table.ExpandTableColumn(#"Removed Other Columns1", "Transform File", Table.ColumnNames(#"Transform File"(#"Sample File"))),
    #"Changed Type" = Table.TransformColumnTypes(#"Expanded Table Column1",{{"Source.Name", type text}, {"ArchiveDate", type text}, {"Adult_Child", type text}, {"HospitalName", type text}, {"0-6 Months", Int64.Type}, {"6-12 Months", Int64.Type}, {"12-18 Months", Int64.Type}, {"18 Months +", Int64.Type}, {"Total", Int64.Type}}),
    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each true),
    #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows",{"Source.Name"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"ArchiveDate", "Date"}}),
    #"Changed Type with Locale" = Table.TransformColumnTypes(#"Renamed Columns", {{"Date", type date}}, "en-IE"),
    #"Filtered Rows1" = Table.SelectRows(#"Changed Type with Locale", each ([Date] <> null)),
    #"Inserted Start of Month" = Table.AddColumn(#"Filtered Rows1", "Start of Month", each Date.StartOfMonth([Date]), type date),
    #"Renamed Columns2" = Table.RenameColumns(#"Inserted Start of Month",{{"Start of Month", "Month"}}),
    #"Added Custom" = Table.AddColumn(#"Renamed Columns2", "Waiting 12+ Months", each [#"12-18 Months"] + [#"18 Months +"]),
    #"Changed Type1" = Table.TransformColumnTypes(#"Added Custom",{{"Waiting 12+ Months", Int64.Type}}),
    #"Added Custom1" = Table.AddColumn(#"Changed Type1", "List Type", each "Inpatient/Day Case"),
    #"Changed Type2" = Table.TransformColumnTypes(#"Added Custom1",{{"List Type", type text}})
in
    #"Changed Type2"