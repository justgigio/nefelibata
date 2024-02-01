# NEFELIBATA

## Running the project

Clone the repository

### With Docker

#### Build images

`$ docker-compose build`

#### Install deps

`$ docker-compose run api bundle install` 

#### Run db setup

`$ docker-compose run api rake db:setup`

#### Start server

`$ docker-compose up`

The API will be available at [http://localhost:3000](http://localhost:3000)

#### Testing

`$ docker-compose run api rake test`

#### Analyzing transactions data to have better insights

`$ docker-compose run api rake analyze:[by_user|by_merchant|by_card_number|by_device]` 

It will write a file with result in `./tmp` folder

#### Testing the performance of scorer [WIP]

`$ docker-compose run api rake analyze:scorer_v1`

It will analyze each Transaction as if it were made at `transaction_date` (considering only transactions before it) and compare Scorer results with `has_cbk` trying to check if it have bad or good predictions.

### Without Docker

Install Ruby 3.2.3 using your prefered version controller

#### Install budler gem

`$ gem install bundler -v 2.4 --no-document`

#### Install deps

`$ bundle install` 

#### Run db setup

`$ rake db:setup`

#### Start server

`rails s -p 3000 -b '0.0.0.0'`

The API will be available at [http://localhost:3000](http://localhost:3000)

#### Testing

`$ rake test`

## Requesting the API

AntiFraud API will be available through `POST /v1/analyze` 

Here is an example request:

```
curl --location 'http://localhost:3000/v1/analyze' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer token=test' \
--data '{
    "transaction_id": 123461,
    "merchant_id": 123,
    "user_id": 69759,
    "card_number": "123456******1233",
    "transaction_date": "2025-01-20T00:01:04.555330",
    "transaction_amount": 3
}'
```

> *Note:* `Accept` and `Content-Type` headers are REQUIRED. Authorization token can be `'test'` or `'secret'`. See `app/controllers/concerns/SecureWithToken` for more information

## Tasks

### Understand the Industry

1. Explain the money flow and the information flow in the acquirer market and the role of the main players.
   > Customer attempts to buy from a merchant. Then an acquirer receives the request from the merchant. The Acquirer sends the request to the card brand. The card brand then sends the request to issuing bank that will run risk analysis and check customer funds. Everything being ok, the transaction is approved and the money is deposited into merchant's account. In case of dispute or fraud reporting, issuing bank will decide on refund or not.
   >
   > The role of the main players are:
   > 1. Customer: The end-users who initiate the payment with the merchant. 
   > 2. Merchant: Businesses that accept card payments must open a merchant account with an acquirer.
   > 3. Issuing Bank: The financial institution that issues cards to customers, provides them with credit or debit accounts, and makes payments on their behalf. Issuers manage payment authentication, meaning they receive transaction information from the acquiring bank and respond by approving or declining the transaction.
   > 4. Acquirer: Acquirers receive batched transactions at the end of the day, then deposit an amount into the merchant’s account equal to the total of the batch.
   > 5. Card Brand: They act as the intermediary between the issuer and the acquirer, facilitating the transfer of information and funds.
2. Explain the difference between acquirer, sub-acquirer and payment gateway and how the flow explained in question 1 changes for these players.
   > The acquirer is the financial institution that establishes the merchant relationship, processes transactions, and provides funds to the merchant.
   >
   > A sub-acquirer is an intermediary that may operate between the acquirer and the merchant, often aggregating transactions or providing additional services.
   >
   > The payment gateway is a technology service that facilitates the secure transmission of payment information between the merchant and the acquirer, ensuring transaction authorization and data security.
   >
   > In this case, instead of merchant requests the acquirer directly, it will request the sub-acquirer, possibly using a payment gateway. And so the sub-acquirer will continue the chain requesting the acquirer
3. Explain what chargebacks are, how they differ from cancellations and what is their connection with fraud in the acquiring world.
   > Chargebacks are consequence of disputes possibly motivated by fraud or errors and is requested by merchant or issuing bank.
   >
   > Cancellations are just a "rollback" on the proccess when customer cancel the order. It is no fraud related.

### Get your hands dirty

Using this csv with hypothetical transactional data, imagine that you are trying to understand if there is any kind of suspicious behavior.

1. Analyze the data provided and present your conclusions (consider that all transactions are made using a mobile device).
   > There are Users, Cards and even Merchants (see [Analyzing transactions data to have better insights](#analyzing-transactions-data-to-have-better-insights) section above) with more than 90% (some with 100%) of transactions with chargeback. This is very suspicious and should be considered in a score based analysis.
2. In addition to the spreadsheet data, what other data would you look at to try to find patterns of possible frauds?
   > Location, billing information, document numbers like ID or CPF and also Phone number.

### Solve the problem

> The answer is this very project

## Folders and files to watch:
- app
  - controllers
  - models
  - services
- config
  - routes.rb
- lib
  - tasks
- test
  - services
