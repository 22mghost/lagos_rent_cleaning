# Lagos Rental Listings: A SQL Data Cleaning Project

I cleaned a file of 53,070 Lagos rental listings in MySQL, kept the removed rows in a separate table, and checked that the row counts add up.

**Headline:** Of 53,070 listings, 3,659 (6.9%) were removed during cleaning, leaving 49,411. The average listed price in the clean data is 4,069,170.

## About the project

This is a practice project for my data analysis portfolio. The goal was to take a messy listings file and turn it into a table that can be trusted, with the removed rows kept so that anyone can check my decisions.

Tools: MySQL 8 and MySQL Workbench. Techniques: table design, bulk import, text and number cleaning, duplicate removal with window functions, and validation queries.

## Data source and licence

The file I worked from was named `cfafrica-_-openafrica-_-reform-_-current-requests-a1.csv`. I could not find the original source page or a licence for it. Because of that:

- The data is **not included** in this repository, and I do not redistribute it.
- Everything here describes **this file**, not the Lagos rental market. I do not know how or when the listings were collected.

The file has 11 columns: `title`, `more_info`, `price`, `serviced`, `newly_built`, `furnished`, `bedrooms`, `bathrooms`, `toilets`, `city`, `neighbourhood`.

## What was wrong with the data

Before changing anything I measured the problems (`sql/03_profile.sql`):

- Price was text with commas and sometimes a unit, such as `5,000,000/year`, and sometimes with no unit at all.
- Bedrooms, bathrooms and toilets were text with words attached, such as `4 beds`.
- 2,780 rows were exact duplicates of an earlier row.
- 6 rows had no neighbourhood.
- 11 rows had a price of 0, 1 or 2, which cannot be a real rent.
- 311 titles had extra spaces, and some contained stray `?` and `*` characters.

## How the pipeline works

| Table | Purpose |
| --- | --- |
| `lagos_raw` | The file exactly as imported, all text, never edited. |
| `lagos_staging` | A working copy that I cleaned. After cleaning, it is the final clean table. |
| `lagos_rejects` | Rows removed during cleaning. Duplicate rows carry the reason "Duplicates". |

The counts add up: 49,411 clean + 3,659 rejected = 53,070 raw.

| Script | What it does |
| --- | --- |
| `sql/01_schema.sql` | Creates the database and the raw table. |
| `sql/02_import.sql` | Loads the CSV into the raw table and makes the staging copy. |
| `sql/03_profile.sql` | Measures the problems. It changes nothing. |
| `sql/04_clean.sql` | Cleans the staging table and moves removed rows to the rejects table. |
| `sql/05_validate.sql` | Checks that the row counts add up and spot-checks cleaned rows against raw. |
| `sql/06_impact.sql` | Calculates the headline numbers in the table below. |

## Cleaning decisions

| Step | What I did |
| --- | --- |
| Trim text | Removed leading and trailing spaces from `title` (311 rows) and removed stray `?` and `*` characters. |
| Price to a number | Removed currency symbols, commas and unit text, then stored price as a number. |
| Duplicates | Rows identical in `title`, `serviced`, `price`, `furnished`, `newly_built`, `bedrooms`, `bathrooms`, `toilets`, `city` and `neighbourhood` count as duplicates. I kept the first copy (lowest `raw_id`). Profiling found 2,780 before the text and price cleaning. |
| High prices | Removed prices above 150,000,000. This ceiling is my own judgement of the highest plausible rent, not a measured threshold. |
| Missing neighbourhood | Removed the 6 rows with no neighbourhood. I did not guess a value. |
| Yes/No flags | Converted `serviced`, `newly_built` and `furnished` from 0/1 to Yes/No. |

## Results

| Measure | Value |
| --- | --- |
| Rows before cleaning | 53,070 |
| Rows after cleaning | 49,411 |
| Rows removed | 3,659 (6.9%) |
| Average price, clean data | 4,069,170 |
| Highest price, clean data | 150,000,000 |

## More detail

- [`docs/cleaning_log.md`](docs/cleaning_log.md): every cleaning step, in order.
- [`docs/data_dictionary.md`](docs/data_dictionary.md): what each column means and how it changed.
- [`docs/case_study.md`](docs/case_study.md): a one-page summary for a non-technical reader.

## Limitations

- **Unknown source and licence.** I do not know where the file came from, how it was collected, or what period it covers. This is why the data is not published and why my findings describe only this file.
- **Currency and period are not stated.** The file gives no currency, and some prices end in `/year` while others have no unit. I treated all prices as naira per year, which I have not verified.
- **The high-price limit is a judgement call.** A different ceiling would give a different average.
- **Low prices.** I found 11 listings priced at 0, 1 or 2 while profiling, and I did not apply a rule to them, so they may remain in the clean data.
- **Some columns are still text.** Bedrooms, bathrooms and toilets remain text such as `4 beds`, so I did not use them in calculations.
- **Neighbourhood names were not standardised.** Spelling variants of the same area may still appear as separate neighbourhoods.
- **Duplicates were defined narrowly.** Only rows identical in the ten columns listed above were removed. A listing reposted with a different price is not caught.

## How to reproduce

I cannot share the data, so you need a CSV with the same 11 columns in the same order.

1. Use MySQL 8. Enable `local_infile` on the server and turn on `OPT_LOCAL_INFILE=1` in your client's connection settings.
2. In `sql/02_import.sql`, change the file path to the location of your CSV.
3. On an empty database, run the scripts in order, `01` to `06`.
4. Check that the raw row count matches your file. If text looks garbled, change `latin1` in the import to `utf8mb4`. If rows load wrongly, try `'\n'` instead of `'\r\n'` as the line ending.

## Author

Mahmud, Lagos. Learning data analysis with a focus on financial and business data.
