from flask import Flask, abort, request, jsonify
import pymysql
import json
import math

app = Flask(__name__)

MAX_PAGE_SIZE = 100

@app.route("/new_housing_madrid")
def listing():
    page = int(request.args.get('page', 0))
    page_size = int(request.args.get('page_size', MAX_PAGE_SIZE))
    page_size = min(page_size, MAX_PAGE_SIZE)
    rooms = request.args.get('rooms')
    district = request.args.get('district')
    house_type = request.args.get('house_type')

    db_conn = pymysql.connect(
        host="localhost",
        user="root",
        password="16041988",
        database="real_estate",
        cursorclass=pymysql.cursors.DictCursor
    )

    with db_conn.cursor() as cursor:
        sql_query = """
            SELECT
                NHM.id as h_id,
                NHM.rooms,
                NHM.sq_m,
                D.district,
                N.neighborhood,
                HT.house_type
            FROM new_housing_madrid NHM
            JOIN house_type HT on HT.id = NHM.house_type_id
            JOIN neighborhood N on N.id = NHM.neighborhood_id
            JOIN district D on N.district_id = D.id
        """
        params = []

        where_conditions = []

        if rooms:
            where_conditions.append("NHM.rooms = %s")
            params.append(int(rooms))
        
        if district:
            where_conditions.append("D.district = %s")
            params.append(district)
        
        if house_type:
            where_conditions.append("HT.house_type = %s")
            params.append(house_type)

        if where_conditions:
            sql_query += " WHERE " + " AND ".join(where_conditions)

        sql_query += " LIMIT %s OFFSET %s"
        params.extend([page_size, page * page_size])
        
        cursor.execute(sql_query, tuple(params))
        new_housing_madrid = cursor.fetchall()
        
    with db_conn.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) AS total FROM new_housing_madrid")
        total = cursor.fetchone()
        last_page = math.ceil(total['total'] / page_size)

    db_conn.close()
    return jsonify({
        'new_housing_madrid': new_housing_madrid,
        'next_page': f'/new_housing_madrid?page={page + 1}&page_size={page_size}&rooms={rooms}&district={district}&house_type={house_type}' if (page + 1) * page_size < total['total'] else None,
        'last_page': f'/new_housing_madrid?page={last_page - 1}&page_size={page_size}&rooms={rooms}&district={district}&house_type={house_type}' if last_page > 1 else None
    })

