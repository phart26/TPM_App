import mysql.connector

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="anuj"
)

print(mydb)