fastvuln
========

Authors:

* sinitax (Louis Burda)

Categories:

* web


Overview
--------

A small HTTP service that tests the game infrastructure and the exploit
tooling.

The service is a FastAPI application with a MongoDB backend. It serves its
own OpenAPI documentation at `/docs`. The `SERVICE_PORT` variable sets the
port and the default is 9000.

A user registers with a username, an email address and a password. The
service stores the password as plain text. Login compares the two passwords
and, on a match, writes a session to the database. The response sets the
session token as the `session_id` cookie. A session expires after 600
seconds. A TTL index on the session collection deletes the expired rows.

A logged-in user reads the own profile from `GET /profile` and changes it
with `PUT /profile`. A profile holds a username, an email address, a full
name and a bio. Only the full name and the bio accept changes.

### Flag Store 1

The service keeps a flag in the *bio* of the profile of a checker user. The
checker reads the flag back from `GET /profile` with the session cookie of
that user. The attack info is the username.


Vulnerabilities
---------------

### Flag Store 1, Vuln 1

The route `GET /backdoor` returns the profile of any user. It takes the
username as a query parameter and reads no session cookie. The route carries
no dependency on `get_current_user_id`, so the service applies no
authentication to it.

We can request the profile of the victim by username and read the flag from
the bio. The service lists the route in its own documentation at `/docs`
under the summary "Super secret backdoor".

* Difficulty: easy
* Discoverability: easy
* Patchability: easy
* Categories: web
* Checker exploit: `exploit0`, variant id 0


Patches
-------

### Flag Store 1, Vuln 1

We can mitigate the vulnerability with the removal of the route. No other
route and no checker method calls it, so the service keeps its full function
without it.

### Patch files

* `patches/0-remove-backdoor.sh` applies the fix for exploit variant 0. The
  file is a shell script with an inline unified diff. `enochecker_test` runs
  the script with the working directory set to a copy of `service/`.
