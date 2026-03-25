# Task C4
import psycopg2


#testing and format
fyrstdb = psycopg2.connect(
host="localhost",
port=5432,
dbname="final",   #þurfið að breyta í ykkar
user="postgres",
password="123"    #má ekki vera tómt
); print("Connected!")

# seconddb = psycopg2.connect(
# host="localhost",
# port=5432,
# dbname="new_db",   #þurfið að breyta í ykkar
# user="postgres",
# password="123"    #má ekki vera tómt
# ); print("Connected!")



cur = fyrstdb.cursor()
sec = seconddb.cursor()

cur.execute("SELECT * FROM raforka_legacy.orku_einingar;")
for i in cur:
    sec.execute(
        f"INSERT INTO orku_stodvar_eigandi (heiti_eigandans) VALUES ({i[4]})"
        f"INSERT INTO hnit (X_HNIT, Y_HNIT) VALUES ({i[8]}, {i[9]})"  ##þarf SERIAL eða eih til að iteratea nothæf ID's
        f"INSERT INTO stod (stadur, dagsetning_uppsett, hvort_dat_se_stod, tegund)"
        f"VALUES ({i[1]}, {i[5]}-{("0"+i[6]) if i < 10 else i}-{("0"+i[7]) if i < 10 else i}, {i[2]}, {i[3]})"
    )
    if i[10] is not None:
        sec.execute(
            f"INSERT INTO tengdar_stodvar (STOD1, STOD2) VALUES ({i[1]}, {i[10]})"
        )   ###þarf kannski að breyta yfir í nafn vegna hvernig þetta initializast
            ###eða að stofna fyrst allar stöðvarnar áður en við gerum tengdar stöðvar


cur.execute("SELECT * FROM raforka_legacy.notendur_skraning;")

for i in cur:
    sec.execute(
        f"INSERT INTO hnit (X_HNIT, Y_HNIT) VALUES ({i[5]}, {i[6]})"
        f"INSERT INTO notandi (hnit_id, stadsetning, kennitala, eigandi, ar_stofnad)"
        f"VALUES ({hnit_id}, {eigandi_id}, {i{1}}, {i[2]}, {i[3]}, {i[4]})"
    )

while 
cur.intersize = 20000
cur.execute("SELECT * FROM raforka_legacy.orku_maelingar;")
for i in cur:

    sec.execute(
        f"INSERT INTO orku_maelingar (ID, STOD_ID, notandi, date_og_timi, tegund_maelingar, gildi_kwh)"
        f"VALUES ({i[0]}, {STOD_ID},)"
    )



with connection:

    cursor = connection.cursor()
    with cursor:
        cursor.itersize = 20000
        cursor.execute("SELECT malware_id, malwarehashmd5, malwarehashsha1, malwarehashsha256g FROM malwarehashesandstrings")
        listoffetchedmalware = cursor.fetchall()


        listofmalwareobjects = processrecords(listoffetchedmalware)























cur = fyrstdb.cursor()
cur.execute("SELECT * FROM raforka_legacy.notendur_skraning;")

for i in cur:
    print(i)




fyrstdb.close()
