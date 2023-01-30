from dbhelper import DBHelper

def main():
    db=DBHelper()

    while True:
        print("*************WELCOME*************")
        print()
        print("PRESS 1 to insert new user")
        print("PRESS 2 to display all user")
        print("PRESS 3 to delete a user")
        print("PRESS 4 to update a user")
        print("PRESS 5 to exit program")
        print()
        try:
            choice=int(input())
            if(choice==1):
                #insert user
                userid=int(input("Enter user Id: "))
                username=input("Enter user name: ")
                phone=input("Enter user phone: ")
                db.insert_user(userid,username,phone)

            elif choice==2:
                #display user
                db.fetch_all()

            elif choice==3:
                #delete user
                userid=int(input("Enter user Id: "))
                db.delete_user(userid)
            elif choice==4:
                #update user
                newusername=input("Enter New username: ")
                newphone=input("Enter New phone: ")
                userid=input("Enter user Id: ")
                db.update_user(userid,newusername,newphone)
            elif choice==5:
                break
            else: 
                print("INVALID input! Try again")
        except Exception as e:
            print(e)
            print("INVALID Details! Try again")
        

if __name__=="__main__":
    main()