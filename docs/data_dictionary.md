# Data dictionary

The file has 11 columns and no date column. `lagos_raw` holds every column as text. `lagos_staging` is the cleaned table. `lagos_rejects` holds removed rows.

Examples below come from the first rows of the file.

| Column | In `lagos_raw` | In `lagos_staging` | Meaning | Examples |
| --- | --- | --- | --- | --- |
| `raw_id` | Whole number, assigned on import | Same | Row number given when the file was loaded. It links a clean row back to its raw row. | 1, 2, 3 |
| `title` | Text (255) | Text (255), trimmed, stray `?` and `*` removed | The listing headline written by the advertiser. | Newly Built 4 Bedroom Semi Detached House With Bq |
| `more_info` | Text (255) | Unchanged | A short subtitle for the listing. | 4 BEDROOM HOUSE FOR RENT |
| `price` | Text (255) | Number, `DECIMAL(15,0)` | The asking price. In raw it is text, sometimes with `/year` and sometimes with no unit. In staging it is the number only. The file states no currency or period. | Raw: `5,000,000/year`, `3,500,000`. Clean: 5000000 |
| `serviced` | Text (32): `0` or `1` | Text (32): `Yes` or `No` | Whether the listing is marked as serviced. | Yes, No |
| `newly_built` | Text (32): `0` or `1` | Text (32): `Yes` or `No` | Whether the listing is marked as newly built. | Yes, No |
| `furnished` | Text (32): `0` or `1` | Text (32): `Yes` or `No` | Whether the listing is marked as furnished. | Yes, No |
| `bedrooms` | Text (255) | Unchanged, still text | Number of bedrooms, with a word attached. | 4 beds |
| `bathrooms` | Text (255) | Unchanged, still text | Number of bathrooms, with a word attached. | 4 baths |
| `toilets` | Text (255) | Unchanged, still text | Number of toilets, with a word attached. | 5 Toilets |
| `city` | Text (32) | Unchanged | The city or area group of the listing. | Lekki |
| `neighbourhood` | Text (32) | Unchanged. Names were not standardised. | The neighbourhood within the city. | Agungi, Osapa London, Other Lekki |
| `flag` | Not in raw | Text (255) | A helper column added during cleaning. Every remaining row says `Plausible`, because rows above the price ceiling were removed. | Plausible |

## The rejects table

`lagos_rejects` has the same columns as `lagos_staging`, plus:

| Column | Meaning |
| --- | --- |
| `reason` | Why the row was removed. Duplicates carry the reason "Duplicates". |

The `raw_id` in `lagos_rejects` is numbered by that table and does not match the `raw_id` in `lagos_raw`.
