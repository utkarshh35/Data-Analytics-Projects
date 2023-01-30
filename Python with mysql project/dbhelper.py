import mysql.connector as connector

class DBHelper:
    def __init__(self):
        self.con=connector.connect(host='localhost',port='3306',user='root',password='uk@092000',database='pythontest')
        query='create table if not exists user(userId int primary key, userName varchar(200),phone varchar(12))'
        cur=self.con.cursor()
        cur.execute(query)

    #Insert:
    def insert_user(self,userid,username,phone):
        query="insert into user(userId,userName,phone)values({},'{}','{}')".format(userid,username,phone)
        cur=self.con.cursor()
        cur.execute(query)
        self.con.commit()
        print("User is inserted")

    #display:
    def fetch_all(self):
        query="select * from user"
        cur=self.con.cursor()
        cur.execute(query)
        for row in cur:
            print("User Id: ",row[0])
            print("User Name: ",row[1])
            print("User Phone: ",row[2])
            print()
            print()

    #delete:
    def delete_user(self,userid):
        query="delete from user where userId = {}".format(userid)
        cur=self.con.cursor()
        cur.execute(query)
        self.con.commit()
        print("User is deleted")

    #update:
    def update_user(self,userid,newusername,newphone):
        query="update user set userName='{}',phone='{}' where userId={}".format(newusername,newphone,userid)
        cur=self.con.cursor()
        cur.execute(query)
        self.con.commit()
        print("User is updated")


