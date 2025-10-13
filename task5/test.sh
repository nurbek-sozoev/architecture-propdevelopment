#! /bin/bash
set -eu

NS="${NS:-task5}"
IMAGE="${IMAGE:-alpine/curl:3.19.1}"
TIMEOUT="${TIMEOUT:-3}"

pass=0
fail=0

run_case() {
  role="$1"
  name="$2"
  dst="$3"
  expect="$4"
  kubectl -n "$NS" delete pod "$name" --ignore-not-found --wait=false >/dev/null 2>&1 || true
  if kubectl -n "$NS" run "$name" --image="$IMAGE" --restart=Never --attach=true -i --labels "role=$role" --command -- sh -c "curl -sS --max-time $TIMEOUT http://$dst:3030 >/dev/null"; then
    rc=0
  else
    rc=$?
  fi
  kubectl -n "$NS" delete pod "$name" --ignore-not-found --wait=false >/dev/null 2>&1 || true
  if [ "$expect" = "allow" ] && [ $rc -eq 0 ]; then
    echo "OK $role -> $dst (allow)"
    pass=$((pass+1))
  elif [ "$expect" = "deny" ] && [ $rc -ne 0 ]; then
    echo "OK $role -> $dst (deny)"
    pass=$((pass+1))
  else
    echo "FAIL $role -> $dst (expected $expect)"
    fail=$((fail+1))
  fi
}

# allow
run_case "front-end" "t-fe-to-be" "back-end-api-app" "allow"
run_case "back-end-api" "t-be-to-fe" "front-end-app" "allow"
run_case "admin-front-end" "t-afe-to-abe" "admin-back-end-api-app" "allow"
run_case "admin-back-end-api" "t-abe-to-afe" "admin-front-end-app" "allow"

# deny
run_case "front-end" "t-fe-to-abe" "admin-back-end-api-app" "deny"
run_case "admin-front-end" "t-afe-to-be" "back-end-api-app" "deny"
run_case "back-end-api" "t-be-to-afe" "admin-front-end-app" "deny"
run_case "admin-back-end-api" "t-abe-to-fe" "front-end-app" "deny"

echo "PASS=$pass FAIL=$fail"
if [ "$fail" -gt 0 ]; then
  exit 1
fi
exit 0


