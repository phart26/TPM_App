#!/usr/bin/env python

import json
import mysql.connector
import sys


# input is a key, value list of linear lengths of coils and number of coils with those lengths
# output: sum of all qty of coils
def sumCoils(coilList, tag):
    sum = 0
    for coil in coilList:
        sum += coil[tag]
    
    return sum

# input is a key, value list of linear lengths of coils and number of coils with those lengths, 
# max number of splices, and a max length for the overall combined coil
# creates a 2d list of the combined coils
def getCoilCombos(initCoilList, maxNumSplices, maxLen):
    # initCoilList is an ordered Key, Value list with Key: length in feet and Value: number of coils at that length
    numCoils = sumCoils(initCoilList, 'quantity')
    combinedCoilList= []

    # while the sum of Values in initCoil > 1
    while numCoils > 1:
        combinedCoil = []
        # grab shortest and longest coil and add to combined coil list
        if initCoilList[0]['quantity'] > 0:
            combinedCoil.append({'length' : initCoilList[0]['length'], 'crate' : initCoilList[0]['crate']})
            initCoilList[0]['quantity'] -= 1

            # remove coil if quantity goes to 0
            if initCoilList[0]['quantity'] == 0:
                del initCoilList[0]

            numCoils -= 1
        else:
            del initCoilList[0]
            continue
        
        if initCoilList[-1]['quantity'] > 0:    
            combinedCoil.append({'length' : initCoilList[-1]['length'], 'crate' : initCoilList[-1]['crate']})
            initCoilList[-1]['quantity'] -= 1

            # remove coil if quantity goes to 0
            if initCoilList[-1]['quantity'] == 0:
                del initCoilList[-1]

            numCoils -= 1
        else:
            del initCoilList[-1]
        
        # set inital spot to check to be key at end of init list
        spot = len(initCoilList) - 1
        # while length of the combined coil list is <= maxNumSlices and sum of combo list is <= maxLen
        while len(combinedCoil) < maxNumSplices and sumCoils(combinedCoil, 'length') < (maxLen + maxLen * .1) and spot >= 0:

            print(initCoilList)
            print(spot)

            # if value at spot key of initCoilList > 0 check if key plus sum of combo list is <= maxLen
            if initCoilList[spot]['quantity'] > 0:
                if (sumCoils(combinedCoil, 'length') + initCoilList[spot]['length']) <= (maxLen + maxLen * .1):
                    # True = add key to combo list
                    combinedCoil.append({'length' : initCoilList[spot]['length'], 'crate' : initCoilList[spot]['crate']})
                    initCoilList[spot]['quantity'] -= 1

                    # remove coil if quantity goes to 0
                    if initCoilList[spot]['quantity'] == 0:
                        del initCoilList[spot]
                        spot -= 1

                    numCoils -= 1
                else:
                    spot -= 1
            # else = set key to next key in the init list and remove that length of coil from the list
            else:
                del initCoilList[spot]
                spot -= 1
        
        combinedCoilList.append(combinedCoil)
            
    return combinedCoilList

# input: 2d list of combined coils
# filters through each combined coil list and prints combined coil if two coils less than 50ft were placed together
def printFlagged(combinedCoils):
    for combinedCoil in combinedCoils:
        for spot in range(1, len(combinedCoil)):
            if (combinedCoil[spot]['length'] < 50 and combinedCoil[spot-1]['length'] < 50):
                print(combinedCoil, 'length', sumCoils(combinedCoil, 'length'))
                break

# input: 2d list of coils
# output: 2d list of coils with coils with a length of 30ft or less removed
def removeSmallCoils(coils):
    newCoils = []
    for coil in coils:
        if coil['length'] > 30:
            newCoils.append(coil)

    return newCoils


def add_to_db(mydb, mycursor, coil_list, coil_info):
    # select most recent mesh number
    mycursor.execute("SELECT * FROM mesh_tbl ORDER BY mesh_no DESC")
    meshNum = int((mycursor.fetchone())[0]) + 1
    meshNumCombos = meshNum
    meshNumTbl = meshNum

    # adding new coils to the mesh_combos tbl
    sql = "INSERT INTO mesh_combos (coil_no, line_item, mesh_po, mat_type) VALUES(%s, %s, %s, %s)"
    val = []

    # put coil combo list in right format
    for coil in coil_list:
        tup = (str(meshNumCombos), json.dumps(coil, default=str), coil_info['po'], coil_info['mesh'])
        val.append(tup)
        meshNumCombos += 1

    mycursor.executemany(sql, val)

    mydb.commit()


    # adding new coils to the mesh tbl
    sql = "INSERT INTO mesh_tbl (mesh_no, allocated, job, tpm_po, date_received, width, length, heat, mesh, type, splice_chk) VALUES(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
    val = []

    # put coil combo list in right format
    for coil in coil_list:
        # sum length of coil
        length = sumCoils(coil, 'length')
        tup = (str(meshNumTbl), coil_info['allocated'], coil_info['job'], coil_info['po'], coil_info['date_entered'], coil_info['width'], length, coil_info['heat_num'], coil_info['mesh'], coil_info['type_mat'], 0)
        val.append(tup)
        meshNumTbl += 1

    mycursor.executemany(sql, val)

    mydb.commit()

    # adding po as a job to mesh jobs tbl
    sql = "INSERT INTO mesh_jobs (po, quantity, mat_type, heat) VALUES(%s, %s, %s, %s)"
    val = (coil_info['po'], meshNumTbl - meshNum, coil_info['mesh'], coil_info['heat_num'])
    
    mycursor.execute(sql, val)

    mydb.commit()


# clears the packing list entry table after a new entry is made and the coil combos have been saved
def clear_packList(mydb, mycursor):
    mycursor.execute("DELETE FROM packing_list_entry")
    mydb.commit()

def find_smallest_coil(combinedCoils):
    len_arr = []

    for coil in combinedCoils:
        len_arr.append(sumCoils(coil, 'length'))

    return len_arr.index(min(len_arr))




            
def main():

    # mysql connection
    mydb = mysql.connector.connect(host="localhost", user="root", password="anuj", database="demo_tpm")
    mycursor = mydb.cursor(buffered = True)

    mycursor.execute("SELECT * FROM packing_list_entry")

    row_headers=[x[0] for x in mycursor.description] #this will extract row headers
    rv = mycursor.fetchall()
    coil_data=[]

    if(len(rv) > 0):
        for result in rv:
                coil_data.append(dict(zip(row_headers,result)))

        # remove coils less than 30ft
        coil_data = removeSmallCoils(coil_data)

        #sort original list by length of coils
        coil_data.sort(key = lambda i:i['length'])
        coil_info = coil_data[0]

        # generate combined coil list
        coil_combo_list = getCoilCombos(coil_data, 4, int(coil_data[0]['tot_len'])) # this will be pulled from db/request

        index_small = find_smallest_coil(coil_combo_list)

        # add on remaining coil if it is still within treshold
        for coil in coil_data:
            if(coil['length'] + sumCoils(coil_combo_list[index_small], 'length') <= (int(coil_info['tot_len']) + 40)):
                coil_combo_list[index_small].append({'length': coil['length'], 'crate': coil['crate']})
            else:
                coil_combo_list.append([{'length': coil['length'], 'crate': coil['crate']}])

        
        # print combined coils and calculate the number of coils used to make combined coils
        # endingSum = 0 
        # for coil in coil_combo_list:
        #     print(coil, 'Length', sumCoils(coil, 'length'))
        #     endingSum += len(coil)
            
        # print('Number of combined coils:', len(coil_combo_list))

        # add new coil combos to db
        add_to_db(mydb, mycursor, coil_combo_list, coil_info)

        # # clear the packing list entry table
        clear_packList(mydb, mycursor)


        # print coils where two coils less than 50ft were placed together 
        # printFlagged(coil_combo_list)


if __name__ == '__main__':
    main()