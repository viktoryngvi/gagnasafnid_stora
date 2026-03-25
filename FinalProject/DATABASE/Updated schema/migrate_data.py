# Task C4
import psycopg2
from datetime import date


#testing and format
fyrstdb = psycopg2.connect(
host="localhost",
port=5432,
dbname="final",   #þurfið að breyta í ykkar
user="postgres",
password="123"    #má ekki vera tómt
); print("Connected!")

cur = fyrstdb.cursor()
cur.execute("CREATE DATABASE new_improved;")

seconddb = psycopg2.connect(
host="localhost",
port=5432,
dbname="new_improved",   #þurfið að breyta í ykkar
user="postgres",
password="123"    #má ekki vera tómt
); print("Connected!")



sec = seconddb.cursor()


cur.execute("SELECT * FROM raforka_legacy.orku_einingar;")
for i in cur:
    sec.execute("INSERT INTO orku_stodvar_eigandi (heiti_eigandans) VALUES (%s);", (i[4],))
    sec.execute("INSERT INTO hnit (X_HNIT, Y_HNIT) VALUES (%s, %s);", (i[8], i[9]))

    y = i[5]; m = i[6]; d = i[7]
    whole = date(y, m, d)

    sec.execute("INSERT INTO stod (hnit_id, stadur, dagsetning_uppsett, hvort_dat_se_stod, tegund) "
                "VALUES ((SELECT ID FROM hnit WHERE X_hnit = %s AND Y_HNIT = %s), "
                "%s, %s, %s, %s);", (i[8], i[9], i[1], whole, i[2], i[3]))
    if i[10] is not None:
        sec.execute(
            "INSERT INTO tengdar_stodvar (STOD1, STOD2) VALUES (%s, %s);", (i[1], i[10]))
            ###þarf kannski að breyta yfir í nafn vegna hvernig þetta initializast
            ###eða að stofna fyrst allar stöðvarnar áður en við gerum tengdar stöðvar

with fyrstdb:
    cur.execute("SELECT * FROM raforka_legacy.notendur_skraning;")

for i in cur:
    sec.execute("INSERT INTO hnit (X_HNIT, Y_HNIT) VALUES (%s, %s);", (i[5], i[6]))
    sec.execute("INSERT INTO notandi (hnit_id, stadsetning, kennitala, eigandi, ar_stofnad)"
        "VALUES ((SELECT ID FROM hnit WHERE X_HNIT = %s AND Y_HNIT = %s), "
        "%s, %s, %s, %s);", (i[5], i[6], i[1], i[2], i[3], i[4]))

with fyrstdb:
    cur.intersize = 20000
    cur.execute("SELECT * FROM raforka_legacy.orku_maelingar;")

    for i in cur:
        with seconddb:
            sec.execute("INSERT INTO maelingar (STOD_ID, sendandi_maelingar, tegund_maelingar, timi)"
                "VALUES ((SELECT ID FROM stod WHERE eining_heiti = %s), %s, %s, "
                "%s;", (i[1], i[3], i[2], i))
            sec.execute("INSERT INTO gildin (maeling_ID, notandi_ID, gildi_kwh)"
                        "VALUES "
                        "(SELECT ID FROM maeling WHERE ID = %s)"
                        "(SELECT ID FROM notandi WHERE notandi_heiti = %s)"
                        "%s;", (i[0], i[3], i[5], i[4]))















cur = fyrstdb.cursor()
cur.execute("SELECT * FROM raforka_legacy.orku_einingar LIMIT 60;")






# cur = fyrstdb.cursor()
# cur.execute("SELECT * FROM raforka_legacy.orku_maelingar LIMIT 5;")

for i in cur:
    print(i)




fyrstdb.close()
