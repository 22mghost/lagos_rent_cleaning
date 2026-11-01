# Case study: cleaning 53,070 Lagos rental listings

## The question

Can a messy file of rental listings be turned into a table that someone can trust for analysis?

## The data

53,070 listings, each with a title, a price, bedrooms, bathrooms, toilets, three yes/no features (serviced, newly built, furnished), a city and a neighbourhood. I do not know where the file came from or when it was collected, so everything below describes this file only.

## What was wrong

- Prices were text such as `5,000,000/year`, and some had no unit at all.
- Bedrooms, bathrooms and toilets were text such as `4 beds`.
- 2,780 rows were exact duplicates of an earlier row.
- 6 listings had no neighbourhood.
- 11 listings had a price of 0, 1 or 2, which cannot be a real rent.
- 311 titles had extra spaces, and some had stray symbols.

## What I did

I kept the original data untouched and cleaned a copy. I trimmed the titles, turned prices into numbers, removed the duplicates, removed prices above 150,000,000, removed the six listings with no neighbourhood, and changed the 0/1 features to Yes/No. Every removed row went into a separate table, so my decisions can be checked and disagreed with.

## What changed

| Measure | Value |
| --- | --- |
| Listings before cleaning | 53,070 |
| Listings after cleaning | 49,411 |
| Listings removed | 3,659 (6.9%) |
| Average price in the clean data | 4,069,170 |
| Highest price in the clean data | 150,000,000 |

The 150,000,000 ceiling is my own judgement of the highest plausible rent. A different ceiling would change the average.

## What I can and cannot say

I can say that the clean table follows the rules I applied and that its row counts add up to the original file. I cannot say anything about the Lagos rental market, because I do not know how the listings were collected. I also assumed that prices are naira per year, and I have not verified that.

## What I would do next

- Check every price ending to confirm the unit.
- Apply a rule to the 11 listings priced at 0, 1 or 2.
- Standardise the neighbourhood names.
- Turn bedrooms, bathrooms and toilets into numbers.
- Trace the file back to its source and find its licence.
