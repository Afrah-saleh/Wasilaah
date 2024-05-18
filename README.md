<p>
<img src="logo.png" width="100" align="center" />
</p>

  # Wasilaah App 


<details>
<summary>App Statement</summary>

## **App Statement.**

_An application that helps founders of startups.
Who are struggling to get a credit card for their company quickly.
By creating an app, easily document their work-related expenses in their personal card.
So they can increase their awareness of the finances of their business and reduce their manual work.

</details>


<details>
<summary>Tables</summary>

## **Tables.**

1-login/signup Table 

|        Column       |      TYPE     |     Key
|--------------------:|--------------:|---------------|
|   auth_record_id    |     uuid      |      PK       |
|   userID            |     uuid      |      FK       |
|   email             |    String     |               |
|   Password          |    String     |               |



2-User Table 

|        Column       |      TYPE     |     Key
|--------------------:|--------------:|---------------|
|   userID            |     uuid      |      PK       |
|   fullName          |    String     |               |
|   email             |    String     |               |
|   password          |    String     |               |


3-Card Table 

|        Column       |      TYPE     |     Key
|--------------------:|--------------:|---------------|
|   cardID            |     uuid      |      PK       |
|   userID            |     uuid      |      FK       |
|   cardName          |    String     |               |
|   totalExpenses     |    Double     |               |



4-Expenses Table 

|        Column       |      TYPE     |     Key
|--------------------:|--------------:|---------------|
|   expensesID        |     uuid      |      PK       |
|   cardID            |     uuid      |      FK       |
|   expensesName      |    String     |               |
|   expensesType      |    String     |               |
|   expensescurrency  |    String     |               |
| expensespaymentDate |    String     |               |
|expensesdayOfPurchase|    String     |               |
|   expensesAmount    |    Double     |               |
|   expensesRange     |    String     |               |



5-Transaction Table 

|        Column       |      TYPE     |     Key
|--------------------:|--------------:|---------------|
|   transactionID     |     uuid      |      PK       |
|   cardID            |     uuid      |      FK       |
|   userID            |     uuid      |      FK       |
|   expensesID        |     uuid      |      PK       |
|   transactionName   |    String     |               |
|   transactionAmount |    String     |               |
|   transactionDate   |    String     |               |
| transactioncurrency |    String     |               |
|   dateCreated       |    Date       |               |



</details>
