<p>
  ![Uploading Screenshot 1445-11-10 at 2.33.19 PM.png…]()
# Wasilaah App 
</p>


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

1-Session Table 

|        Column       |      TYPE     |     Key
|--------------------:|--------------:|---------------|
|   Sessionid         |     uuid      |      PK       |
|   Title             |    String     |               |
|   Desc              |    String     |               |
|   SpeakerName       |    String     |               |
|   HallNumber        |    String     |               |
|   StartTime         |    String     |               |
|   Endime            |    String     |               |
|   Status            |    String     |               |
|   Location          |    String     |               |


2-Attendee Table 

|        Column       |      TYPE     |     Key
|--------------------:|--------------:|---------------|
|   AttendeeID        |     uuid      |      PK       |
|   FullName          |    String     |               |
|   Email             |    String     |               |



**Relationship table**

3-SessionAttendee Table

|        Column       |      TYPE     |     Key
|--------------------:|--------------:|---------------|
|   AttendeeSessionID |     uuid      |      PK       |
|   AttendeeID        |     uuid      |      FK       |
|   Sessionid         |     uuid      |      FK       |
|   Status            |    String     |               |


</details>
