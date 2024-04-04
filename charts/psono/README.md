# Prepate Database
```sql
create extension pgcrypto;
create extension ltree;
```

# Create secrets
```
docker run --rm -it psono/psono-server-enterprise  python3 /root/psono/manage.py generateserverkeys
```

# Create initial user
```
python3 ./psono/manage.py createuser admin@my-logon-domain.com 'p4$$w0rd' admin@my-domain.com
```

# Grant superuser permissions
```
python3 ./psono/manage.py promoteuser admin@my-logon-domain.com superuser
```
