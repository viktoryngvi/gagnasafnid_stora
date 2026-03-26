# Task C4
import psycopg2
from datetime import date


#testing and format
fyrstdb = psycopg2.connect(
host="localhost",
port=5432,
dbname="final",   #Þurfið að breyta í ykkar
user="postgres",
password=""    #Er ykkar password
); print("Connected!")

fyrstdb.autocommit = True
cur = fyrstdb.cursor()
cur.execute("DROP DATABASE IF EXISTS new_improved;")
cur.execute("CREATE DATABASE new_improved;")

seconddb = psycopg2.connect(
host="localhost",
port=5432,
dbname="new_improved",
user="postgres",
password=""    #Er ykkar password
); print("Connected!")

sec = seconddb.cursor()

sec.execute("CREATE TABLE orku_stodvar_eigandi (ID SERIAL PRIMARY KEY, heiti_eigandans VARCHAR);")
sec.execute("CREATE TABLE hnit (ID SERIAL PRIMARY KEY, X_HNIT DOUBLE PRECISION, Y_HNIT DOUBLE PRECISION);")
sec.execute("CREATE TABLE orku (ID SERIAL PRIMARY KEY, stadur VARCHAR NOT NULL UNIQUE, dagsetning_uppsett DATE NOT NULL, hnit_id INT NOT NULL, stodvar_id INT NOT NULL, FOREIGN KEY(hnit_id) REFERENCES hnit(ID), FOREIGN KEY(stodvar_id) REFERENCES orku_stodvar_eigandi(ID));")
sec.execute("CREATE TABLE virkjun (ID INT PRIMARY KEY REFERENCES orku(ID), tegund VARCHAR NOT NULL);")
sec.execute("CREATE TABLE stod (ID INT PRIMARY KEY REFERENCES orku(ID), tegund VARCHAR NOT NULL);")
sec.execute("CREATE TABLE tengdar_stodvar (STOD1 VARCHAR, STOD2 VARCHAR, PRIMARY KEY(STOD1, STOD2), FOREIGN KEY(STOD1) REFERENCES orku(stadur), FOREIGN KEY(STOD2) REFERENCES orku(stadur));")
sec.execute("CREATE TABLE notandi (ID SERIAL PRIMARY KEY, hnit_id INT, stadsetning VARCHAR NOT NULL, kennitala VARCHAR NOT NULL UNIQUE, eigandi VARCHAR NOT NULL, ar_stofnad VARCHAR NOT NULL, FOREIGN KEY(hnit_id) REFERENCES hnit(ID));")
sec.execute("CREATE TABLE maeling ( ID SERIAL PRIMARY KEY, orku_ID INT, sendandi_maelingar VARCHAR NOT NULL, tegund_maelingar VARCHAR NOT NULL, timi TIMESTAMP NOT NULL, FOREIGN KEY (orku_ID) REFERENCES orku(ID));")
sec.execute("CREATE TABLE gildin (ID SERIAL PRIMARY KEY, maeling_ID INT, notandi_ID INT NULL, gildi_kwh NUMERIC NOT NULL, FOREIGN KEY (notandi_ID) REFERENCES notandi(ID), FOREIGN KEY (maeling_ID) REFERENCES maeling(ID));")

with fyrstdb:
    cur.itersize = 20000
    cur.execute("SELECT * FROM raforka_legacy.orku_einingar;")
    for i in cur:

        with seconddb:
            sec.execute("INSERT INTO orku_stodvar_eigandi (heiti_eigandans) VALUES (%s);", (i[4],))
            sec.execute("INSERT INTO hnit (X_HNIT, Y_HNIT) VALUES (%s, %s);", (i[8], i[9]))

            y = i[5]; m = i[6]; d = i[7]
            whole = date(y, m, d)

            sec.execute("INSERT INTO orku (hnit_id, stadur, dagsetning_uppsett, stodvar_id) "
                        "VALUES ((SELECT ID FROM hnit WHERE X_hnit = %s AND Y_HNIT = %s), "
                        "%s, %s, (SELECT ID FROM orku_stodvar_eigandi WHERE heiti_eigandans = %s LIMIT 1));",  ##þarf að taka limit burt 
                        (i[8], i[9], i[1], whole, i[4]))
            
            if i[2] == "stod":
                sec.execute("INSERT INTO stod (ID, tegund)"
                        "VALUES ((SELECT ID FROM orku WHERE stadur = %s), %s);", (i[1], i[2]))
            if i[2] == "virkjun":
                sec.execute("INSERT INTO virkjun (ID, tegund)"
                        "VALUES ((SELECT ID FROM orku WHERE stadur = %s), %s);", (i[1], i[2]))
    for i in cur:
        with seconddb:
            if i[10] is not None:
                sec.execute("INSERT INTO tengdar_stodvar (STOD1, STOD2) VALUES (%s, %s);", (i[1], i[10]))

with fyrstdb:
    cur.itersize = 20000
    cur.execute("SELECT * FROM raforka_legacy.notendur_skraning;")
    for i in cur:

        with seconddb:
            sec.execute("INSERT INTO hnit (X_HNIT, Y_HNIT) VALUES (%s, %s);", (i[5], i[6]))
            sec.execute("INSERT INTO notandi (hnit_id, stadsetning, kennitala, eigandi, ar_stofnad)"
                "VALUES ((SELECT ID FROM hnit WHERE X_HNIT = %s AND Y_HNIT = %s), "
                "%s, %s, %s, %s);", (i[5], i[6], i[1], i[2], i[3], i[4]))

with fyrstdb:
    cur.itersize = 20000
    cur.execute("SELECT * FROM raforka_legacy.orku_maelingar;")
    for i in cur:

        with seconddb:
            sec.execute("INSERT INTO maeling (orku_ID, sendandi_maelingar, tegund_maelingar, timi)"
                "VALUES ((SELECT ID FROM orku WHERE stadur = %s), %s, %s, %s);", 
                (i[1], i[3], i[2], i[4]))
            if i[6] is not None:
                sec.execute("INSERT INTO gildin (maeling_ID, gildi_kwh, notandi_ID) VALUES ("
                    "(SELECT ID FROM maeling WHERE ID = %s), %s, " 
                    "(SELECT ID FROM notandi WHERE stadsetning = %s));", 
                    (i[0], i[5], i[6]))
            else:
                sec.execute("INSERT INTO gildin (maeling_ID, gildi_kwh)"
                        "VALUES ("
                        "(SELECT ID FROM maeling WHERE ID = %s), %s);", 
                        (i[0], i[5]))

print("Geggjað, vírusinn er kominn:)")