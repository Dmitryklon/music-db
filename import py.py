import psycopg2


# =========================
# 1. СОЗДАНИЕ СТРУКТУРЫ БД
# =========================
def create_db(conn):
    with conn.cursor() as cur:
        cur.execute("""
        CREATE TABLE IF NOT EXISTS clients (
            client_id SERIAL PRIMARY KEY,
            first_name VARCHAR(100),
            last_name VARCHAR(100),
            email VARCHAR(150) UNIQUE
        );
        """)

        cur.execute("""
        CREATE TABLE IF NOT EXISTS phones (
            phone_id SERIAL PRIMARY KEY,
            client_id INTEGER REFERENCES clients(client_id) ON DELETE CASCADE,
            phone VARCHAR(50)
        );
        """)
    conn.commit()


# =========================
# 2. ДОБАВЛЕНИЕ КЛИЕНТА
# =========================
def add_client(conn, first_name, last_name, email, phones=None):
    with conn.cursor() as cur:
        cur.execute("""
        INSERT INTO clients (first_name, last_name, email)
        VALUES (%s, %s, %s)
        RETURNING client_id;
        """, (first_name, last_name, email))

        client_id = cur.fetchone()[0]

        if phones:
            for phone in phones:
                cur.execute("""
                INSERT INTO phones (client_id, phone)
                VALUES (%s, %s);
                """, (client_id, phone))

    conn.commit()


# =========================
# 3. ДОБАВЛЕНИЕ ТЕЛЕФОНА
# =========================
def add_phone(conn, client_id, phone):
    with conn.cursor() as cur:
        cur.execute("""
        INSERT INTO phones (client_id, phone)
        VALUES (%s, %s);
        """, (client_id, phone))
    conn.commit()


# =========================
# 4. ИЗМЕНЕНИЕ ДАННЫХ КЛИЕНТА
# =========================
def change_client(conn, client_id, first_name=None, last_name=None, email=None, phones=None):
    with conn.cursor() as cur:

        if first_name:
            cur.execute("""
            UPDATE clients SET first_name=%s WHERE client_id=%s;
            """, (first_name, client_id))

        if last_name:
            cur.execute("""
            UPDATE clients SET last_name=%s WHERE client_id=%s;
            """, (last_name, client_id))

        if email:
            cur.execute("""
            UPDATE clients SET email=%s WHERE client_id=%s;
            """, (email, client_id))

        if phones is not None:
            cur.execute("""
            DELETE FROM phones WHERE client_id=%s;
            """, (client_id,))

            for phone in phones:
                cur.execute("""
                INSERT INTO phones (client_id, phone)
                VALUES (%s, %s);
                """, (client_id, phone))

    conn.commit()


# =========================
# 5. УДАЛЕНИЕ ТЕЛЕФОНА
# =========================
def delete_phone(conn, client_id, phone):
    with conn.cursor() as cur:
        cur.execute("""
        DELETE FROM phones
        WHERE client_id=%s AND phone=%s;
        """, (client_id, phone))
    conn.commit()


# =========================
# 6. УДАЛЕНИЕ КЛИЕНТА
# =========================
def delete_client(conn, client_id):
    with conn.cursor() as cur:
        cur.execute("""
        DELETE FROM clients WHERE client_id=%s;
        """, (client_id,))
    conn.commit()


# =========================
# 7. ПОИСК КЛИЕНТА
# =========================
def find_client(conn, first_name=None, last_name=None, email=None, phone=None):
    with conn.cursor() as cur:
        query = """
        SELECT c.client_id, c.first_name, c.last_name, c.email, p.phone
        FROM clients c
        LEFT JOIN phones p ON c.client_id = p.client_id
        WHERE 1=1
        """
        params = []

        if first_name:
            query += " AND c.first_name = %s"
            params.append(first_name)

        if last_name:
            query += " AND c.last_name = %s"
            params.append(last_name)

        if email:
            query += " AND c.email = %s"
            params.append(email)

        if phone:
            query += " AND p.phone = %s"
            params.append(phone)

        cur.execute(query, tuple(params))
        results = cur.fetchall()

        for row in results:
            print(row)


# =========================
# ДЕМОНСТРАЦИЯ РАБОТЫ
# =========================
with psycopg2.connect(
    database="clients_db",
    user="postgres",
    password="postgres"
) as conn:

    create_db(conn)

    # добавление клиентов
    add_client(conn, "Ivan", "Ivanov", "ivan@mail.com", ["123", "456"])
    add_client(conn, "Petr", "Petrov", "petr@mail.com")

    # добавление телефона
    add_phone(conn, 2, "999")

    # изменение клиента
    change_client(conn, 1, first_name="Ivan", phones=["111", "222"])

    # удаление телефона
    delete_phone(conn, 1, "111")

    # поиск клиента
    print("Поиск по email:")
    find_client(conn, email="ivan@mail.com")

    print("Поиск по телефону:")
    find_client(conn, phone="999")

    # удаление клиента
    delete_client(conn, 2)

conn.close()