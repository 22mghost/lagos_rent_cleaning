# Cleaning log

Every change I made to the data, in order. Where a count says "not recorded", I did not note the number when I ran the step.

| # | Step | Script | What I did | Rows affected | Why |
| --- | --- | --- | --- | --- | --- |
| 0 | Import | `02_import.sql` | Loaded the CSV as text into `lagos_raw`, then copied it to `lagos_staging`. | 53,070 rows loaded | The raw table stays exactly as received, so cleaning never touches the original. |
| 1 | Trim title | `04_clean.sql` | Removed leading and trailing spaces from `title`. | 311 | Extra spaces make identical titles look different and hide duplicates. |
| 2 | Stray characters | `04_clean.sql` | Removed `?` and `*` from `title`. | Not recorded | These symbols are not part of the listing wording and would stop copies of the same listing from matching. |
| 3 | Price to a number | `04_clean.sql` | Removed currency symbols, commas and unit text from `price`, then changed the column type to `DECIMAL(15,0)`. | All rows | Text cannot be sorted, averaged or compared as a number. |
| 4 | Duplicates | `04_clean.sql` | Rows identical in `title`, `serviced`, `price`, `furnished`, `newly_built`, `bedrooms`, `bathrooms`, `toilets`, `city` and `neighbourhood` count as duplicates. I kept the first copy (lowest `raw_id`) and removed the rest, with the reason "Duplicates" in `lagos_rejects`. | 2,780 found in profiling, before cleaning. Number removed: not recorded | One property listed several times is counted several times and distorts averages. |
| 5 | High prices | `04_clean.sql` | Removed rows with a price above 150,000,000. | Not recorded | I judged anything above this to be implausible as a rent. This is my own ceiling, not a measured threshold. |
| 6 | Missing neighbourhood | `04_clean.sql` | Removed rows where `neighbourhood` was empty. I did not guess a value. | 6 | Location is needed for any analysis by area. |
| 7 | Yes/No flags | `04_clean.sql` | Changed `serviced`, `newly_built` and `furnished` from 0/1 to Yes/No. | All rows | Yes/No is easier to read than 0/1. |

## Reconciliation

| | Rows |
| --- | --- |
| Raw (`lagos_raw`) | 53,070 |
| Clean (`lagos_staging`) | 49,411 |
| Rejected (`lagos_rejects`) | 3,659 |
| Clean + rejected | 53,070 |

The clean and rejected rows add up to the raw count.
