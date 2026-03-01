#!/bin/bash
set -e
COOKIE_JAR=$(mktemp)
BASE="http://127.0.0.1:8000"

echo "[1] Getting CSRF from register page..."
CSRF=$(curl -sc "$COOKIE_JAR" "$BASE/register/" | grep csrfmiddlewaretoken | sed 's/.*value="\([^"]*\)".*/\1/')
echo "CSRF: $CSRF"

echo "[2] Registering user 'blogtester'..."
STATUS=$(curl -sb "$COOKIE_JAR" -c "$COOKIE_JAR" -s -o /dev/null -w "%{http_code}" \
  -X POST "$BASE/register/" \
  -d "username=blogtester&email=blogtester@test.com&password1=Secure123!&password2=Secure123!&csrfmiddlewaretoken=$CSRF" \
  -H "Referer: $BASE/register/")
echo "Register => $STATUS (expect 302)"

echo "[3] Getting login CSRF..."
CSRF2=$(curl -sc "$COOKIE_JAR" -c "$COOKIE_JAR" "$BASE/login/" | grep csrfmiddlewaretoken | sed 's/.*value="\([^"]*\)".*/\1/')
echo "Login CSRF: $CSRF2"

echo "[4] Logging in..."
LOGIN_STATUS=$(curl -sb "$COOKIE_JAR" -c "$COOKIE_JAR" -s -o /dev/null -w "%{http_code}" \
  -X POST "$BASE/login/" \
  -d "username=blogtester&password=Secure123!&csrfmiddlewaretoken=$CSRF2" \
  -H "Referer: $BASE/login/")
echo "Login => $LOGIN_STATUS (expect 302)"

echo "[5] Profile page (must be 200 when logged in)..."
PROF=$(curl -sb "$COOKIE_JAR" -s -o /dev/null -w "%{http_code}" "$BASE/profile/")
echo "Profile => $PROF (expect 200)"

echo "[6] Getting CSRF for post creation..."
CSRF3=$(curl -sb "$COOKIE_JAR" "$BASE/post/new/" | grep csrfmiddlewaretoken | sed 's/.*value="\([^"]*\)".*/\1/')
echo "Post CSRF: $CSRF3"

echo "[7] Creating a blog post..."
POST_S=$(curl -sb "$COOKIE_JAR" -c "$COOKIE_JAR" -s -o /dev/null -w "%{http_code}" \
  -X POST "$BASE/post/new/" \
  -d "title=Hello+DevBlog&content=This+is+my+first+post!&csrfmiddlewaretoken=$CSRF3" \
  -H "Referer: $BASE/post/new/")
echo "Create post => $POST_S (expect 302)"

echo "[8] Checking home page for post cards..."
COUNT=$(curl -sb "$COOKIE_JAR" -s "$BASE/" | grep -c "post-card" || true)
echo "Post cards on home: $COUNT (expect >= 1)"

rm "$COOKIE_JAR"
echo "--- ALL DONE ---"
