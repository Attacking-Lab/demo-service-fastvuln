#!/bin/sh
# Closes exploit 0: the unauthenticated /backdoor route hands out any user's
# profile (and thus the flag in their bio) by username, with no session check.
# The fix is to drop the route entirely.
set -e

patch -p1 <<'DIFF'
--- a/main.py
+++ b/main.py
@@ -157,20 +157,6 @@
     )


-@app.get("/backdoor", response_model=UserProfile, summary="Super secret backdoor")
-def get_backdoor(username: str):
-    user_data = users.find_one({"username": username})
-    if not user_data:
-        raise HTTPException(status_code=404, detail="User profile not found.")
-
-    return UserProfile(
-        username=user_data["username"],
-        email=user_data["email"],
-        full_name=user_data["full_name"],
-        bio=user_data["bio"],
-    )
-
-
 if __name__ == "__main__":
     import uvicorn
     uvicorn.run(
DIFF
